using Godot;
using System;
using Godot.Collections;
using Array = System.Array;

public class IsNotInstanceTest : WAT.Test
{
	public override string Title()
	{
		return "IsNotInstanceTest";
	}
	
	[Test]
	public void IsNotAABB()
	{
		Assert.IsNotType<AABB>(null);
	}
	
	[Test]
	public void IsNotArray()
	{
		Assert.IsNotType<Array>(null);
	}
	
	[Test]
	public void IsNotBasis()
	{
		Assert.IsNotType<Basis>(null);
	}
	
	[Test]
	public void IsNotBool()
	{
		Assert.IsNotType<bool>(null);
	}
	
	[Test]
	public void IsNotColor()
	{
		Assert.IsNotType<Color>(null);
	}
	
	[Test]
	public void IsNotDictionary()
	{
		Assert.IsNotType<Dictionary>(null);
	}
	
	[Test]
	public void IsNotFloat()
	{
		Assert.IsNotType<float>(null);
	}
	
	[Test]
	public void IsNotInt()
	{
		Assert.IsNotType<int>(null);
	}
	
	[Test]
	public void IsNotNodePath()
	{
		Assert.IsNotType<NodePath>(null);
	}
	
	[Test]
	public void IsNotObject()
	{
		Assert.IsNotType<Godot.Object>(null);
	}
	
	[Test]
	public void IsNotPlane()
	{
		Assert.IsNotType<Plane>(null);
	}
	
	[Test]
	public void IsNotQuat()
	{
		Assert.IsNotType<Quat>(null);
	}
	
	[Test]
	public void IsNotRect2()
	{
		Assert.IsNotType<Rect2>(null);
	}
	
	[Test]
	public void IsNotRID()
	{
		Assert.IsNotType<RID>(null);
	}
	
	[Test]
	public void IsNotString()
	{
		Assert.IsNotType<string>(null);
	}
	
	[Test]
	public void IsNotTransform()
	{
		Assert.IsNotType<Transform>(null);
	}
	
	[Test]
	public void IsNotTransform2D()
	{
		Assert.IsNotType<Transform2D>(null);
	}
	
	[Test]
	public void IsNotVector2()
	{
		Assert.IsNotType<Vector2>(null);
	}
	
	[Test]
	public void IsNotVector3()
	{
		Assert.IsNotType<Vector3>(null);
	}
}
