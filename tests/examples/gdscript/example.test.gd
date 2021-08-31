extends WAT.Test

# All Tests in WAT must derive from WAT.Test and be stored in the user-defined..
# ..Test Directory. It extends from Godot's Node Class and is added to the..
# ..SceneTree when being executed (therefore if Developers require any of..
# ..their Units under test to be in the SceneTree, they can add those Units..
# ..as children to the current Test Node).

# Developers may override the base title() function to return a string..
# ..which will then be used as the name of the Test in the results view.
func title() -> String:
	return "My Example Test"
	
# Any method in a Test that starts with the word test is a Test method.
func test_simple_example() -> void:
	
	# Developers may use the describe method passing in a string description..
	# ..that will have the method show up as that string instead of the method..
	# ..name in the results view.
	describe("My Example Test Method")
	
	# Assertions may be called through the asserts property of WAT.Test.
	# Any test method with a failing assertion (or no assertions at all)..
	# ..will show up as a failed test in the results display.
	
	# All Assertions have an optional string context as their last argument..
	# ..which will have the assertion show up with that as its description..
	# ..in the results view.
	asserts.is_true(true, "optional context")
	
func test_parameterized_example() -> void:
	# Developers can use the parameters function to run a parameterized tests.
	# parameters takes a 2D array, the first array is the key name used to..
	# ..access the values, and each array after that is the set of values for..
	# ..that instance of the test
	parameters([["addend", "augend", "result"], 
				[2, 2, 4], [4, 4, 8], [5, 5, 10]])
	
	# The values that were passed in can be accessed via their respective keys..
	# ..in the p dictionary of WAT.Test
	var actual = p["addend"] + p["augend"]
	asserts.is_equal(p["result"], actual, 
					"%s + %s = %s" % [p["addend"], p["augend"], p["result"]])
	
func start() -> void:
	print("Developers may override the start method to execute code" +
	"before any test method is run in the Test.")
	
func pre() -> void:
	print("Developers may override the pre method to execute code" +
	"before each test method is run in the Test.")
	
func post() -> void:
	print("Developers may override the post method to execute code" +
	"after each test method is run in the Test.")
	
func end() -> void:
	print("Developers may override the end method to execute code" +
	"after all test methods have been run in the Test.")
