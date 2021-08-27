using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Godot.Collections;
using Object = Godot.Object;

namespace WAT 
{
	[Start(nameof(Blank))]
	[Pre(nameof(Blank))]
	[Post(nameof(Blank))]
	[End(nameof(Blank))]
	public partial class Test : Node
	{
		[Signal] private delegate void EventRaised();
		[Signal] public delegate void described();
		private const int Recorder = 0; // Apparently we require the C# Version
		private IEnumerable<Executable> _methods = null;
		private Object _case = null;
		private static GDScript TestCase { get; } = GD.Load<GDScript>("res://addons/WAT/test/case.gd");
		private Reference _watcher { get; set; }
		protected Timer Yielder { get; private set; }
		protected Assertions Assert { get; private set; }
		protected Type _type;

		protected Test() { _type = GetType(); }
		public void Blank() { }

		public override void _Ready()
		{
		
			_watcher = (Reference) GD.Load<GDScript>("res://addons/WAT/test/watcher.gd").New();
			Yielder = (Timer) GD.Load<GDScript>("res://addons/WAT/test/yielder.gd").New();
			Assert = new Assertions();
			Assert.Connect(nameof(Assertions.asserted), _case, "_on_asserted");
			Assert.Connect(nameof(Assertions.asserted), this, nameof(OnAssertion));
			Connect(nameof(described), _case, "_on_test_method_described");
			AddChild(Yielder);
			CallDeferred(nameof(Run));
		}

		private async void Run()
		{
			// Can we do this in _Ready
			MethodInfo start = GetTestHook(typeof(StartAttribute));
			MethodInfo pre = GetTestHook(typeof(PreAttribute));
			MethodInfo post = GetTestHook(typeof(PostAttribute));
			MethodInfo end = GetTestHook(typeof(EndAttribute));
			await CallTestHook(start);
			foreach (Executable test in _methods)
			{
				_case.Call("add_method", test.Method.Name);
				EmitSignal(nameof(test_method_started), test.Method.Name);
				await CallTestHook(pre);
				await Execute(test);
				EmitSignal(nameof(test_method_finished));
				await CallTestHook(post);
			}

			await CallTestHook(end);
			EmitSignal(nameof(test_script_finished), GetResults());
		}
		
		private string Title()
		{
			if (!Attribute.IsDefined(_type, typeof(TitleAttribute))) return _type.Name;
			TitleAttribute title = (TitleAttribute) Attribute.GetCustomAttribute(_type, typeof(TitleAttribute));
			return title.Title;
		}

		private MethodInfo GetTestHook(Type attributeType)
		{
			HookAttribute hook = (HookAttribute) Attribute.GetCustomAttribute(_type, attributeType);
			return _type.GetMethod(hook.Method);
		}

		private async Task CallTestHook(MethodInfo hook)
		{
			if (hook.Invoke(this, null) is Task task) { await task; } else { await Task.Run((() => { })); }
		}

		private async Task Execute(Executable test)
		{
			if (test.Method.Invoke(this, test.Arguments) is Task task) { await task; }
			else { await Task.Run((() => { })); }
		}
		
		protected void Describe(string description) 
		{ 
			EmitSignal(nameof(described), description);
		}

		protected SignalAwaiter UntilTimeout(double time) { return ToSignal((Timer) Yielder.Call("until_timeout", time), "finished"); }

		protected SignalAwaiter UntilSignal(Godot.Object emitter, string signal, double time)
		{
			_watcher.Call("watch", emitter, signal);
			return ToSignal((Timer) Yielder.Call("until_signal", time, emitter, signal), "finished");
		}
		
		protected async Task<TestEventData> UntilEvent(object sender, string handle, double time)
		{
			EventInfo eventInfo = sender.GetType().GetEvent(handle);
			MethodInfo methodInfo = GetType().GetMethod("OnEventRaised");
			Delegate handler = Delegate.CreateDelegate(eventInfo.EventHandlerType, this, methodInfo);
			eventInfo.AddEventHandler(sender, handler);
			object[] results = await UntilSignal(this, nameof(EventRaised), time);
			eventInfo.RemoveEventHandler(sender, handler);
			Godot.Collections.Array ourResults = (Godot.Collections.Array) results[0];
			return (TestEventData) ourResults[0] ?? new TestEventData(null, null);
		}
		
		public void OnEventRaised(object sender = null, EventArgs args = null)
		{
			EmitSignal(nameof(EventRaised), new TestEventData(sender, args));
		}

		protected class TestEventData: Godot.Object
		{
			public object Sender { get; }
			public EventArgs Arguments { get; }

			public TestEventData(object sender, EventArgs arguments)
			{
				Sender = sender;
				Arguments = arguments;
			}
		}
		
		protected void Watch(Godot.Object emitter, string signal) { _watcher.Call("watch", emitter, signal); }
		protected void UnWatch(Godot.Object emitter, string signal) { _watcher.Call("unwatch", emitter, signal); }
		
		public void Simulate(Node obj, int times, float delta)
		{
			for (int i = 0; i < times; i++)
			{
				if (obj.HasMethod("_Process")) { obj._Process(delta); }
				if (obj.HasMethod("_PhysicsProcess")) { obj._PhysicsProcess(delta); }
				foreach (Node kid in obj.GetChildren()) { Simulate(kid, 1, delta); }
			}
		}

		private IEnumerable<Executable> GenerateTestMethods(IEnumerable<string> names)
		{
			return (from methodInfo in _type.GetMethods().Where(info => names.Contains(info.Name))
				let tests = Attribute.GetCustomAttributes(methodInfo)
					.OfType<TestAttribute>()
				from attribute in tests
				select new Executable(methodInfo, attribute.Arguments)).ToList();
		}
		
		private Dictionary GetResults()
		{
			_case.Call("calculate"); // #")
			Dictionary results = (Dictionary) _case.Call("to_dictionary");
			_case.Free();
			return results;
		}
		
		private class Executable
		{
			public readonly MethodInfo Method;
			public readonly object[] Arguments;

			public Executable(MethodInfo method, object[] arguments)
			{
				Method = method;
				Arguments = arguments;
			}
		}
	}
}
