using System;
using System.IO;

namespace WAT
{
    public class ExceptionTests: WAT.Test
    {
        [Test]
        public void AnExceptionWasThrown()
        {
            void Function() => throw new NullReferenceException("Null Message");
            Assert.Throws(Function, "Threw an exception");
        }
        
        [Test]
        public void AnExceptionWasNotThrown()
        {
            void Function() {}
            Assert.DoesNotThrow(Function, "Did not throw a exception");
        }
        
        [Test]
        public void AnExceptionOfNullReferenceWasThrown()
        {
            void Function() { throw new NullReferenceException("Null Message"); }
            Assert.Throws<NullReferenceException>(Function, "Threw a null reference exception");
        }
        
        [Test]
        public void AnExceptionOfNullReferenceWasNotThrown()
        {
            void Function() { throw new FileNotFoundException("Null Message"); }
            Assert.DoesNotThrow<NullReferenceException>(Function, "Did not throw a null reference");
        }
        
        [Test]
        public void AnExceptionOfTypeWasNotThrown()
        {
            void Function() {  }
            Assert.DoesNotThrow<Exception>(Function, "Did not throw a an exception of any type");
        }
        
    }
}