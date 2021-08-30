using System;
using Godot.Collections;

namespace WAT
{
	public class Range: Assertion
	{
		public static Dictionary IsInRange(double val, double low, double high, string context)
		{
			string passed = $"{val} is in range {low}-{high}";
			string failed = $"{val} is not in range {low}-{high}";
			bool success = val >= low && val < high;
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsNotInRange(double val, double low, double high, string context)
		{
			string passed = $"{val} is not in range {low}-{high}";
			string failed = $"{val} is in range {low}-{high}";
			bool success = val < low || val >= high;
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
	}
}
