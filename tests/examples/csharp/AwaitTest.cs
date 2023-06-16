using Godot;
using System;
using System.Threading.Tasks;

public class AwaitTest : WAT.Test
{
	[Signal] public delegate void MySignal();

	public event EventHandler MyEventHandlerEvent;
	public event EventHandler MyEventHandlerEventWithArgs;

	public event Action MyActionEvent;
	public event Action<string, int> MyActionEventWithArgs;

	// In Addition to the Tests below, Developers may also await..
	// ..any method that is targeted by the the [Start], [Pre]..
	// ..[Post], [End] attributes provided they change the..
	// ..targeted method's signature to async task.

	[Test]
	public async Task AwaitUntilTimeout()
	{
		// Developers may await in tests for a set of amount of..
		// ..time by changing the Test Method signature to..
		// ..async Task while calling await UntilTimeout.
		await UntilTimeout(0.2f);
		Assert.AutoPass("Await Until Timeout");
	}

	[Test]
	public async Task AwaitUntilSignal()
	{
		// Developers may await in tests for a signal by..
		// ..changing the Test Method signature to async task..
		// ..and awaiting UntilSignal passing in the emitter..
		// ..object, the string signal and the time limit.
		CallDeferred("emit_signal", nameof(MySignal));
		await UntilSignal(this, nameof(MySignal), 0.2f);
		Assert.AutoPass("Await Until Signal");
	}

	[Test]
	public async Task AwaitUntilEvent()
	{
		// Developers may await in tests for an Event with no EventArgs..
		// ..by changing the Test Method signature to async task and..
		// ..awaiting UntilEvent passing in the Event sender, the event..
		// ..handle and a time limit.
		// Note: Currently WAT only handles Event handles that take the..
		// ..the sender and an optional EventArg object.
		CallDeferred(nameof(InvokeEventHandlerEventWithNoArgs));
		await UntilEvent(this, nameof(MyEventHandlerEvent), 0.2f);
		Assert.AutoPass("Await Until Event");
	}

	[Test]
	public async Task AwaitUntilEventHandlerEventWithArgs()
	{
		// Developers may await in tests for an Event with EventArgs..
		// ..by changing the Test Method signature to async task and..
		// ..awaiting UntilEvent passing in the Event sender, the event..
		// ..handle and a time limit.
		// Note: Currently WAT only handles Event handles that take the..
		// ..the sender and an optional EventArg Object.
		CallDeferred(nameof(InvokeEventHandlerEventWithEventArgs), "Hello", "Alex");

		// Developers may investigate TestEventData object returned by UntilEvent..
		// ..which containers the property Sender and the property Arguments which..
		// ..stores the EventArg object that may have been sent.
		TestEventData data =
			await UntilEventHandlerEvent(this, nameof(MyEventHandlerEventWithArgs), 0.2f);
		GreetingArgs args = (GreetingArgs)data.Arguments;
		Assert.IsEqual(args.Greeting, "Hello");
		Assert.IsEqual(args.Name, "Alex");
	}

	[Test]
	public async Task AwaitUntilEventWithArgs()
	{
		// Developers may await in tests for an Event with any parameters.
		CallDeferred(nameof(InvokeActionEventWithArgs), "heyo", 20);

		// Developers may investigate the parameters invoked by the event.
		// These parameters are returned from UntilEvent.
		var args = await UntilEvent(this, nameof(MyActionEventWithArgs), 10, (string text, int number) =>
		{
			// Developers may also use a callback method to
			// directly link themselves up to the event.
			Assert.IsEqual(text, "heyo");
			Assert.IsEqual(number, 20);
		});

		Assert.IsEqual(args[0], "heyo");
		Assert.IsEqual(args[1], 20);
	}

	private void InvokeActionEventWithNoArgs()
	{
		MyActionEvent?.Invoke();
	}

	private void InvokeActionEventWithArgs(string text, int number)
	{
		MyActionEventWithArgs?.Invoke(text, number);
	}

	private void InvokeEventHandlerEventWithNoArgs()
	{
		MyEventHandlerEvent?.Invoke(this, null);
	}

	private void InvokeEventHandlerEventWithEventArgs(string greeting, string name)
	{
		MyEventHandlerEventWithArgs?.Invoke(this, new GreetingArgs(greeting, name));
	}

	public class GreetingArgs : EventArgs
	{
		public string Greeting { get; set; }
		public string Name { get; set; }

		public GreetingArgs(string greeting, string name)
		{
			Greeting = greeting;
			Name = name;
		}

	}
}
