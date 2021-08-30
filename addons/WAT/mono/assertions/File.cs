using System;
using Godot;
using Godot.Collections;

namespace WAT
{
    public class File: Assertion
    {
        public static Dictionary Exists(string path, string context)
        {
            string passed = $"{path} exists";
            string failed = $"{path} does not exist";
            bool success = new Godot.File().FileExists(path);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotExist(string path, string context)
        {
            string passed = $"{path} does not exist";
            string failed = $"{path} exists";
            bool success = !new Godot.File().FileExists(path);
            string result = success ? passed : failed;
            return Result(success, passed, result, context);
        }
    }
}