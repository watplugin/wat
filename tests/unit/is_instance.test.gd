extends WAT.Test



func title():
	return "Given an Is Instance of class/type Assertion"
	
func test_when_calling_is_AABB():
	describe("When calling asserts.is_AABB(AABB())")
	
	asserts.is_AABB(AABB(), "Then it passes")
	
func test_when_calling_is_Array():
	describe("When calling asserts.is_Array([])")
	
	asserts.is_Array([], "Then it passes")
	
func test_when_calling_is_Basis():
	describe("When calling asserts.is_basis(Basis())")
	
	asserts.is_Basis(Basis(), "Then it passes")
	
func test_when_calling_is_bool():
	describe("When calling asserts.is_bool(true)")
	
	asserts.is_bool(true, "Then it passes")
	
func test_when_calling_is_Color():
	describe("When calling asserts.is_color(Color())")
	
	asserts.is_Color(Color(), "Then it passes")
	
func test_when_calling_is_Dictionary():
	describe("When calling asserts.is_Dictionary({})")
	
	asserts.is_Dictionary({}, "Then it passes")
	
func test_when_calling_is_float():
	describe("When calling asserts.is_float(1.0)")
	
	asserts.is_float(1.0, "Then it passes")
	
func test_when_calling_is_int():
	describe("When callign asserts.is_int(1)")
	
	asserts.is_int(1, "Then it passes")
	
func test_when_calling_is_NodePath():
	describe("When calling asserts.is_NodePath(@'Parent/Child')")
	
	var nodepath: NodePath = @"."
	asserts.is_NodePath(@"Parent/Child", "Then it passes")
	
func test_when_calling_is_object():
	describe("When calling is asserts.object(Object())")
	
	asserts.is_Object(Object(), "then it passes")

func test_when_calling_is_Plane():
	describe("When calling asserts.is_Plane(Plane())")
	
	asserts.is_Plane(Plane(), "then it passes")
	
func test_when_calling_is_PoolByteArray():
	describe("When calling asserts.is_PoolByteArray(PoolByteArray())")
	
	asserts.is_PoolByteArray(PoolByteArray(), "Then it passes")
	
func test_when_calling_is_PoolColorArray():
	describe("When calling asserts.is_PoolColorArray(PoolColorArray())")
	
	asserts.is_PoolColorArray(PoolColorArray(), "Then it passes")
	
func test_when_calling_is_PoolIntArray():
	describe("When calling asserts.is_PoolIntArray(PoolIntArray())")
	
	asserts.is_PoolIntArray(PoolIntArray(), "Then it passes")
	
func test_when_calling_is_PoolRealArray():
	describe("When calling is asserts.is_PoolRealArray(PoolRealArray())")

	asserts.is_PoolRealArray(PoolRealArray(), "Then it passes")
	
func test_when_calling_is_PoolStringArray():
	describe("When calling is asserts.is_PoolStringArray")
	
	asserts.is_PoolStringArray(PoolStringArray(), "Then it passes")
	
func test_when_calling_is_PoolVector2Array():
	describe("When calling is asserts.is_PoolVector2Array(PoolVector2Array())")
	
	asserts.is_PoolVector2Array(PoolVector2Array(), "Then it passes")
	
func test_when_calling_is_PoolVector3Array():
	describe("When calling is asserts.is_PoolVector3Array(PoolVector3Array())")
	
	asserts.is_PoolVector3Array(PoolVector3Array(), "Then it passes")
	
func test_when_calling_is_Quat():
	describe("When calling asserts.is_Quat(Quat())")
	
	asserts.is_Quat(Quat(), "Then it passes")
	
func test_when_calling_is_Rect2():
	describe("When calling asserts.is_Rect2(Rect2())")
	
	asserts.is_Rect2(Rect2(), "Then it passes")
	
func test_when_calling_is_RID():
	describe("When calling asserts.is_RID(RID())")
	
	asserts.is_RID(RID(), "Then it passes")
	
func test_when_calling_is_string():
	describe("When calling asserts.is_string(String())")
	
	asserts.is_String(String(), "Then it passes")

func test_when_calling_is_Transform():
	describe("When calling asserts.is_Transform(Transform())")
	
	asserts.is_Transform(Transform(), "Then it passes")
	
func test_when_calling_is_Transform2D():
	describe("When calling asserts.is_Transform(Transform2D())")
	
	asserts.is_Transform2D(Transform2D(), "Then it passes")
	
func test_when_calling_is_Vector2():
	describe("When calling asserts.is_Vector2(Vector2())")

	asserts.is_Vector2(Vector2(), "Then it passes")
	
func test_when_calling_is_Vector3():
	describe("When calling asserts.is_Vector3(Vector3())")
	
	asserts.is_Vector3(Vector3(), "Then it passes")

