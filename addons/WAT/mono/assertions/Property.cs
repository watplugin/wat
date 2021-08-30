using System.Reflection;
using Godot.Collections;

namespace WAT
{
    public class Property: Assertion
    {
        public static Dictionary Contains<T>(object value, T container, string context)
        {
            string passed = $"{container.GetType()} contains |{value.GetType()}|{value}";
            string failed = $"{container.GetType()} does not contain |{value.GetType()}|{value}";
            MethodInfo method = container.GetType().GetMethod("Contains");
            bool success = false;
            if (method != null)
            {
                success = (bool) method.Invoke(container, new object[] {value});
            }

            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotContain<T>(object value, T container, string context)
        {
            string passed = $"{container.GetType()} does not contain |{value.GetType()}|{value}";
            string failed = $"{container.GetType()} contains |{value.GetType()}|{value}";
            MethodInfo method = container.GetType().GetMethod("Contains");
            bool success = false;
            if (method != null)
            {
                success = !(bool) method.Invoke(container, new object[] {value});
            }

            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }
    }
}
