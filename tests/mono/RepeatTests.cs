
public class RepeatTests: WAT.Test
{
    [Test]
    public void SimpleTest()
    {
        Assert.IsTrue(true, "Single Test Ran");
    }

    [Test(2, 2, 4)]
    [Test(4, 4, 8)]
    [Test(5, 5, 10)]
    public void AdditionTest(int addend, int augend, int sum)
    {
        Assert.IsEqual(addend + augend, sum, $"{addend} + {augend} is equal to {sum}");
    }
}
