using System;
using Godot;
using Godot.Collections;

namespace WAT
{
    public class File: Assertion
    {
        public static Dictionary Exists(string path, string context)
        {
            var passed = $"{path} exists";
            var failed = $"{path} does not exist";
            var success = new Godot.File().FileExists(path);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }

        public static Dictionary DoesNotExist(string path, string context)
        {
            var passed = $"{path} does not exist";
            var failed = $"{path} exists";
            var success = !new Godot.File().FileExists(path);
            var result = success ? passed : failed;
            return Result(success, passed, result, context);
        }
    }
}