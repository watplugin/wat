using Godot;
using System;
using System.Threading.Tasks;
using GodotArray = Godot.Collections.Array;

public class YieldTest : WAT.Test
{
	private static readonly GDScript Yielder = GD.Load<GDScript>("res://addons/WAT/test/yielder.gd");
	private bool a;
	private bool b;
	private bool c;
	private bool d;
	private bool e;
	private bool f;
	[Signal] public delegate void abc();

	public override string Title()
	{
		return "Given a Yield";
	}

	public override void Start()
	{
		
	}

	public override void Pre()
	{
		
	}

	[Test]
	public async void WhenWeYieldInExecute()
	{
		Describe("When we yield twice in execute");
		await ToSignal(UntilTimeout(0.1f), YIELD);
		e = true;
		await ToSignal(UntilTimeout(0.1f), YIELD);
		f = true;
		Assert.IsTrue(e, "Then we we set var e to true");
		Assert.IsTrue(f, "Then we set var f to true");
	}
}
