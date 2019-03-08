extends WATT

func test_expect_is_true_all_of_these_should_pass():
	self.expect.is_true((true), "true is true")
	self.expect.is_true((true != false), "true is not false")
	self.expect.is_true((true != null), "true is not null")
	self.expect.is_true((1 is int), "1 is an Integer")
	self.expect.is_true((1.0 is float), "1.0 is a float")
	self.expect.is_true(("String" is String), '"String" is a String')
	self.expect.is_true(([] is Array), "[] is an Array")
	self.expect.is_true(({} is Dictionary), "{} is a Dictionary")
	self.expect.is_true((Vector2(0, 0) is Vector2), "Vector2(0, 0) is Vector2")
	self.expect.is_true((Vector3(0, 0, 0) is Vector3), "Vector3(0, 0, 0) is Vector3")
	
func test_expect_is_true_all_of_these_should_fail():
	var bad: Dictionary = {"integer": 1.0, "floating": 1, "string": 1, "vec2": [], "vec3": [], "array": {}, "dict": []}
	self.expect.is_true((false), "true is true")
	self.expect.is_true((true == false), "true is not false")
	self.expect.is_true((true == null), "true is not null")
	self.expect.is_true((bad.integer is int), "1 is int")
	self.expect.is_true((bad.floating is float), "1.0 is float")
	self.expect.is_true((bad.string is String), '"1" is String')
	self.expect.is_true((bad.vec2 is Vector2), "Vector2(0, 0) is Vector2")
	self.expect.is_true((bad.vec3 is Vector3), "Vector3(0, 0, 0) is Vector3")
	self.expect.is_true((bad.array is Array), "[] is Array")
	self.expect.is_true((bad.dictionary is Dictionary), "{} is Dictionary")
