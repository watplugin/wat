using Godot.Collections;

namespace WAT
{
	public class Boolean: Assertion
	{
		public static Dictionary IsTrue(bool value, string context)
		{
			string passed = $"|boolean| {value.ToString()} == true";
			string failed = $"|boolean| {value.ToString()} == false";
			string result = value ? passed : failed;
			return Result(value, passed, result, context);
		}

		public static Dictionary IsFalse(bool value, string context)
		{
			string passed = $"|boolean| {value.ToString()} == false";
			string failed = $"|boolean| {value.ToString()} == true";
			bool success = !value;
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}

