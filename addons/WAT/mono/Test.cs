#nullable enable
using Godot;
using System;
using System.Collections;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using Godot.Collections;
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

		[AttributeUsage(AttributeTargets.Method)] protected class TestAttribute: Attribute { }
		
		[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
		protected class RunWith : Attribute
		{
			public object[] arguments;

			public RunWith(params object[] args)
			{
				arguments = args;
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

		private MethodInfo? _startMethod;
		private MethodInfo? _preMethod;
		private MethodInfo? _postMethod;
		private MethodInfo? _endMethod;

		public Test()
		{
			_startMethod = GetTestHook(typeof(StartAttribute));
			_preMethod = GetTestHook(typeof(PreAttribute));
			_postMethod = GetTestHook(typeof(PostAttribute));
			_endMethod = GetTestHook(typeof(EndAttribute));
		}
		public Test setup(Dictionary<string, object> metadata)
		{
			_methods = metadata["methods"] is string[] method
				? new Array(string.Join("", method))
				: (Array) metadata["methods"];
			
			_case = (Object) GD.Load<GDScript>("res://addons/WAT/test/case.gd").New(this, metadata);
			return this;
		}

		public async void run()
		{
			int cursor = 0;
			await CallTestHook(_startMethod);
			while (cursor < _methods.Count)
			{
				string currentMethod = (string) _methods[cursor];
				_case.Call("add_method", currentMethod);
				await CallTestHook(_preMethod);
				await Execute(currentMethod)!;
				await CallTestHook(_postMethod);
				cursor++;
			}

			await CallTestHook(_endMethod);
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
			if (hook?.Invoke(this, null) is Task task)
			{
				await task;
			}
			else
			{
				await Task.Run(() => Task.CompletedTask);
			}
		}
		
	
		private async Task? Execute(string method)
		{
			if (GetType().GetMethod(method)?.Invoke(this, null) is Task task)
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
		
		private Array<string> GetTestMethods()
		{
			return new Array<string>(GetType().GetMethods()
				.Where(m => m.IsDefined(typeof(TestAttribute)))
				.Select(info => info.Name).ToList());
		}
		
		public void Simulate(Node obj, int times, float delta)
		{
			for (int i = 0; i < times; i++)
			{
				if (obj.HasMethod("_Process"))
				{
					obj._Process(delta);
				}

				if (obj.HasMethod("_PhysicsProcess"))
				{
					obj._PhysicsProcess(delta);
				}

				foreach (Node kid in obj.GetChildren())
				{
					Simulate(kid, 1, delta);
				}
			}
		}
		
		// private Godot.Collections.Array GenerateTestMethods(IEnumerable names)
		// {
		// 	Godot.Collections.Array methods = new Godot.Collections.Array();
		// 	foreach (string name in names)
		// 	{
		// 		MethodInfo methodInfo = GetType().GetMethod(name)!;
		// 		if (methodInfo.IsDefined(typeof(RunWith)))
		// 		{
		// 			foreach (Attribute attribute in System.Attribute.GetCustomAttributes(methodInfo)
		// 				.Where(attr => attr is RunWith))
		// 			{
		// 				// Could probably use system array?
		// 				Godot.Collections.Array args = new Godot.Collections.Array();
		// 				Dictionary info = new Dictionary{{"name", methodInfo.Name}, {"args", args}};
		// 				methods.Add(info);
		// 			}
		// 		}
		// 		else
		// 		{
		// 			Dictionary info = new Dictionary {{"name", methodInfo.Name}, {"args", null}};
		// 		}
		// 	}
		// 	return methods;
		// }
		//
		// private Godot.Collections.Array GenerateTestMethods(string method)
		// {
		// 	return GenerateTestMethods(new Array{method});
		// }
	}
}
