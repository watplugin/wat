extends WAT.Test 

func test_simple():
	asserts.is_true(true)

func test_badsimple():
	asserts.is_true(false)
