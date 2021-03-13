extends WAT.Test

func test_range():
	var i = 0
	while i < 350:
		asserts.is_in_range(i, 0, 1000000)
		asserts.is_not_in_range(-i, 0, -1000001)
		print(i)
		i += 1
