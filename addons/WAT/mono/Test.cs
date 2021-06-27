using Godot;
using System;
using System.Linq;
using System.Reflection;
using Godot.Collections;

namespace WAT 
{
	public class Test : Node
	{
		#region GDScriptWrappers
		// ReSharper disable InconsistentNaming
		[Signal] public delegate void described();
		[Signal] public delegate void cancelled();
		public Assertions asserts => Assert;
		public Reference parameters;
		public Node recorder;
		public Reference watcher;
		public Node direct;
		public Timer yielder;
		public Reference any;
		public bool rerun_method = false;
		public string title() => Title();
		public void start() => Start();
		public void pre() => Pre();
		public void post() => Post();
		public void end() => End();
		public Array<string> methods() => GetTestMethods();
		public void _on_last_assertion(Dictionary result){}

		#endregion
		
		[AttributeUsage(AttributeTargets.Method)] protected class TestAttribute: Attribute { }
		
		public const bool TEST = true;
		protected Assertions Assert = new Assertions();
		
		public virtual string Title() { return GetType().Name; }
		
		public virtual void Start() { }
		
		public virtual void Pre() { }
		
		public virtual void Post() { }
		
		public virtual void End() { }

		public Godot.Collections.Array<string> GetTestMethods()
		{
			return new Godot.Collections.Array<string>(GetType().GetMethods()
				.Where(m => m.IsDefined(typeof(TestAttribute)))
				.Select(info => info.Name).ToList());
		}
	}
}
