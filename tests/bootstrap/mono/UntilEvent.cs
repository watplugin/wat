using System;
using System.Threading.Tasks;

namespace WAT
{
	public class UntilEvent: WAT.Test
	{
		// This should really work with any delegate that matches method(sender), method(sender, args) or method(sender, customargs)
		public event EventHandler Event;
		public event EventHandler<EventArgs> EventWithArguments;
		public event EventHandler<CustomEventArgs> EventWithCustomArguments;
		
		[Test()]
		public async Task EventReached()
		{
			Watch(this, "EventRaised");
			CallDeferred("InvokeEvent");
			TestEventData eventData = await UntilEvent(this, nameof(Event), 10.0);
			Assert.IsEqual(eventData.Sender, this, "This test invoked Event");
			Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
			UnWatch(this, "EventRaised");
		}
		
		[Test()]
		public async Task EventTimedOut()
		{
			Watch(this, "EventRaised");
			TestEventData eventData = await UntilEvent(this, nameof(Event), 0.5);
			Assert.IsTrue(eventData.Sender is null, "Event data has no sender (because it was never invoked)");
			Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised was not Emitted");
			UnWatch(this, "EventRaised");
		}
		
		[Test()]
		public async Task EventWithArgsReached()
		{
			Watch(this, "EventRaised");
			CallDeferred("InvokeEventWithEventArgs");
			TestEventData eventData  = await UntilEvent(this, nameof(EventWithArguments), 10.0);
			Assert.IsEqual(eventData.Sender, this, "This test invoked EventWithEventArgs");
			Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
			UnWatch(this, "EventRaised");
		}
		
		[Test()]
		public async Task EventWithArgsTimedOut()
		{
			Watch(this, "EventRaised");
			TestEventData eventData = await UntilEvent(this, nameof(EventWithArguments), 0.5);
			Assert.IsTrue(eventData.Sender is null, "Event data has no sender (because it was never invoked)");
			Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised was not Emitted");
			UnWatch(this, "EventRaised");
		}
		
		[Test()]
		public async Task EventWithCustomArgsReached()
		{
			Watch(this, "EventRaised");
			CallDeferred("InvokeEventWithCustomArgs", 10, "hello", true);
			TestEventData eventData = await UntilEvent(this, nameof(EventWithCustomArguments), 10.0);
			Assert.IsEqual(eventData.Sender, this, "This test invoked EventWithEventArgs");
			Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
			Assert.IsType<CustomEventArgs>(eventData.Arguments, "Args are Custom Event Args");
			UnWatch(this, "EventRaised");
		}
		
		[Test()]
		public async Task EventWithCustomArgsTimedOut()
		{
			Watch(this, "EventRaised");
			TestEventData eventData = await UntilEvent(this, nameof(EventWithCustomArguments), 0.5);
			Assert.IsTrue(eventData.Sender is null, "Event data has no sender (because it was never invoked)");
			Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised Was Not Emitted");
			UnWatch(this, "EventRaised");
		}
		
		private void InvokeEvent() { Event?.Invoke(this, null); }
		private void InvokeEventWithEventArgs() { EventWithArguments?.Invoke(this, new EventArgs()); }
		private void InvokeEventWithCustomArgs(int a, string b, bool c) { EventWithCustomArguments?.Invoke(this, new CustomEventArgs(a, b, c)); }
	}

	public class CustomEventArgs: EventArgs
	{
		public int A { get; }
		public string B { get; }
		public bool C { get; }
			
		public CustomEventArgs(int a, string b, bool c)
		{
			A = a;
			B = b;
			C = c;
		}
	}
}
