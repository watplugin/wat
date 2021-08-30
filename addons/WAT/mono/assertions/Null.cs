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
			var passed = "object is null";
			var failed = "object is not null";
			var success = obj is null;
			if (!success)
			{
				//failed = $"{obj} is not null";
			}

			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsNotNull(object obj, string context)
		{
			var passed = "object is not null";
			var failed = "object is null";
			var success = !(obj is null);
			if (success)
			{
				passed = $"{obj} is not null";
			}

			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
