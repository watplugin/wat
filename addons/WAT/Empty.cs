using Godot;
using System;

public class Empty : Node
{
	public override void _Ready()
	{
		Console.WriteLine("Initializing CSharp Scripts");
		GetTree().CallDeferred("quit");
	}
}
