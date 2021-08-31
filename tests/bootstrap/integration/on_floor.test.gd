extends WAT.Test

func title() -> String:
	return "Given is_on_floor"

func test_stubbing_is_on_floor_method_from_user_defined_class() -> void:
	describe("From a user-defined script")

	var bodydirector = direct.script("res://OldExamples/Scripts/body.gd")
	bodydirector.method("is_on_floor").stub(true)
	var bodydouble = bodydirector.double()

	asserts.is_true(bodydouble.is_on_floor(), "Then it can be stubbed")

func test_stubbing_is_on_floor_method_from_builtin_class2() -> void:
	describe("From a built-in KinematicBody2D2")

	var bodydirector = direct.script("KinematicBody2D")
	bodydirector.method("is_on_floor").stub(true)
	var bodydouble = bodydirector.double()

	asserts.is_true(bodydouble.is_on_floor(), "Then it can be stubbed")

func test_stubbing_is_on_floor_as_child_node_with_no_script() -> void:
	describe("From a child node of a scene without scripts")

	var bodydirector = direct.scene("res://OldExamples/Scene/NoScriptScene.tscn")
	bodydirector.get_node("KinematicBody2D").method("is_on_floor").stub(true)
	var bodydouble = bodydirector.double()

	asserts.is_true(bodydouble.get_node("KinematicBody2D").is_on_floor(), \
		"Then it can be stubbed")
