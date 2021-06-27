using Godot;
using System;
using System.Threading.Tasks;
using GodotArray = Godot.Collections.Array;

public class YieldTest : WAT.Test
{
	//private static readonly GDScript Yielder = GD.Load<GDScript>("res://addons/WAT/test/yielder.gd");
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

	public async Task Start()
	{
		await ToSignal(UntilTimeout(0.1), YIELD);
		a = true;
		await ToSignal(UntilTimeout(0.1), YIELD);
		b = true;
	}

	public async Task Pre()
	{
		await ToSignal(UntilTimeout(0.1), YIELD);
		c = true;
		await ToSignal(UntilTimeout(0.1), YIELD);
		d = true;
		await ToSignal(UntilTimeout(0.1), YIELD);
	}

	[Test]
	public void TestWhenWeYieldInStart()
	{
		Assert.IsTrue(a, "Then we set var a to true");
		Assert.IsTrue(b, "Then we set var b to true");
	}

	[Test]
	public void TestWhenWeYieldInPre()
	{
		Assert.IsTrue(c, "Then we set var c to true");
		Assert.IsTrue(d, "Then we set var d to true");
	}

	[Test]
	public async Task WhenWeYieldInExecute()
	{
		Describe("When we yield twice in execute");
		await ToSignal(UntilTimeout(0.1), YIELD);
		e = true;
		await ToSignal(UntilTimeout(0.1), YIELD);
		f = true;
		Assert.IsTrue(e, "Then we we set var e to true");
		Assert.IsTrue(f, "Then we set var f to true");
	}

	[Test]
	public async Task YielderIsNotActiveWhenAsserting()
	{
		await ToSignal(UntilTimeout(0.1), YIELD);
		bool result = (bool) Yielder.Call("is_active");
		Assert.IsTrue(!result, "Then yielder is not active");
	}
	
	[Test]
	public async Task WhenTheYielderTimesOut()
	{
		await ToSignal(UntilTimeout(0.1), YIELD);
		bool paused = (bool) Yielder.Call("get", "paused");
		bool connected = (bool) Yielder.Call("is_connected", "timeout", Yielder, "_on_resume");
		Assert.IsTrue(paused, "Then the yielder is paused");
		Assert.IsTrue(!connected, "The timeout signal of the yielder is not connected");
	}
	
	[Test]
	public void WhenWeCallUntilTimeout()
	{
		string yPath = "res://addons/WAT/test/yielder.gd";
		Script script = (Script) ResourceLoader.Load(yPath);
		Timer yielder = (Timer) script.Call("new");
		AddChild(yielder);
		yielder.Call("until_timeout", 1.0F);
		bool paused = (bool) yielder.Call("get", "paused");
		bool connected = (bool) yielder.Call("is_connected", "timeout", yielder, "_on_resume");
		Assert.IsTrue(!paused, "Then yielder is unpaused");
		Assert.IsTrue(connected, "The timeout signal of the yielder is connected");
		RemoveChild(yielder);
		yielder.Call("free");
	}
	
	[Test]
	public async Task WhenASignalBeingYieldedOnIsEmittedTheYielderIsStopped()
	{
		CallDeferred("emit_signal", "abc");
		await ToSignal(UntilSignal(this, "abc", 0.3), YIELD);
		bool paused = (bool) Yielder.Call("get", "paused");
		Assert.IsTrue(paused, "Then the yielder is paused");
	}
	
	[Test]
	public async Task WhenYielderIsFinishedSignalsAreDisconnected()
	{
		await ToSignal(UntilSignal(this, "abc", 0.1), YIELD);
		bool connected = (bool) Yielder.Call("is_connected", "timeout", Yielder, "_on_resume");
		bool connected2 = IsConnected("abc", Yielder, "_on_resume");
		Assert.IsTrue(!connected, "Then the timeout signal is disconnected");
		Assert.IsTrue(!connected2, "Then the signal signal is disconnected");
	}
	
	[Test]
	public void WhenWeCallUntilSignal()
	{
		String yPath = "res://addons/WAT/test/yielder.gd";
		Script script = (Script)ResourceLoader.Load(yPath);
		Timer yielder = (Timer)script.Call("new");
		AddChild(yielder);
		yielder.Call("until_signal", 1.0, this, "abc");
		bool paused = (bool)yielder.Call("get", "paused");
		bool connected = (bool)yielder.Call("is_connected", "timeout", yielder, "_on_resume");
		bool this_connected = IsConnected("abc", yielder, "_on_resume");
		Assert.IsTrue(!paused, "Then the yielder is unpaused");
		Assert.IsTrue(connected, "Then the timeout signal of the yielder is connected");
		Assert.IsTrue(this_connected, "Then our signal is connected to the yielder");
		RemoveChild(yielder);
		yielder.Call("free");
	}
	
	[Test]
	public async Task WhenTheYielderHearsOurSignal()
	{
		CallDeferred("emit_signal", "abc");
		await ToSignal(UntilSignal(this, "abc", 0.1), YIELD);
		bool paused = (bool) Yielder.Call("get", "paused");
		bool connected = (bool) Yielder.Call("is_connected", "timeout", Yielder, "_on_resume");
		bool our_connected = IsConnected("abc", Yielder, "_on_resume");
		Assert.IsTrue(paused, "Then the yielder is paused");
		Assert.IsTrue(!connected, "Then the timeout signal of the yielder is disconnected");
		Assert.IsTrue(!our_connected, "Then our signal to the yielder is disconnected");
	}
}
