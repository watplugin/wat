using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Godot.Collections;
using Object = Godot.Object;
using Expression = System.Linq.Expressions.Expression;

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

			_watcher = (Reference)GD.Load<GDScript>("res://addons/WAT/test/watcher.gd").New();
			Yielder = (Timer)GD.Load<GDScript>("res://addons/WAT/test/yielder.gd").New();
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
			TitleAttribute title = (TitleAttribute)Attribute.GetCustomAttribute(_type, typeof(TitleAttribute));
			return title.Title;
		}

		private MethodInfo GetTestHook(Type attributeType)
		{
			HookAttribute hook = (HookAttribute)Attribute.GetCustomAttribute(_type, attributeType);
			return _type.GetMethod(hook.Method);
		}

		private async Task CallTestHook(MethodInfo hook)
		{
			try
			{
				if (hook.Invoke(this, null) is Task task) { await task; } else { await Task.Run((() => { })); }
			}
			catch (Exception e)
			{
				GD.PushError($"WAT: {e}");
			}
		}

		private async Task Execute(Executable test)
		{
			try
			{
				if (test.Method.Invoke(this, test.Arguments) is Task task) { await task; }
				else { await Task.Run((() => { })); }
			}
			catch (Exception e)
			{
				GD.PushError($"WAT: {e}");
			}
		}

		protected void Describe(string description)
		{
			EmitSignal(nameof(described), description);
		}
		

		enum RunAll {
			NOT_RUN_ALL,
			NORMAL_RUN_ALL,
			DEBUG_RUN_ALL
		}
		
		protected bool IsAnyRunAll() {
			int result = OS.GetEnvironment("WAT_RUN_ALL_MODE").ToInt();
			return (result == (int) RunAll.NORMAL_RUN_ALL || result == (int) RunAll.DEBUG_RUN_ALL);
		}
		
		protected bool IsNormalRunAll() {
			int result = OS.GetEnvironment("WAT_RUN_ALL_MODE").ToInt();
			return result == (int) RunAll.NORMAL_RUN_ALL;
		}
		
		protected bool IsDebugRunAll() {
			int result = (int) OS.GetEnvironment("WAT_RUN_ALL_MODE").ToInt();
			return result == (int) RunAll.DEBUG_RUN_ALL;
		}

		protected SignalAwaiter UntilTimeout(double time) { return ToSignal((Timer)Yielder.Call("until_timeout", time), "finished"); }

		protected SignalAwaiter UntilSignal(Godot.Object emitter, string signal, double time)
		{
			_watcher.Call("watch", emitter, signal);
			return ToSignal((Timer)Yielder.Call("until_signal", time, emitter, signal), "finished");
		}

		protected async Task<TestEventData> UntilEventHandlerEvent(object sender, string handle, double time)
		{
			EventInfo eventInfo = sender.GetType().GetEvent(handle);
			MethodInfo methodInfo = GetType().GetMethod(nameof(OnEventHandlerEventRaised));
			Delegate handler = Delegate.CreateDelegate(eventInfo.EventHandlerType, this, methodInfo);
			eventInfo.AddEventHandler(sender, handler);
			object[] results = await UntilSignal(this, nameof(EventRaised), time);
			eventInfo.RemoveEventHandler(sender, handler);
			Godot.Collections.Array ourResults = (Godot.Collections.Array)results[0];
			return (TestEventData)ourResults[0] ?? new TestEventData(null, null);
		}

		public void OnEventHandlerEventRaised(object sender = null, EventArgs args = null)
		{
			EmitSignal(nameof(EventRaised), new TestEventData(sender, args));
		}

		#region UntilEvent<T>
		protected Task<object[]> UntilEvent<T1>(object sender, string handle, double time, Action<T1> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2>(object sender, string handle, double time, Action<T1, T2> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3>(object sender, string handle, double time, Action<T1, T2, T3> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4>(object sender, string handle, double time, Action<T1, T2, T3, T4> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15> callback) => UntilEvent(sender, handle, time, (Delegate)callback);

		protected Task<object[]> UntilEvent<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(object sender, string handle, double time, Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16> callback) => UntilEvent(sender, handle, time, (Delegate)callback);
		#endregion

		protected async Task<object[]> UntilEvent(object sender, string handle, double time, Delegate callback = null)
		{
			EventInfo eventInfo = sender.GetType().GetEvent(handle);
			var parameters = eventInfo.EventHandlerType
				.GetMethod("Invoke")
				.GetParameters()
				.Select(parameter => Expression.Parameter(parameter.ParameterType))
				.ToArray();

			Expression onEventRaisedInvoke = Expression.Call(Expression.Constant(this), GetType().GetMethod(nameof(OnEventRaised)), Expression.NewArrayInit(typeof(object), parameters.Select(x => Expression.Convert(x, typeof(object)))));
			Expression body;
			if (callback == null)
				body = onEventRaisedInvoke;
			else
				body = Expression.Block(
					Expression.Invoke(Expression.Constant(callback), parameters),
					onEventRaisedInvoke
				);

			var handler = Expression.Lambda(
					eventInfo.EventHandlerType,
					body,
					parameters
				)
				.Compile();

			eventInfo.AddEventHandler(sender, handler);
			var results = await UntilSignal(this, nameof(EventRaised), time);
			eventInfo.RemoveEventHandler(sender, handler);

			var godotArray = (Godot.Collections.Array)results.First();
			return godotArray.Cast<object>().Take(parameters.Length).ToArray();
		}

		public void OnEventRaised(params object[] parameters)
		{
			EmitSignal(nameof(EventRaised), parameters);
		}

		protected class TestEventData : Godot.Object
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
			Dictionary results = (Dictionary)_case.Call("to_dictionary");
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
