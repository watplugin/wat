# Test
extends WAT.Test

func title() -> String:
	return "Property Member Test"
	
func test_double_scene_exported_values_StringPath() -> void:
	describe("When we double a scene via path with exported values")
	var director = direct.scene("res://OldExamples/Test.tscn")
	var double = director.double()
	asserts.is_equal(double.age, 5, "Then their value is equal to the exported value")

func test_double_scene_exported_values_PackedScene() -> void:
	describe("When we double a scene via PackedScene with exported values")
	var scene: PackedScene = preload("res://OldExamples/Test.tscn")
	var director = direct.scene(scene)
	var double = director.double()
	asserts.is_equal(double.age, 5, "Then their value is equal to the exported value")
	
