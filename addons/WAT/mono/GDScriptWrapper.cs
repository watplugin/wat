using System;
using System.Linq;
using System.Reflection;
using Godot;
using Godot.Collections;
using JetBrains.Annotations;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace WAT
{
	public partial class Test: Node
	{
		[Signal] public delegate void executed();

		public Array get_test_methods()
		{
			return new Array
			(GetType().GetMethods().
				Where(m => m.IsDefined(typeof(TestAttribute))).
				Select(m => (string) m.Name).ToList());
		}
		
		public Dictionary get_results()
		{
			_case.Call("calculate"); // #")
			Dictionary results = (Dictionary) _case.Call("to_dictionary");
			_case.Free();
			return results;
		}

		public Test setup(string directory, string filepath, Array methods)
		{
			Console.WriteLine(methods.GetType());
			Console.WriteLine(methods[0]);
			_methods = methods;
			_case = (Object) GD.Load<GDScript>("res://addons/WAT/test/case.gd").New(directory, filepath, Title(), this);
			return this;
		}
		
		private async void run() => await Run();

		private static bool _is_wat_test() => true;
	}
}
