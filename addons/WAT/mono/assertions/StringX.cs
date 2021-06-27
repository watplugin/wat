using Godot;
using Godot.Collections;

namespace WAT
{
    public class StringX: Assertion
    {
        public static Dictionary BeginsWith(string value, string str, string context)
        {
            var passed = $"{str} begins with {value}";
            var failed = $"{str} does not begin with {value}";
            var success = str.BeginsWith(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotBeginWith(string value, string str, string context)
        {
            var passed = $"{str} does not begin with {value}";
            var failed = $"{str} begins with {value}";
            var success = !str.BeginsWith(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary Contains(string value, string str, string context)
        {
            var passed = $"{str} contains {value}";
            var failed = $"{str} does not contain {value}";
            var success = str.Contains(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotContain(string value, string str, string context)
        {
            var passed = $"{str} does not contain {value}";
            var failed = $"{str} contains {value}";
            var success = !str.Contains(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary EndsWith(string value, string str, string context)
        {
            var passed = $"{str} ends with {value}";
            var failed = $"{str} does not end with {value}";
            var success = str.EndsWith(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotEndWith(string value, string str, string context)
        {
            var passed = $"{str} does not end with {value}";
            var failed = $"{str} end with {value}";
            var success = !str.EndsWith(value);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }
    }
}