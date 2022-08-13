using System;
using System.Threading.Tasks;

namespace WAT
{
    public class UntilEvent : WAT.Test
    {
        // This should really work with any delegate that matches method(sender), method(sender, args) or method(sender, customargs)
        public event Action Event;
        public event Action<string> EventWithArgument;
        public event Action<int, string, bool> EventWithThreeArguments;

        [Test()]
        public async Task EventReached()
        {
            Watch(this, "EventRaised");
            CallDeferred(nameof(InvokeEvent));
            await UntilEvent(this, nameof(Event), 10.0);
            Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
            UnWatch(this, "EventRaised");
        }

        [Test()]
        public async Task EventTimedOut()
        {
            Watch(this, "EventRaised");
            await UntilEvent(this, nameof(Event), 0.5);
            Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised was not Emitted");
            UnWatch(this, "EventRaised");
        }

        [Test()]
        public async Task EventWithArgsReached()
        {
            Watch(this, "EventRaised");
            CallDeferred(nameof(InvokeEventWithArg), "hello");
            var isCalled = new Ref<bool>();
            var args = await UntilEvent(this, nameof(EventWithArgument), 10.0, (string a) =>
            {
                isCalled.value = true;
                Assert.IsEqual(a, "hello", "Callback a = 'hello'");
            });
            Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
            Assert.IsTrue(isCalled.value, "Callback Called");
            Assert.IsEqual(args.Length, 1, "Expected 1 Argument");
            Assert.IsEqual(args[0], "hello", "Return a = 'hello'");
            UnWatch(this, "EventRaised");
        }

        protected class Ref<T>
        {
            public T value;

            public Ref(T value = default(T))
            {
                this.value = value;
            }
        }

        [Test()]
        public async Task EventWithArgsTimedOut()
        {
            Watch(this, "EventRaised");
            var isCalled = new Ref<bool>();
            var args = await UntilEvent(this, nameof(EventWithArgument), 0.5, (string text) =>
            {
                isCalled.value = true;
            });
            Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised was not Emitted");
            Assert.IsEqual(args.Length, 1, "Expected 1 Argument");
            Assert.IsNull(args[0], "Expected Argument[0] == Null");
            Assert.IsFalse(isCalled.value, "Callback Should Not Be Called");
            UnWatch(this, "EventRaised");
        }

        [Test()]
        public async Task EventWithCustomArgsReached()
        {
            Watch(this, "EventRaised");
            CallDeferred(nameof(InvokeEventWithThreeArgs), 10, "hello", true);
            var isCalled = new Ref<bool>();
            var args = await UntilEvent(this, nameof(EventWithThreeArguments), 10.0, (int a, string b, bool c) =>
            {
                isCalled.value = true;
                Assert.IsEqual(a, 10, "Callback a = 10");
                Assert.IsEqual(b, "hello", "Callback b = 'hello'");
                Assert.IsEqual(c, true, "Callback c = true");
            });
            Assert.SignalWasEmitted(this, "EventRaised", "EventRaised Emitted");
            Assert.IsTrue(isCalled.value, "Callback Called");
            Assert.IsEqual(args.Length, 3, "Expected 3 Arguments");
            Assert.IsEqual(args[0], 10, "Return a = 10");
            Assert.IsEqual(args[1], "hello", "Return b = 'hello'");
            Assert.IsEqual(args[2], true, "Return c = true");

            UnWatch(this, "EventRaised");
        }

        [Test()]
        public async Task EventWithCustomArgsTimedOut()
        {
            Watch(this, "EventRaised");
            var isCalled = new Ref<bool>();
            var args = await UntilEvent(this, nameof(EventWithThreeArguments), 0.5);
            Assert.SignalWasNotEmitted(this, "EventRaised", "EventRaised Was Not Emitted");
            Assert.IsEqual(args.Length, 3, "Expected 3 Arguments");
            Assert.IsNull(args[0], "Expected Argument[0] == Null");
            Assert.IsNull(args[1], "Expected Argument[1] == Null");
            Assert.IsNull(args[2], "Expected Argument[2] == Null");
            Assert.IsFalse(isCalled.value, "Callback Not Called");
            UnWatch(this, "EventRaised");
        }

        private void InvokeEvent() { Event?.Invoke(); }
        private void InvokeEventWithArg(string a) { EventWithArgument?.Invoke(a); }
        private void InvokeEventWithThreeArgs(int a, string b, bool c) { EventWithThreeArguments?.Invoke(a, b, c); }
    }
}
