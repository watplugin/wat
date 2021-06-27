using Godot;
using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Godot.Collections;

namespace WAT 
{
	public class Test : Node
	{
		#region GDScriptWrappers
		// ReSharper disable InconsistentNaming
		[Signal] public delegate void described();
		[Signal] public delegate void cancelled();
		[Signal] public delegate void completed();
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

		public Test execute(string what)
		{
			Task result = CallMethod(what).ContinueWith(r => { CallDeferred("emit_signal", nameof(completed));});
			return this;
		}

		private async Task CallMethod(string method)
		{
			await (Task) Call(method);
		}
		
		public Array<string> methods() => GetTestMethods();
		public void _on_last_assertion(Dictionary result){}

		#endregion

		protected const string YIELD = "finished";
		[AttributeUsage(AttributeTargets.Method)] protected class TestAttribute: Attribute { }
		
		public const bool TEST = true;
		protected Assertions Assert = new Assertions();
		
		public virtual string Title() { return GetType().Name; }
		public virtual void Describe(string description) { EmitSignal(nameof(described), description);}
		
		public virtual void Start() { }
		
		public virtual void Pre() { }
		
		public virtual void Post() { }
		
		public virtual void End() { }
		
		protected Timer UntilTimeout(double time) { return (Timer) yielder.Call("until_timeout", time); }

		protected Timer UntilSignal(Godot.Object emitter, string signal, double time)
		{
			watcher.Call("watch", emitter, signal);
			return (Timer) yielder.Call("until_signal", time, emitter, signal);
		}

		protected void Watch(Godot.Object emitter, string signal) { watcher.Call("watch", emitter, signal); }
		protected void UnWatch(Godot.Object emitter, string signal) { watcher.Call("unwatch", emitter, signal); }


		private Array<string> GetTestMethods()
		{
			return new Array<string>(GetType().GetMethods()
				.Where(m => m.IsDefined(typeof(TestAttribute)))
				.Select(info => info.Name).ToList());
		}
	}
}
