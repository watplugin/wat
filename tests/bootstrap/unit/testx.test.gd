extends WAT.Test

func title() -> String:
	return "Given a Test Script"

func test_we_can_omit_describe() -> void:
	# We don't use describe here because it should be optional
	
	asserts.is_true(true, "if the test didn't break this works")

func test_when_we_omit_context_we_can_see_expected_and_got_under_method():
	
	asserts.is_true(true)
	asserts.is_equal(2, 2)

func test_we_can_record_properties() -> void:
	describe("When we record properties")
	
	var recordee = Recordee.new()
	var recorder = record(recordee, ["age", "wisdom"])
	recorder.start()
	add_child(recordee)
	simulate(self, 10, 0.1)
	recorder.stop()
	
	var age: Array = recorder.get_property_timeline("age")
	var wisdom: Array = recorder.get_property_timeline("wisdom")
	asserts.is_greater_than(age.size(), 1, "We get an array of multiple values back")
	asserts.is_not_equal(age[0], age.back(), "With different values")
	asserts.is_greater_than(wisdom.size(), 1, "And we can track multiple properties")
	recordee.free()

class Recordee extends Node:
	var age = 0
	var wisdom = 100
	
	func _process(_delta: float) -> void:
		age += 1
		if wisdom > 0:
			wisdom -= 1
