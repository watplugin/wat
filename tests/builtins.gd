extends WATTest


func test_built_ins_all_should_pass():
	expect.is_int(10, "10 is int")
	var x: PoolIntArray = []
	expect.is_PoolIntArray(x, "New PoolInt Array is PoolIntArray")
	var Y: AABB
	expect.is_AABB(Y, "Y is AABB")

func test_built_ins_all_should_fail():
	expect.is_float(1, "1 is float")
	var x: PoolColorArray = []
	expect.is_PoolIntArray(x, "x is PoolColorArray")
