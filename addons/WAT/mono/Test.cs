#nullable enable
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Godot.Collections;
using JetBrains.Annotations;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace WAT 
{
	[Start(nameof(Blank))]
	[Pre(nameof(Blank))]
	[Post(nameof(Blank))]
	[End(nameof(Blank))]
	public partial class Test : Node
	{
		[Signal] public delegate void Described();
		[Signal] public delegate void TestExecuted();
		private string Executed => nameof(TestExecuted);
		private const int Recorder = 0; // Apparently we require the C# Version
		private Godot.Collections.Array _methods = new Godot.Collections.Array();
		private Object _case;
		private static readonly GDScript TestCase = GD.Load<GDScript>("res://addons/WAT/test/case.gd");
		private static readonly GDScript Any = GD.Load<GDScript>("res://addons/WAT/test/any.gd");
		private readonly Reference _watcher = (Reference) GD.Load<GDScript>("res://addons/WAT/test/watcher.gd").New();
		private readonly Object _registry = (Object) GD.Load<GDScript>("res://addons/WAT/double/registry.gd").New();
		//protected readonly Node Direct = (Node) GD.Load<GDScript>("res://addons/WAT/double/factory.gd").New();
		protected readonly Timer Yielder = (Timer) GD.Load<GDScript>("res://addons/WAT/test/yielder.gd").New();
		protected readonly Assertions Assert = new Assertions();
		private Type Type;

		public Test()
		{
			
		}

		public Test(string directory, string filepath, Array methods)
		{
			Type = GetType();
			_case = (Object) TestCase.New(directory, filepath, Title(), this);
			_methods = methods;
		}
		
		private void Blank() { }

		public override async void _Ready()
		{
			//Direct.Set("registry", _registry);
			Assert.Connect(nameof(Assertions.asserted), _case, "_on_asserted");
			Connect(nameof(Described), _case, "_on_test_method_described");
			//AddChild(Direct);
			AddChild(Yielder);
			CallDeferred(nameof(Run)); //Run();
		}

		private async void Run()
		{
			// Can we do this in _Ready?
			MethodInfo start = GetTestHook(typeof(StartAttribute));
			MethodInfo pre = GetTestHook(typeof(PreAttribute));
			MethodInfo post = GetTestHook(typeof(PostAttribute));
			MethodInfo end = GetTestHook(typeof(EndAttribute));
			await CallTestHook(start);
			foreach (Executable test in GenerateTestMethods())
			{
				_case.Call("add_method", test.Method.Name);
				await CallTestHook(pre);
				await Execute(test)!;
				await CallTestHook(post);
			}

			await CallTestHook(end);
			EmitSignal(Executed, GetResults());
		}
		
		private string Title()
		{
			if (!Attribute.IsDefined(GetType(), typeof(TitleAttribute))) return GetType().Name;
			TitleAttribute title = (TitleAttribute) Attribute.GetCustomAttribute(GetType(), typeof(TitleAttribute));
			return title.Title;
		}

		private MethodInfo GetTestHook(Type attributeType)
		{
			HookAttribute hook = (HookAttribute) Attribute.GetCustomAttribute(GetType(), attributeType);
			return GetType().GetMethod(hook.Method)!;
		}

		private async Task CallTestHook(MethodInfo hook)
		{
			if (hook?.Invoke(this, null) is Task task) { await task; } else { await Task.Run((() => { })); }
		}

		private async Task Execute(Executable test)
		{
			if (test.Method.GetCustomAttribute(typeof(DescriptionAttribute)) is DescriptionAttribute description) { EmitSignal(nameof(Described), description.Description); }
			if (test.Method.Invoke(this, test.Arguments) is Task task) { await task; }
			else { await Task.Run((() => { })); }
		}

		protected SignalAwaiter UntilTimeout(double time) { return ToSignal((Timer) Yielder.Call("until_timeout", time), "finished"); }

		protected SignalAwaiter UntilSignal(Godot.Object emitter, string signal, double time)
		{
			_watcher.Call("watch", emitter, signal);
			return ToSignal((Timer) Yielder.Call("until_signal", time, emitter, signal), "finished");
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

		private IEnumerable<Executable> GenerateTestMethods()
		{
			return (from methodInfo in GetType().GetMethods().Where(info => _methods.Contains(info.Name))
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
