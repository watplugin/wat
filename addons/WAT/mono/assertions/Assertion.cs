using System.Diagnostics;
using System.Dynamic;
using Godot;
using Godot.Collections;

namespace WAT
{
	public class Assertion
	{

		protected static Dictionary Result(bool success, string expected, string actual, string context, string notes = "")
		{
			return new Dictionary
		   {
			   {"success", success},
			   {"expected", expected},
			   {"actual", actual},
			   {"context", context}
		   };
		}
	}
}
