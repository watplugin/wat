extends WAT.Test

func title() -> String:
	return "Given a Test Script"

func test_we_can_omit_describe() -> void:
	# We don't use describe here because it should be optional
	
	asserts.is_true(true, "if the test didn't break this works")

func test_when_we_omit_context_we_can_see_expected_and_got_under_method():
	
	asserts.is_true(true)
	asserts.is_equal(2, 2)
