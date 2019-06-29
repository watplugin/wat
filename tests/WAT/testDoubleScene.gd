extends WATTest

func test_double_scene():
	var double = DOUBLE.scene("res://Examples/Scene/Main.tscn")
	expect.is_not_null(double.instance)