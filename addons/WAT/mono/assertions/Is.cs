using Godot;
using System;
using Godot.Collections;

namespace WAT {

	public class Is : Assertion
	{
		public static Dictionary IsType<T>(object value, string context)
		{
			var passed = $"{value} is builtin {typeof(T)}";
			var failed = $"{value} is not builtin {typeof(T)}";
			var success = value is T;
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotType<T>(object value, string context)
		{
			var passed = $"{value} is builtin {typeof(T)}";
			var failed = $"{value} is not builtin {typeof(T)}";
			var success = !(value is T);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
