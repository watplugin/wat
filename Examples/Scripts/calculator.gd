extends Node
class_name Calculator
tool

func add(a, b):
	return a + b

func subtract(a, b):
	return a - b

func multiply(a, b):
	return a * b

func divide(a, b):
	return a / b

class Algebra:
	tool

	func scale(vector, scaler):
		var x = vector.x * scaler
		var y = vector.y * scaler
		return Vector2(x, y)