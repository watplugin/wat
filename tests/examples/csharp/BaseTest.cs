using System;

namespace Tests.Examples.CSharp 
{
    // Title changes how the Test Class is displayed in the results View
    [Title("My Example Test")]
    
    // The following four attributes define the "Test Hooks" of the Test Class
    [Start(nameof(RunBeforeTestClass))]
    [Pre(nameof(RunBeforeTestMethod))]
    [Post(nameof(RunAfterTestMethod))]
    [End(nameof(RunAfterTestClass))]
    
    // All Tests must derive from WAT.Test
    public class BaseTest : WAT.Test
    {
        
        // Any Method in a Test Class decorated with the [Test] attribute..
        // ..will be run by the WAT Test Runner.
        [Test]
        public void MySimpleTest()
        {
            // Describe is an optional method that takes a string argument..
            // ..which will then be displayed instead of the Test Method Name..
            // ..in the results view.
            Describe("This Is My Simple Test");
            
            // Assertions are called through the Assert Property of WAT.Test..
            // ..The last argument of every assertion is an optional context..
            // ..argument. If used, this will be displayed as the assertions..
            // ..name in the results view.
            Assert.IsTrue(true, "Optional Context Argument");
        }
        
        // Developers can perform the same test method with different arguments..
        // ..by passing those arguments into a [Test(args)] attribute and defining..
        // ..the same number of parameters in the Test Method. 
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
            Console.WriteLine("When targeted by the [Start] attribute this is run once before" +
                              "before any test method in the class");
        }

        public void RunBeforeTestMethod()
        {
            Console.WriteLine("When targeted by the [Pre] attribute this is run before" +
                              "each test method in the class");
        }

        public void RunAfterTestMethod()
        {
            Console.WriteLine("When targeted by the [Post] attribute this is run after" +
                              "each test method in the class");
        }

        public void RunAfterTestClass()
        {
            Console.WriteLine("When targeted by the [End] attribute this is run once after" +
                              "all methods");
        }
    }
}