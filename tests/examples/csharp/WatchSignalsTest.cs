using Godot;
using Array = Godot.Collections.Array;

// Developers can call Watch(emitter, signal) to check if a signal..
// ..was emitted, not emitted, emitted so many times or was emitted..
// ..a particular set of arguments.

public class WatchSignalsTest : WAT.Test
{
	[Signal]
	public delegate void MySignal();

	[Test]
	public void SignalWasEmitted()
	{
		Watch(this, nameof(MySignal));
		EmitSignal(nameof(MySignal));
		Assert.SignalWasEmitted(this, nameof(MySignal));
		UnWatch(this, nameof(MySignal));
	}

	[Test]
	public void SignalWasNotEmitted()
	{
		Watch(this, nameof(MySignal));
		Assert.SignalWasNotEmitted(this, nameof(MySignal));
		UnWatch(this, nameof(MySignal));
	}

	[Test]
	public void SignalWasEmittedXTimes()
	{
		Watch(this, nameof(MySignal));
		EmitSignal(nameof(MySignal));
		EmitSignal(nameof(MySignal));
		Assert.SignalWasEmittedXTimes(this, nameof(MySignal), 2);
		UnWatch(this, nameof(MySignal));
	}

	[Test]
	public void SignalWasEmittedWithArguments()
	{
		Watch(this, nameof(MySignal));
		EmitSignal(nameof(MySignal), "Hello", "World");
		Assert.SignalWasEmittedWithArguments(this, nameof(MySignal), new Array {"Hello", "World"});
		UnWatch(this, nameof(MySignal));
	}
	
	
}
