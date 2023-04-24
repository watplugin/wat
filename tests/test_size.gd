extends WAT.Test

func test_one():
	var arr = [1]
	asserts.is_size(arr, 1)
	var arr2 = [1, 2]
	asserts.is_size(arr2, 2)
	var x = []
	asserts.is_size(x, 5)
