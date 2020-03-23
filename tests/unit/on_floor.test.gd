extends WAT.Test

func title() -> String:
	return "Given is_on_floor"
	
func test_stubbing_is_on_floor_method_from_user_defined_class() -> void:
	describe("From a user-defined script")
	
	var bodydirector = direct.script("res://Examples/Scripts/body.gd")
	bodydirector.method("is_on_floor").stub(true)
	var bodydouble = bodydirector.double()
	
	asserts.is_true(bodydouble.is_on_floor(), "Then it can be stubbed")

	
func test_stubbing_is_on_floor_method_from_builtin_class() -> void:
	describe("From a built-in KinematicBody2D")
	
	var bodydirector = direct.script(KinematicBody2D)
	bodydirector.method("is_on_floor").stub(true)
	var bodydouble = bodydirector.double()
	
	asserts.is_true(bodydouble.is_on_floor(), "Then it can be stubbed")
