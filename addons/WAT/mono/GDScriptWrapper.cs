using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Godot;
using Array = Godot.Collections.Array;
using Object = Godot.Object;
// ReSharper disable InconsistentNaming


namespace WAT
{
	
	public partial class Test: Node
	{
		[Signal] public delegate void test_method_started();
		[Signal] public delegate void asserted();
		[Signal] public delegate void test_method_finished();
		[Signal] public delegate void test_script_finished();
		
		private const bool IS_WAT_TEST = true;
		
		private void OnAssertion(Godot.Collections.Dictionary assertion)
		{
			EmitSignal(nameof(asserted), assertion);
		}
		
		public String title() { return Title(); }
		
		public Array get_test_methods()
		{
			return new Array
			(GetType().GetMethods().
				Where(m => m.IsDefined(typeof(TestAttribute))).
				Select(m => (string) m.Name).ToList());
		}
		
		public Test setup(string directory, string filepath, IEnumerable<string> methods)
		{
			_methods = GenerateTestMethods(methods);
			_case = (Object) GD.Load<GDScript>("res://addons/WAT/test/case.gd").New(directory, filepath, Title(), this);
			return this;
		}
		
	}
}
