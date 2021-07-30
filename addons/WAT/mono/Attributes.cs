using System;
using Godot;

namespace WAT
{
	public partial class Test: Node
	{
		[AttributeUsage(AttributeTargets.Class)]
		protected class TitleAttribute : Attribute
		{
			public readonly string Title;

			public TitleAttribute(string title)
			{
				Title = title;
			}
		}
		
		[AttributeUsage(AttributeTargets.Class)] 
		protected class HookAttribute : Attribute
		{
			public readonly string Method;
			protected HookAttribute(string method) => Method = method;
		}
		
		[AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
		protected class TestAttribute : Attribute
		{
			public readonly object[] Arguments;
			public TestAttribute(params object[] args) { Arguments = args; }
		}
		
		protected class StartAttribute : HookAttribute { public StartAttribute(string method) : base(method) { } }
		protected class PreAttribute : HookAttribute { public PreAttribute(string method) : base(method) { } }
		protected class PostAttribute : HookAttribute { public PostAttribute(string method) : base(method) { } }
		protected class EndAttribute : HookAttribute { public EndAttribute(string method) : base(method) { } }
	}
}
