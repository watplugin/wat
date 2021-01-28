extends WATTest

func start() -> void:
	print("Call start from res://tests/simple.duplicated.test.gd")
	
func pre() -> void:
	print("Call pre from res://tests/simple.duplicated.test.gd (This should appear twice)")
	
func post() -> void:
	print("Call post from res://tests/simple.duplicated.test.gd (This should appear twice)")
	
func end() -> void:
	print("Call end from res://tests/simple.duplicated.test.gd")
	
func test_method_a() -> void:
	print("Call test method a from res://tests/simple.duplicated.test.gd")
	
func test_method_b() -> void:
	print("Call test method b from res://tests/simple.duplicated.test.gd")
