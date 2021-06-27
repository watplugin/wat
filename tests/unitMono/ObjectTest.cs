using Godot;
using System;

public class ObjectTest : WAT.Test
{
	public override String Title()
	{
		return "Object Assertions";
	}
	
	/*
	IsFreed and & IsNotFreed don't work correctly in CSharp
	[Test]
	public void WhenCallingFreedObjectIsFreed()
	{
		Node N = new Node();
		N.Free();
		Assert.IsFreed(N, "Then it passes");
	}
	
	[Test]
	public void WhenCallingUnfreedObjectIsNotFreed()
	{
		Node N = new Node();
		Assert.IsNotFreed(N, "Then it passes");
		N.Free();
	}
	*/
	
	[Test]
	public void WhenCallingHasMetaAfterAddingMetadata()
	{
		SetMeta("Dummy", 1);
		Assert.ObjectHasMeta(this, "Dummy", "Then it passes");
		RemoveMeta("Dummy");
	}
	
	[Test]
	public void WhenCallingDoesNotHaveMeta()
	{
		Assert.ObjectDoesNotHaveMeta(this, "bad_meta", "Then it passes");
	}
	
	[Test]
	public void WhenCallingDoesNotHaveMetalRealKeyButNullValue()
	{
		SetMeta("Confusing", null);
		Assert.ObjectDoesNotHaveMeta(this, "Confusing", "Then it passes");
	}
	
	[Test]
	public void WhenCallingHasMethodTitle()
	{
		Assert.ObjectHasMethod(this, "Title", "Then it passes");
	}
	
	[Test]
	public void WhenCallingDoesNotHaveMethodFalseMethod()
	{
		Assert.ObjectDoesNotHaveMethod(this, "FalseMethod", "Then it passes");
	}
	
	[Test]
	public void WhenCallingHasUserSignalAfterAddingASignal()
	{
		AddUserSignal("DummySignal");
		Assert.ObjectHasUserSignal(this, "DummySignal", "Then it passes");
	}
	
	[Test]
	public void WhenCallingDoesNotHaveUserSignal()
	{
		Assert.ObjectDoesNotHaveUserSignal(this, "FalseSignal", "Then it passes");
	}
	
	[Signal]
	delegate void BuiltinDummy();
	
	[Test]
	public void WhenCallingDoesNotHaveUserSignalWithClassSignalConstant()
	{
		Assert.ObjectDoesNotHaveUserSignal(this, "BuiltinDummy", "Then it passes");
	}
	
	[Test]
	public void WhenCallingObjectIsQueuedForDeletionAfterCallingQueueFree()
	{
		Node N = new Node();
		N.QueueFree();
		Assert.ObjectIsQueuedForDeletion(N, "Then it passes");
	}
	
	[Test]
	public void WhenCallingObjectIsNotQueuedForDeletionAfterNotCallingQueueFree()
	{
		Node N = new Node();
		Assert.ObjectIsNotQueuedForDeletion(N, "Then it passes");
		N.Free();
	}
	
	[Test]
	public void WhenCallingObjIsConnectedWithARealConnection()
	{
		Connect("BuiltinDummy", this, "GetTitle");
		Assert.ObjectIsConnected(this, "BuiltinDummy", this, "GetTitle", "Then it passes");
		Disconnect("BuiltinDummy", this, "GetTitle");
	}
	
	[Test]
	public void WhenCallingObjIsNotConnectedWithAnInvalidConnection()
	{
		Assert.ObjectIsNotConnected(this, "BuiltinDummy", this, "GetTitle", "Then it passes");
	}
	
	[Test]
	public void TestIsBlockingSignals()
	{
		Node N = new Node();
		N.SetBlockSignals(true);
		Assert.ObjectIsBlockingSignals(N, "Then it passes");
		N.Free();
	}
	
	[Test]
	public void IsNotBlockingSignals()
	{
		Node N = new Node();
		N.SetBlockSignals(false);
		Assert.ObjectIsNotBlockingSignals(N, "Then it passes");
		N.Free();
	}
	
}

