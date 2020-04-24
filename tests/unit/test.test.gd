extends WAT.Test

func title() -> String:
	return "Given a Test Script"

func test_we_can_omit_describe() -> void:
	# We don't use describe here because it should be optional
	
	asserts.is_true(true, "if the test didn't break this works")
