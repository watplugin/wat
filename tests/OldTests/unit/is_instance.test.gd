extends WAT.Test

func title():
	return "Given an Is Instance of class/type Assertion"

func test_when_calling_is_AABB():
	describe("When calling asserts.is_AABB(aabb: AABB)")

	var aabb: AABB = AABB()
	asserts.is_not_null(aabb, "AABB is not null")
	asserts.is_AABB(aabb, "Then it passes")

func test_when_calling_is_Array():
	describe("When calling asserts.is_Array(array: Array)")

	var array: Array = []

	asserts.is_not_null(array, "array is not null")
	asserts.is_Array(array, "Then it passes")

func test_when_calling_is_Basis():
	describe("When calling asserts.is_basis(basis: Basis")

	var basis: Basis = Basis()

	asserts.is_not_null(basis, "basis is not null")
	asserts.is_Basis(basis, "Then it passes")

func test_when_calling_is_bool():
	describe("When calling asserts.is_bool(true)")

	asserts.is_bool(true, "Then it passes")

func test_when_calling_is_Color():
	describe("When calling asserts.is_color(color: Color)")

	var color: Color = Color()

	asserts.is_not_null(color, "color is not null")
	asserts.is_Color(color, "Then it passes")

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

	asserts.is_not_null(nodepath, "@'Parent/Child' is not null")
	asserts.is_NodePath(nodepath, "Then it passes")
	

func test_when_calling_is_object():
	describe("When calling is asserts.object(node: Node)")

	var node: Node = Node.new()

	asserts.is_not_null(node, "node is not null")
	asserts.is_Object(node, "An instance of node is an Object")
	
	node.free()

func test_when_calling_is_Plane():
	describe("When calling asserts.is_Plane(plane: Plane())")

	var plane: Plane = Plane()

	asserts.is_not_null(plane, "plane is not null")
	asserts.is_Plane(plane, "then it passes")

func test_when_calling_is_PoolByteArray():
	describe("When calling asserts.is_PoolByteArray(bytes: PoolByteArray)")

	var bytes: PoolByteArray = PoolByteArray()

	asserts.is_not_null(bytes, "bytes is not null")
	asserts.is_PoolByteArray(bytes, "Then it passes")

func test_when_calling_is_PoolColorArray():
	describe("When calling asserts.is_PoolColorArray(colors: PoolColorArray)")

	var colors: PoolColorArray = PoolColorArray()

	asserts.is_not_null(colors, "colors is not null")
	asserts.is_PoolColorArray(colors, "Then it passes")

func test_when_calling_is_PoolIntArray():
	describe("When calling asserts.is_PoolIntArray(ints: PoolIntArray)")

	var ints: PoolIntArray = PoolIntArray()

	asserts.is_not_null(ints, "ints is not null")
	asserts.is_PoolIntArray(ints, "Then it passes")

func test_when_calling_is_PoolRealArray():
	describe("When calling is asserts.is_PoolRealArray(reals: PoolRealArray)")

	var reals: PoolRealArray = PoolRealArray()

	asserts.is_not_null(reals, "reals is not null")
	asserts.is_PoolRealArray(reals, "Then it passes")

func test_when_calling_is_PoolStringArray():
	describe("When calling is asserts.is_PoolStringArray(strs: PoolStringArray)")

	var strs: PoolStringArray = PoolStringArray()

	asserts.is_not_null(strs, "strs is not null")
	asserts.is_PoolStringArray(strs, "Then it passes")

func test_when_calling_is_PoolVector2Array():
	describe("When calling is asserts.is_PoolVector2Array(vec2s: PoolVector2Array)")

	var vec2s: PoolVector2Array = PoolVector2Array()

	asserts.is_not_null(vec2s, "vec2s is not null")
	asserts.is_PoolVector2Array(vec2s, "Then it passes")

func test_when_calling_is_PoolVector3Array():
	describe("When calling is asserts.is_PoolVector3Array(vec3s: PoolVector3Array)")

	var vec3s: PoolVector3Array = PoolVector3Array()

	asserts.is_not_null(vec3s, "vec3s is not null")
	asserts.is_PoolVector3Array(vec3s, "Then it passes")

func test_when_calling_is_Quat():
	describe("When calling asserts.is_Quat(quat: Quat)")

	var quat: Quat = Quat()

	asserts.is_not_null(quat, "quat is not null")
	asserts.is_Quat(quat, "Then it passes")

func test_when_calling_is_Rect2():
	describe("When calling asserts.is_Rect2(rect2: Rect2)")

	var rect2: Rect2 = Rect2()

	asserts.is_not_null(rect2, "rect2 is not null")
	asserts.is_Rect2(rect2, "Then it passes")

func test_when_calling_is_RID():
	describe("When calling asserts.is_RID(rid: RID)")

	var rid: RID = RID()

	asserts.is_not_null(rid, "rid is not null")
	asserts.is_RID(rid, "Then it passes")

func test_when_calling_is_string():
	describe("When calling asserts.is_string(strs: String)")

	var strs: String = String()

	asserts.is_not_null(strs, "strs is not null")
	asserts.is_String(strs, "Then it passes")

func test_when_calling_is_Transform():
	describe("When calling asserts.is_Transform(transform: Transform)")

	var transform: Transform = Transform()

	asserts.is_not_null(transform, "transform is not null")
	asserts.is_Transform(transform, "Then it passes")

func test_when_calling_is_Transform2D():
	describe("When calling asserts.is_Transform(transform2D: Transform2D)")

	var transform2D: Transform2D = Transform2D()

	asserts.is_not_null(transform2D, "transform2D is not null")
	asserts.is_Transform2D(transform2D, "Then it passes")

func test_when_calling_is_Vector2():
	describe("When calling asserts.is_Vector2(vec2)")

	var vec2: Vector2 = Vector2()

	asserts.is_not_null(vec2, "vec2 is not null")
	asserts.is_Vector2(vec2, "Then it passes")

func test_when_calling_is_Vector3():
	describe("When calling asserts.is_Vector3(vec3: Vector3")

	var vec3: Vector3 = Vector3()

	asserts.is_not_null(vec3, "vec3 is not null")
	asserts.is_Vector3(vec3, "Then it passes")
