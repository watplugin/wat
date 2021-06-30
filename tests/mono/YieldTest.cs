using Godot;
using System;
using System.Threading.Tasks;
using GodotArray = Godot.Collections.Array;
[Title( "Given a Yield")]
[Start(nameof(Start))]
[Pre(nameof(Pre))]
public class YieldTest : WAT.Test
{
	private static readonly GDScript LocalYielder = GD.Load<GDScript>("res://addons/WAT/test/yielder.gd");
	private bool a;
	private bool b;
	private bool c;
	private bool d;
	private bool e;
	private bool f;
	[Signal] public delegate void abc();
	
	public async Task Start()
	{
		await UntilTimeout(3);
		a = true;
		await UntilTimeout(3);
		b = true;
	}

	public async Task Pre()
	{
		await UntilTimeout(0.1);
		c = true;
		await UntilTimeout(0.1);
		d = true;
		await UntilTimeout(0.1);
	}

	[Test]
	public void WhenWeYieldInStart()
	{
		Assert.IsTrue(a, "Then we set var a to true");
		Assert.IsTrue(b, "Then we set var b to true");
	}

	[Test]
	public void WhenWeYieldInPre()
	{
		Assert.IsTrue(c, "Then we set var c to true");
		Assert.IsTrue(d, "Then we set var d to true");
	}

	[Test]
	public async Task WhenWeYieldInExecute()
	{
		await UntilTimeout(0.1);
		e = true;
		await UntilTimeout(0.1);
		f = true;
		Assert.IsTrue(e, "Then we set var e to true");
		Assert.IsTrue(f, "Then we set var f to true");
	}

	[Test]
	public async Task YielderIsNotActiveDuringAssertions()
	{
		await UntilTimeout(0.1);
		Assert.IsTrue(! (bool) Yielder.Call("is_active"));
	}

	[Test]
	public async Task WhenASignalBeingYieldedOnIsEmittedTheYielderIsStopped()
	{
		CallDeferred("emit_signal", nameof(abc));
		await UntilSignal(this, nameof(abc), 0.3);
		Assert.IsTrue( (bool) Yielder.Call("is_stopped"), "Then the yielder is stopped");
	}

	[Test]
	public async Task WhenTheYielderIsFinishedSignalsAreDisconnected()
	{
		await UntilSignal(this, nameof(abc), 0.1);
		Assert.IsTrue(!IsConnected(nameof(abc), Yielder, "_on_resume"), "Then the signal is disconnected");
	}

	[Test]
	public void WhenWeCallUntilTimeout()
	{
		Timer yielder = (Timer) LocalYielder.New();
		AddChild(yielder);
		yielder.Call("until_timeout", 1.0);
		Assert.IsFalse((bool) yielder.Call("is_stopped"), "Then the yielder is not stopped");
		RemoveChild(yielder);
		yielder.Free();
	}

	[Test]
	public void WhenWeCallUntilSignal()
	{
		Timer yielder = (Timer) LocalYielder.New();
		AddChild(yielder);
		yielder.Call("until_signal", 1.0, this, nameof(abc));
		Assert.IsFalse((bool) Yielder.Get("paused"), "Then the yielder is unpaused");
		Assert.IsTrue(IsConnected(nameof(abc), yielder, "_on_resume"), "Then our signal is connected to the yielder");
		RemoveChild(yielder);
		yielder.Free();
	}

	[Test]
	public async Task WhenTheYielderTimesOut()
	{
		await UntilTimeout(0.1);
		Assert.IsTrue((bool) Yielder.Call("is_stopped"), "Then the yielder is stopped");
	}

	[Test]
	public async Task WhenTheYielderHearsOurSignal()
	{
		CallDeferred("emit_signal", nameof(abc));
		await UntilSignal(this, nameof(abc), 0.1);
		Assert.IsTrue((bool) Yielder.Call("is_stopped"), "Then the yielder is stopped");
		Assert.IsTrue(! Yielder.IsConnected(nameof(abc), Yielder, "_on_resume"), "Then our signal to the yielder is disconnected");
	}
}
