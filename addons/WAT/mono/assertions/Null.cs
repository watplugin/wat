using Godot;
using System;
using Godot.Collections;


namespace WAT
{
	public class Null : Assertion
	{
		// Godot Objects that are freed don't become null immediatly
		// so they may still be valid instances
		public static Dictionary IsNull(object obj, string context)
		{
			const string passed = "object is null";
			const string failed = "object is not null";
			bool success = obj is null;
			if (!success)
			{
				//failed = $"{obj} is not null";
			}

			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsNotNull(object obj, string context)
		{
			string passed = "object is not null";
			const string failed = "object is null";
			bool success = !(obj is null);
			if (success)
			{
				passed = $"{obj} is not null";
			}

			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
