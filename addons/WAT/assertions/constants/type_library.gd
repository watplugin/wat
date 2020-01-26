extends Reference

static func get_type_string(property_id: int) -> String:
	match property_id:
		TYPE_NIL:
			return tNIL
		TYPE_BOOL:
			return tBOOL
		TYPE_INT:
			return tINT
		TYPE_REAL:
			return tFLOAT
		TYPE_STRING:
			return tSTRING
		TYPE_VECTOR2:
			return tVECTOR2
		TYPE_RECT2:
			return tRECT2
		TYPE_VECTOR3:
			return tVECTOR3
		TYPE_TRANSFORM2D:
			return tTRANSFORM2D
		TYPE_PLANE:
			return tPLANE
		TYPE_QUAT:
			return tQUAT
		TYPE_AABB:
			return tAABB
		TYPE_BASIS:
			return tBASIS
		TYPE_TRANSFORM:
			return tTRANSFORM
		TYPE_COLOR:
			return tCOLOR
		TYPE_NODE_PATH:
			return tNODE_PATH
		TYPE_RID:
			return tRID
		TYPE_OBJECT:
			return tOBJECT
		TYPE_DICTIONARY:
			return tDICTIONARY
		TYPE_ARRAY:
			return tARRAY
		TYPE_RAW_ARRAY:
			return tRAW_ARRAY
		TYPE_INT_ARRAY:
			return tINT_ARRAY
		TYPE_REAL_ARRAY:
			return tREAL_ARRAY
		TYPE_STRING_ARRAY:
			return tSTRING_ARRAY
		TYPE_VECTOR2_ARRAY:
			return tVECTOR2_ARRAY
		TYPE_VECTOR3_ARRAY:
			return tVECTOR3_ARRAY
		TYPE_COLOR_ARRAY:
			return tCOLOR_ARRAY
	return MAX

const tNIL = "null"
const tBOOL = "bool"
const tINT = "int"
const tFLOAT = "float"
const tSTRING = "String"
const tVECTOR2 = "Vector2"
const tRECT2 = "Rect2"
const tVECTOR3 = "Vector3"
const tTRANSFORM2D = "Transform2D"
const tPLANE = "Plane"
const tQUAT = "Quat"
const tAABB = "AABB"
const tBASIS = "Basis"
const tTRANSFORM = "Transform"
const tCOLOR = "Color"
const tNODE_PATH = "NodePath"
const tRID = "RID"
const tOBJECT = "Object"
const tDICTIONARY = "Dictionary"
const tARRAY = "Array"
const tRAW_ARRAY = "PoolByteArray"
const tINT_ARRAY = "PoolIntArray"
const tREAL_ARRAY = "PoolRealArray"
const tSTRING_ARRAY = "PoolStringArray"
const tVECTOR2_ARRAY = "PoolVector2Array"
const tVECTOR3_ARRAY = "PoolVector3Array"
const tCOLOR_ARRAY = "PoolColorArray"
const MAX = "OutOfBounds"
