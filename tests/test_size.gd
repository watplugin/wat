extends WAT.Test

func test_one():
	var arr = [1]
	asserts.is_size(arr, 1)
	var arr2 = [1, 2]
	asserts.is_size(arr2, 2)
	var x = []
	asserts.is_size(x, 5)

func test_run_all_mode():
	is_any_run_all()
	is_normal_run_all()
	is_debug_run_all()
	asserts.is_true(true, "run_all_test")
