using Godot;
using System;

namespace Somewhere {}

namespace Somewhere.Overhere {

	public class NameSpaced : WAT.Test
	{
		[Test]
	 	public void x()
		{
			Assert.IsTrue(true);
		}
	}
}
