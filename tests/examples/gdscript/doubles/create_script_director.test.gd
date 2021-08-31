extends WAT.Test

# Script Directors are used to instruct how a Test Double should operate.

# Developers can create a Script Director from a String Path.
func test_create_a_test_script_director_from_string_path() -> void:
	var class_path: String = "res://examples/doubles/my_class.gd"
	var director = direct.script(class_path)
	var double = director.double()
	asserts.is_class_instance(double, load(class_path))
	
# Developers can create a Script Director from a preloaded class..
# ..(which is just a GDScript class).
func test_create_a_test_script_director_from_loaded_class() -> void:
	var class_script: GDScript = load("res://examples/doubles/my_class.gd")
	var director = direct.script(class_script)
	var double = director.double()
	asserts.is_class_instance(double, class_script)

# Developers can create a Script Director from a user-defined class name,
# Note: This won't work with builtin Godot Types.
func test_create_a_test_script_director_from_user_defined_class_name() -> void:
	var director = direct.script(MyClass)
	var double = director.double()
	asserts.is_class_instance(double, MyClass)

# Developers can create a Script Director from a builtin class name by..
# ..passing in name of that class as a String.
func test_create_a_test_script_director_from_builtin_class_name() -> void:
	var director = direct.script("KinematicBody2D")
	var double = director.double()
	asserts.is_equal(double.get_class(), "KinematicBody2D")

# Developers can create a Script Director from an inner class by passing in..
# ..the containing script as the first argument and then the name of the..
# ..inner class as a string as the second argument.
func test_create_a_test_script_director_from_an_inner_class() -> void:
	var inner_class: GDScript = load("res://examples/doubles/my_class.gd").InnerClass
	var director = direct.script("res://examples/doubles/my_class.gd", "InnerClass")
	var double = director.double()
	asserts.is_class_instance(double, inner_class)

# Developers can create a Script Director from a nested inner class by passing.. 
# ..in the containing script as the first argument and then the name of the..
# ..inner class as a period seperated string as the second argument.
func test_create_a_test_script_director_from_a_nested_inner_class() -> void:
	var outer = load("res://examples/doubles/my_class.gd")
	var nested: GDScript = outer.InnerClass.InnerInnerClass
	var director = direct.script(outer, "InnerClass.InnerInnerClass")
	var double = director.double()
	asserts.is_class_instance(double, nested)

# Developers can create a Script Director with constructor dependecies by..
# ..passing in the required arguments as an array as the third argument..
# ..(if no inner class is required, then developer must pass in an..
# ..empty string as the second argument)
func test_create_a_test_script_director_with_constructor_dependecies() -> void:
	var hero: GDScript = load("res://examples/doubles/hero.gd")
	var constructor_arguments = ["Alex", "Technomancer", 120]
	var no_inner_class = ""
	var director = direct.script(hero, no_inner_class, constructor_arguments)
	var double = director.double()
	asserts.is_class_instance(double, hero)
	asserts.is_equal(double.title, "Alex")
	asserts.is_equal(double.faction, "Technomancer")
	asserts.is_equal(double.health, 120)
