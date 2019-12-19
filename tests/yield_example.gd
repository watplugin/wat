extends WAT.Test
tool

func title():
	return "Yield with CLI Test"
	
func test_yield_with_cli():
	describe("Yield with CLI Test")
	
	# Yielding is an issue
	# If we removed the yield it works fine
	# We're not resuming or skipping past this function in runner?
	yield(until_timeout(1.0), YIELD) # Yielding is the issue? 
	asserts.is_equal(2 + 4, 6)
	
func test_control():
	describe("this should go in and out of working")
	
	asserts.is_equal(2 + 10, 12)