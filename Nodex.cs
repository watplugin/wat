using Godot;
using System;
using System.Threading.Tasks;

public class Nodex : Godot.Node
{
	public string Title = "I am csharp";
	public override void _Ready()
	{
		
	}
	
	public async Task Wait()
	{
		GD.Print("Hey");
		//return ToSignal(this, "ready");
		//GD.Print("Bye");
	}
}
