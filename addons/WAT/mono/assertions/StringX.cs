using Godot;
using Godot.Collections;

namespace WAT
{
    public class StringX: Assertion
    {
        public static Dictionary BeginsWith(string value, string str, string context)
        {
            string passed = $"{str} begins with {value}";
            string failed = $"{str} does not begin with {value}";
            bool success = str.BeginsWith(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotBeginWith(string value, string str, string context)
        {
            string passed = $"{str} does not begin with {value}";
            string failed = $"{str} begins with {value}";
            bool success = !str.BeginsWith(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary Contains(string value, string str, string context)
        {
            string passed = $"{str} contains {value}";
            string failed = $"{str} does not contain {value}";
            bool success = str.Contains(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotContain(string value, string str, string context)
        {
            string passed = $"{str} does not contain {value}";
            string failed = $"{str} contains {value}";
            bool success = !str.Contains(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary EndsWith(string value, string str, string context)
        {
            string passed = $"{str} ends with {value}";
            string failed = $"{str} does not end with {value}";
            bool success = str.EndsWith(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotEndWith(string value, string str, string context)
        {
            string passed = $"{str} does not end with {value}";
            string failed = $"{str} end with {value}";
            bool success = !str.EndsWith(value);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }
    }
}