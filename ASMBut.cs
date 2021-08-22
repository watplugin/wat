using Godot;
using System;
using System.Reflection;
using System.Reflection.Emit;

public class ASMBut : Button
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Connect("pressed", this, nameof(OnPressed));
	}
	
	public void OnPressed()
	{
		Assembly assembly = new MeshInstance().invoke
		CSharpScript script = new CSharpScript();
		var x = script.DynamicObject;
		GD.Print("Hello, World");
	}

}
