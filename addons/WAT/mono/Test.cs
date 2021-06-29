#nullable enable
using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using Godot.Collections;
using JetBrains.Annotations;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace WAT 
{
	public class Test : Node
	{
		[AttributeUsage(AttributeTargets.Class)] 
		protected class HookAttribute : Attribute
		{
			public readonly string Method;
			protected HookAttribute(string method) => Method = method;
		}
		
		protected class StartAttribute : HookAttribute { public StartAttribute(string method) : base(method) { } }
		protected class PreAttribute : HookAttribute { public PreAttribute(string method) : base(method) { } }
		protected class PostAttribute : HookAttribute { public PostAttribute(string method) : base(method) { } }
		protected class EndAttribute : HookAttribute { public EndAttribute(string method) : base(method) { } }

		[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
		protected class TestAttribute : Attribute
		{
			public readonly object[] Arguments = new object[0];
			public TestAttribute() {}

			public TestAttribute(params object[] args)
			{
				Arguments = args;
			}
		}
		
		[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
		protected class RunWith : Attribute
		{
			public object[] Arguments;

			public RunWith(params object[] args)
			{
				Arguments = args;
			}
		}
		
		[Signal] public delegate void executed();
		[Signal] public delegate void Described();

		private const string YIELD = "finished";
		private const bool TEST = true;
		private const int Recorder = 0; // Apparently we require the C# Version
		private Godot.Collections.Array _methods = new Godot.Collections.Array();
		private Object _case;
		private static readonly GDScript Any = GD.Load<GDScript>("res://addons/WAT/test/any.gd");
		private readonly Reference _watcher = (Reference) GD.Load<GDScript>("res://addons/WAT/test/watcher.gd").New();
		private readonly Object _registry = (Object) GD.Load<GDScript>("res://addons/WAT/double/registry.gd").New();
		protected readonly Node Direct = (Node) GD.Load<GDScript>("res://addons/WAT/double/factory.gd").New();
		protected readonly Timer Yielder = (Timer) GD.Load<GDScript>("res://addons/WAT/test/yielder.gd").New();
		protected Assertions Assert = new Assertions();

		public Test()
		{
			
		}

		public Test setup(Godot.Collections.Dictionary<string, object> metadata)
		{
			_methods = metadata["methods"] is string[] method
				? new Array{string.Join("", method) }
				: (Array) metadata["methods"];
			
			GD.Print(_methods.Count);
			_case = (Object) GD.Load<GDScript>("res://addons/WAT/test/case.gd").New(this, metadata);
			return this;
		}

		public async void run()
		{
			Type type = GetType();
			List<ExecutableTest> methods = GenerateTestMethods().ToList();
			MethodInfo? start = GetTestHook(typeof(StartAttribute));
			MethodInfo? pre = GetTestHook(typeof(PreAttribute));
			MethodInfo? post = GetTestHook(typeof(PostAttribute));
			MethodInfo? end = GetTestHook(typeof(EndAttribute));
			int cursor = 0;
			await CallTestHook(start);
			while (cursor < methods.Count)
			{
				ExecutableTest test = methods[cursor];
				_case.Call("add_method", test.Method.Name);
				await CallTestHook(pre);
				await Execute(test)!;
				await CallTestHook(post);
				cursor++;
			}

			await CallTestHook(end);
			EmitSignal(nameof(executed));
		}

		private MethodInfo? GetTestHook(Type attributeType)
		{
			if (Attribute.IsDefined(GetType(), attributeType) && 
				Attribute.GetCustomAttribute(GetType(), attributeType) is HookAttribute hookAttribute)
			{
				return GetType().GetMethod(hookAttribute.Method);
			}
			return null;
		}

		private async Task CallTestHook(MethodInfo? hook)
		{
			if (hook?.Invoke(this, null) is Task task) { await task; }
			else { await Task.Run(() => { }); }
		}
		
	
		private async Task? Execute(ExecutableTest test)
		{
			if (test.Method.Invoke(this, test.Arguments) is Task task)
			{
				await task;
			}
		}
		
		protected void Describe(string description) {EmitSignal(nameof(Described), description);}
		private string title() { return Title(); }
		public virtual string Title() { return GetType().Name; }

		protected SignalAwaiter UntilTimeout(double time)
		{
			return ToSignal((Timer) Yielder.Call("until_timeout", time), YIELD);
		}

		protected SignalAwaiter UntilSignal(Godot.Object emitter, string signal, double time)
		{
			_watcher.Call("watch", emitter, signal);
			return ToSignal((Timer) Yielder.Call("until_signal", time, emitter, signal), YIELD);
		}
		public override void _Ready()
		{
			Direct.Set("registry", _registry);
			Assert.Connect(nameof(Assertions.asserted), _case, "_on_asserted");
			Connect(nameof(Described), _case, "_on_test_method_described");
			AddChild(Direct);
			AddChild(Yielder);
		}

		public Dictionary get_results()
		{
			_case.Call("calculate"); // #")
			Dictionary results = (Dictionary) _case.Call("to_dictionary");
			_case.Free();
			return results;
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

		private IEnumerable<ExecutableTest> GenerateTestMethods()
		{
			return (from methodInfo in GetType().GetMethods().Where(info => _methods.Contains(info.Name))
				let tests = Attribute.GetCustomAttributes(methodInfo)
					.OfType<TestAttribute>()
				from attribute in tests
				select new ExecutableTest(methodInfo, attribute.Arguments)).ToList();
		}
		
		[UsedImplicitly]
		public Array get_script_method_list()
		{
			Array array = new Array();
			foreach (MethodInfo method in GetType().GetMethods().Where(m => m.IsDefined(typeof(TestAttribute))))
			{
				array.Add(method.Name);
			}

			return array;
		}
		
		
		private class ExecutableTest
		{
			public readonly MethodInfo Method;
			public readonly object[] Arguments;

			public ExecutableTest(MethodInfo method, object[] arguments)
			{
				Method = method;
				Arguments = arguments;
			}
		}
	}
}
