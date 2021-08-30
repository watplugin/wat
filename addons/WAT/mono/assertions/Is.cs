using Godot;
using System;
using Godot.Collections;

namespace WAT {

	public class Is : Assertion
	{
		public static Dictionary IsType<T>(object value, string context)
		{
			string passed = $"{value} is builtin {typeof(T)}";
			string failed = $"{value} is not builtin {typeof(T)}";
			bool success = value is T;
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotType<T>(object value, string context)
		{
			string passed = $"{value} is builtin {typeof(T)}";
			string failed = $"{value} is not builtin {typeof(T)}";
			bool success = !(value is T);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
