using Godot;
using System.Threading.Tasks;

[Title("Long Test")]
public class LongTest : WAT.Test
{
	[Test]
	public void LongTestRunner()
	{
		GD.Print("Begin Long Test");
		int waitForSeconds = 10;
		OS.DelayMsec(waitForSeconds * 1000);
		//System.Threading.Thread.Sleep(10 * 1000);
		GD.Print("End Long Tests");
		Assert.IsTrue(true, "Waited for " + waitForSeconds + " seconds");
	}
}
