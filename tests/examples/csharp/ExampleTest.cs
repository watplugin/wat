using System;

namespace Tests.Examples.CSharp 
{
	// Developers may use the [Title] attribute on a Test which will then use..
	// ..string as the name of the Test in the Results View
	[Title("My Example Test")]
	
	// See target methods for more information
	[Start(nameof(RunBeforeTestClass))]
	[Pre(nameof(RunBeforeTestMethod))]
	[Post(nameof(RunAfterTestMethod))]
	[End(nameof(RunAfterTestClass))]
	
	// All Tests in WAT must derive from WAT.Test and be stored in the.. 
	// ..user-defined Test Directory. It extends from Godot's Node Class.. 
	// ..and is added to the SceneTree when being executed (therefore if.. 
	// ..Developers require any of their Units under test to be in the 
	// ..SceneTree, they can add those Units as children to the current Test).
	public class ExampleTest : WAT.Test
	{
		// Any Method in a Test Class decorated with the [Test] attribute..
		// ..will be run by the WAT Test Runner.
		[Test]
		public void MySimpleTest()
		{
			// Developers may use the Describe method passing in a string..
			// ..description that will have the method show up as that string.. 
			// ..instead of the method name in the results view.
			Describe("This Is My Simple Test");

			// Assertions may be called through the Asserts property of..
			// ..WAT.Test. Any test method with a failing assertion (or no..
			// ..assertions at all) will show up as a failed test in the..
			// ..results view.

			// All Assertions have an optional string context as their..
			// ..last argument which will have the assertion show up..
			// ..with that as its description in the results view.
			Assert.IsTrue(true, "Optional Context Argument");
		}

		// Developers can perform the same test method with different..
		// ..arguments by passing those arguments into the constructor..
		// ..of the Test attribute and then defining the same number..
		// ..of parameters in the Test Method itself.
		[Test(2, 2, 4)]
		[Test(4, 4, 8)]
		[Test(6, 6, 12)]
		public void MyParameterizedTest(int a, int b, int expected)
		{
			int sum = a + b;
			string context = a + " + " + b + " = " + expected;
			Assert.IsEqual(expected, sum, context);
		}

		public void RunBeforeTestClass()
		{
			Console.WriteLine("Developers may target a method with the" + 
			"[Start] attribute to execute code before any test method is run");
		}

		public void RunBeforeTestMethod()
		{
			Console.WriteLine("Developers may target a method with the" + 
			"[Pre] attribute to execute code before each test method is run");
		}

		public void RunAfterTestMethod()
		{
			Console.WriteLine("Developers may target a method with the" + 
			"[Post] attribute to execute code after each test method is run");
		}

		public void RunAfterTestClass()
		{
			Console.WriteLine("Developers may target a method with the" + 
			"[End] attribute to execute after all tests method have run");
		}
	}
}
