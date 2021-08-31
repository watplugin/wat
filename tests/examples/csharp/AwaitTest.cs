using Godot;
using System;
using System.Threading.Tasks;

public class AwaitTest : WAT.Test
{
    [Signal] public delegate void MySignal();

    public event EventHandler MyEvent;
    public event EventHandler MyEventWithArgs;
    
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
        CallDeferred(nameof(InvokeEventWithNoArgs));
        await UntilEvent(this, nameof(MyEvent), 0.2f);
        Assert.AutoPass("Await Until Event");
    }

    [Test]
    public async Task AwaitUntilEventWithArgs()
    {
        // Developers may await in tests for an Event with EventArgs..
        // ..by changing the Test Method signature to async task and..
        // ..awaiting UntilEvent passing in the Event sender, the event..
        // ..handle and a time limit.
        // Note: Currently WAT only handles Event handles that take the..
        // ..the sender and an optional EventArg Object.
        CallDeferred(nameof(InvokeEventWithEventArgs), "Hello", "Alex");
        
        // Developers may investigate TestEventData object returned by UntilEvent..
        // ..which containers the property Sender and the property Arguments which..
        // ..stores the EventArg object that may have been sent.
        TestEventData data = 
            await UntilEvent(this, nameof(MyEventWithArgs), 0.2f);
        GreetingArgs args = (GreetingArgs) data.Arguments;
        Assert.IsEqual(args.Greeting, "Hello");
        Assert.IsEqual(args.Name, "Alex");
    }

    private void InvokeEventWithNoArgs()
    {
        MyEvent?.Invoke(this, null);
    }

    private void InvokeEventWithEventArgs(string greeting, string name)
    {
        MyEventWithArgs?.Invoke(this, new GreetingArgs(greeting, name));
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
