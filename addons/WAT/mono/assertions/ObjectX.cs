using System.Runtime.Remoting;
using Godot;
using Godot.Collections;

namespace WAT
{
	public class ObjectX: Assertion
	{
		public static Dictionary DoesNotHaveMeta(Object obj, string meta, string context)
		{
			var passed = $"{obj} does not have meta {meta}";
			var failed = $"{obj} has meta {meta}";
			var success = !obj.HasMeta(meta);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary DoesNotHaveMethod(Object obj, string method, string context)
		{
			var passed = $"{obj} does not have method {method}";
			var failed = $"{obj} has method {method}";
			var success = !obj.HasMethod(method);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary DoesNotHaveUserSignal(Object obj, string signal, string context)
		{
			var passed = $"{obj} does not have user signal {signal}";
			var failed = $"{obj} does have user signal {signal}";
			var success = !obj.HasUserSignal(signal);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasMeta(Object obj, string meta, string context)
		{
			var passed = $"{obj} has meta {meta}";
			var failed = $"{obj} does not have meta {meta}";
			var success = obj.HasMeta(meta);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasMethod(Object obj, string method, string context)
		{
			var passed = $"{obj} has method {method}";
			var failed = $"{obj} does not have method {method}";
			var success = obj.HasMethod(method);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasUserSignal(Object obj, string signal, string context)
		{
			var passed = $"{obj} does has signal {signal}";
			var failed = $"{obj} does not have user signal {signal}";
			var success = obj.HasUserSignal(signal);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsBlockingSignals(Object obj, string context)
		{
			var passed = $"{obj} is blocking signals";
			var failed = $"{obj} is not blocking signals";
			var success = obj.IsBlockingSignals();
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsConnected(Object sender, string signal, Object receiver, string method, string context)
		{
			var passed = $"{sender}.{signal} is connected to {receiver}.{method}";
			var failed = $"{sender}.{signal} is not connected to {receiver}.{method}";
			var success = sender.IsConnected(signal, receiver, method);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotBlockingSignals(Object obj, string context)
		{
			var passed = $"{obj} is not blocking signals";
			var failed = $"{obj} is blocking signals";
			var success = !obj.IsBlockingSignals();
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotConnected(Object sender, string signal, Object receiver, string method, string context)
		{
			var passed = $"{sender}.{signal} is not connected to {receiver}.{method}";
			var failed = $"{sender}.{signal} is connected to {receiver}.{method}";
			var success = !sender.IsConnected(signal, receiver, method);
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotQueuedForDeletion(Object obj, string context)
		{
			var passed = $"{obj} is not queued for deletion";
			var failed = $"{obj} is queued for deletion";
			var success = !obj.IsQueuedForDeletion();
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsQueuedForDeletion(Object obj, string context)
		{
			var passed = $"{obj} is queued for deletion";
			var failed = $"{obj} is not queued for deletion";
			var success = obj.IsQueuedForDeletion();
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsValidInstance(Object obj = null, string context = "")
		{
			var success = Object.IsInstanceValid(obj);
			var text = success ? obj?.ToString() : "";
			var passed = $"{text} is a valid instance";
			var failed = $"{text} is not a valid instance";
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsNotValidInstance(Object obj = null, string context = "")
		{
			var success = !Object.IsInstanceValid(obj);
			var text = success ? "" : obj?.ToString();
			var passed = $"{text} is not a valid instance";
			var failed = $"{text} is a valid instance";
			var result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
