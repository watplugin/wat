using System.Runtime.Remoting;
using Godot;
using Godot.Collections;

namespace WAT
{
	public class ObjectX: Assertion
	{
		public static Dictionary DoesNotHaveMeta(Object obj, string meta, string context)
		{
			string passed = $"{obj} does not have meta {meta}";
			string failed = $"{obj} has meta {meta}";
			bool success = !obj.HasMeta(meta);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary DoesNotHaveMethod(Object obj, string method, string context)
		{
			string passed = $"{obj} does not have method {method}";
			string failed = $"{obj} has method {method}";
			bool success = !obj.HasMethod(method);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary DoesNotHaveUserSignal(Object obj, string signal, string context)
		{
			string passed = $"{obj} does not have user signal {signal}";
			string failed = $"{obj} does have user signal {signal}";
			bool success = !obj.HasUserSignal(signal);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasMeta(Object obj, string meta, string context)
		{
			string passed = $"{obj} has meta {meta}";
			string failed = $"{obj} does not have meta {meta}";
			bool success = obj.HasMeta(meta);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasMethod(Object obj, string method, string context)
		{
			string passed = $"{obj} has method {method}";
			string failed = $"{obj} does not have method {method}";
			bool success = obj.HasMethod(method);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary HasUserSignal(Object obj, string signal, string context)
		{
			string passed = $"{obj} does has signal {signal}";
			string failed = $"{obj} does not have user signal {signal}";
			bool success = obj.HasUserSignal(signal);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsBlockingSignals(Object obj, string context)
		{
			string passed = $"{obj} is blocking signals";
			string failed = $"{obj} is not blocking signals";
			bool success = obj.IsBlockingSignals();
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsConnected(Object sender, string signal, Object receiver, string method, string context)
		{
			string passed = $"{sender}.{signal} is connected to {receiver}.{method}";
			string failed = $"{sender}.{signal} is not connected to {receiver}.{method}";
			bool success = sender.IsConnected(signal, receiver, method);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotBlockingSignals(Object obj, string context)
		{
			string passed = $"{obj} is not blocking signals";
			string failed = $"{obj} is blocking signals";
			bool success = !obj.IsBlockingSignals();
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotConnected(Object sender, string signal, Object receiver, string method, string context)
		{
			string passed = $"{sender}.{signal} is not connected to {receiver}.{method}";
			string failed = $"{sender}.{signal} is connected to {receiver}.{method}";
			bool success = !sender.IsConnected(signal, receiver, method);
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}

		public static Dictionary IsNotQueuedForDeletion(Object obj, string context)
		{
			string passed = $"{obj} is not queued for deletion";
			string failed = $"{obj} is queued for deletion";
			bool success = !obj.IsQueuedForDeletion();
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsQueuedForDeletion(Object obj, string context)
		{
			string passed = $"{obj} is queued for deletion";
			string failed = $"{obj} is not queued for deletion";
			bool success = obj.IsQueuedForDeletion();
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsValidInstance(Object obj = null, string context = "")
		{
			bool success = Object.IsInstanceValid(obj);
			string text = success ? obj?.ToString() : "";
			string passed = $"{text} is a valid instance";
			string failed = $"{text} is not a valid instance";
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
		
		public static Dictionary IsNotValidInstance(Object obj = null, string context = "")
		{
			bool success = !Object.IsInstanceValid(obj);
			string text = success ? "" : obj?.ToString();
			string passed = $"{text} is not a valid instance";
			string failed = $"{text} is a valid instance";
			string result = success ? passed : failed;
			return Result(success, passed, result, context);
		}
	}
}
