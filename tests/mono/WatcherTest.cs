using Godot;
using System;
using GDArray = Godot.Collections.Array;

// BEGIN NOTE - UNWATCHING
// To avoid argument-based conflicts when you emit the same signal with different argument counts
// you should use unwatch(emitter, signal) in your post methods (or after asserts in your test method)
// you may even want to use it inbetween asserts if necessary when testing a signal multiple times
// END NOTE

// BEGIN NOTE - BOUNDED VARIABLES
// We currently cannot track bound arguments.
// END NOTE

public class WatcherTest : WAT.Test
{
	public override string Title()
	{
		return "Given A Signal Watcher";
	}
	
	public override void Start()
	{
		// There is no RemoveUserSignal Method apparently.
		AddUserSignal("Example");
	}
	
	public override void Pre()
	{
		Watch(this, "Example");
	}
	
	public override void Post()
	{
		
		UnWatch(this, "Example");
	}
	
	[Test]
	public void WhenWeWatchASignalFromAnObjectWithNoBoundVariables()
	{
		EmitSignal("Example", 1, 20, 5);
		GDArray args = new GDArray {1, 20, 5};
		Assert.SignalWasEmittedWithArguments(this, "Example", args, 
			"Then it captures any arguments that where passed when the signal was emitted");
	}
	
	[Test]
	public void WhenWeWatchAndEmitASignal()
	{
		Describe("When we watch and emit a signal");
		EmitSignal("Example");
		Assert.SignalWasEmitted(this, "Example", "Then it captures the emitted signal");
		
	}
	
	[Test]
	public void WhenWeWatchAndDoNotEmitASignal()
	{
		Describe("When we Watch and Do not Emit a Signal");
		Assert.SignalWasNotEmitted(this, "Example", "Then it does not capture the non-emitted signal");
	}
	
	[Test]
	public void WhenWeWatchASignalAndEmitItMultipleTimes()
	{
		AddUserSignal("Multiple");
		Watch(this, "Multiple");
		EmitSignal("Multiple");
		EmitSignal("Multiple");
		const int emitCount = 2;
		Assert.SignalWasEmittedXTimes(this, "Multiple", emitCount, 
			"Then we can track how many times we emitted it");
	}
}
