
using Godot.Collections;

public class RepeatTests: WAT.Test
{
    [Test]
    public void SimpleTest()
    {
        Assert.IsTrue(true, "Single Test Ran");
    }
    [Test(4, 4, 8)]
    [Test(5, 5, 10)]
    public void AdditionTest(int addend, int augend, int sum)
    {
        Assert.IsEqual(addend + augend, sum, $"{addend} + {augend} is equal to {sum}");
    }
    
    // If your method takes parameters, you need to pass the same count of objects here
    // If your method takes any amount of arguments, you must pass them in as an array
    // If your method takes one single string argument, you will need to make the object array explicit
    // If your method takes a description and arguments, then args must be explicit
    // If your method takes or starts with a non-string argument, it is considered to be a method argument first
    [Test("This is a description", new object[2]{null, null})]
    [Test("This is not a description", "That was not a description")]
    [Test(args: new object[] {"This single args is not a description", "This other arg is not a description"})]
    public void StringAttributeTest(string a = null, object b = null)
    {
        Assert.IsTrue(true);
    }

}
