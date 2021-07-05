using System;
using System.Threading.Tasks;

namespace WAT
{
    public class UntilEvent: WAT.Test
    {
        public event EventHandler Event = (sender, args) => { }; 
        public event EventHandler<EventArgs> EventWithArguments;
        
        [Test()]
        public async Task EventReached()
        {
            Watch(this, "EventRaised");
            CallDeferred("InvokeEvent");
            object[] result = await UntilEvent(this, nameof(Event), 10.0);
            TestEventData eventData = GetTestEventData();
            Assert.IsEqual(eventData.Sender, this, "This test invoked Event");
            Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
            UnWatch(this, "EventRaised");
        }
        
        [Test()]
        public async Task EventTimedOut()
        {
            Watch(this, "EventRaised");
            object[] result = await UntilEvent(this, nameof(Event), 3.0);
            TestEventData eventData = GetTestEventData();
            Assert.IsTrue(eventData.Sender is null, "Event data has no sender (because it was never invoked)");
            Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised was not Emitted");
            UnWatch(this, "EventRaised");
        }
        
        // [Test()]
        // public async Task EventWithArgsReached()
        // {
        //     Watch(this, "EventRaised");
        //     CallDeferred("InvokeEventWithEventArgs");
        //     object[] result = await UntilEvent(this, nameof(EventWithArguments), 10.0);
        //     //TestEventData eventData = (TestEventData) result[0];
        //     //Assert.IsType<TestEventData>(eventData, "TestEventData Object Returned on EventWithArguments.Invoke(this, new EventArgs())");
        //     Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
        //     UnWatch(this, "EventRaised");
        // }
        
        private void InvokeEvent() { Event?.Invoke(this, null); }
        private void InvokeEventWithEventArgs() { EventWithArguments?.Invoke(this, new EventArgs()); }
    }
}
