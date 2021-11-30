using Godot;
using GDObject = Godot.Object;
using System;
using IO = System.IO;

[Start(nameof(Initialize))]
[End(nameof(CleanUp))]
public class FileSystemTest : WAT.Test
{
	private string TemporaryPath = Godot.ProjectSettings
		.GlobalizePath("res://tests/bootstrap/mono/filesystem/temp/");
	private GDScript FileSystem;


	[Test("valid.test.gd", "extends WAT.Test\n\nfunc test_a():\n\tpass", 
			true, "GDScript extending WAT.Test is valid test script")]
	[Test("invalid.test.gd", "extends Node\n\nfunc test_b():\n\tpass",
			false, "GDScript not extending WAT.Test is invalid")]
	[Test("broken_ignore.test.gd", "nothingextends WAT.Test",
			false, "GDScript with parse error is ignored")]
	[Test("broken_accept.test.gd", "100 extends WAT.Test   : {abcd",
			true, "GDScript error but extending WAT.Test is accepted")]
	[Test("UncompiledWATTest.cs",
			"using Godot;\nusing System;\n\npublic class " +
			"UncompiledTest:WAT.Test{\n\t[Test]\n" +
			"public void ATest(){Assert.Fail();}}",
			true, "Uncompiled C# extending WAT.Test included")]
	[Test("UncompiledIgnore.cs",
			"using Godot;\nusing System;\n\npublic class " +
			"UncompiledIgnore : SceneTree {\n\t[Test]\n" +
			"public void ATest(){Assert.Fail();}}",
			false, "Uncompiled C# not extending WAT.Test excluded")]
	public void GetScript(string name, string content, 
		bool expected, string context)
	{
		Describe(context);
		// Generate test script file.
		string path = TemporaryPath + name;
		IO.File.WriteAllText(path, content);

		// Perform test.
		GDObject instance = (GDObject) FileSystem.New();
		var result = instance.Call("_get_test_script", path);

		if (expected)
		{
			Assert.IsNotNull(result);
		}
		else
		{
			Assert.IsNull(result);
		}

		// Cleanup generated test script file.
		IO.File.Delete(path);
	}

	public void Initialize()
	{
		IO.Directory.CreateDirectory(TemporaryPath);
		FileSystem = (GDScript) GD.Load(
			"res://addons/WAT/filesystem/filesystem.gd");
	}

	public void CleanUp()
	{
		IO.Directory.Delete(TemporaryPath, true);
	}

}
