using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using Godot;
using Godot.Collections;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace WAT
{
	public class Signal: Assertion
	{
		public static Dictionary WasEmitted(Object emitter, string signal, string context)
		{
			var passed = $"Signal {signal} was emitted from {emitter}";
			var failed = $"Signal {signal} was not emitted from {emitter}";
			
			var watcher = (Reference) emitter.GetMeta("watcher");
			var success = (int) watcher.Call("get_emit_count", signal) > 0;
			var result = success ? passed : failed;

			return Result(success, passed, result, context);
		}

		public static Dictionary WasNotEmitted(Object emitter, string signal, string context)
		{
			var passed = $"Signal {signal} was not emitted from {emitter}";
			var failed = $"Signal {signal} was emitted from {emitter}";
			
			var watcher = (Object) emitter.GetMeta("watcher");
			var success = (int) watcher.Call("get_emit_count", signal) <= 0;
			var result = success ? passed : failed;

			return Result(success, passed, result, context);
		}

		public static Dictionary WasEmittedXTimes(Object emitter, string signal, int times, string context)
		{
			var passed = $"Signal {signal} was emitted {times} times from {emitter}";
			var failed = $"Signal {signal} was not emitted {times} times from {emitter}";
			
			var watcher = (Object) emitter.GetMeta("watcher");
			var success = (int) watcher.Call("get_emit_count", signal) == times;
			var result = success ? passed : failed;

			return Result(success, passed, result, context);
		}

		public static Dictionary WasEmittedWithArgs(Object emitter, string signal, Array arguments, string context)
		{
			var passed = $"Signal {signal} was emitted from {emitter} with arguments {arguments}";
			var failed = $"Signal {signal} was not emitted from {emitter} with arguments {arguments}";
			var altFailure = $"Signal {signal} was not emitted from {emitter}";

			var success = false;
			var result = "";
			var watcher = (Object) emitter.GetMeta("watcher");
			var data = (IDictionary) watcher.Call("get_data", signal);
			if ((int) data["emit_count"] <= 0)
			{
				success = false;
				result = altFailure;
			}
			else if (FoundMatchingCall(arguments, (IEnumerable) data["calls"]))
			{
				success = true;
				result = passed;
			}
			else
			{
				success = false;
				result = failed;
			}

			return Result(success, passed, result, context);
		}

		private static bool FoundMatchingCall(IList args, IEnumerable calls)
		{
			foreach (IDictionary call in calls)
			{
				if (Match(args, (Array) call["args"]))
				{
					return true;
				}
			}

			return false;
		}

		private static bool Match(IList arguments, IList callArguments)
		{
			for (var i = 0; i < arguments.Count; i++)
			{
				if (!Equals(arguments[i], callArguments[i]))
				{
					return false;
				}
			}
			return true;
		}
	}
}
