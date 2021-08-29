extends Node
class_name Calculator

var _sum: int = 0

func add(a, b):
	return a + b

func subtract(a, b):
	return a - b

func multiply(a, b):
	return a * b

func divide(a, b):
	return a / b

func sum(list):
	_sum = 0
	for number in list:
		_sum += number
	return _sum

static func pi():
	return PI

remote func math_fight():
	return null

class Algebra:
	
	static func get_tau() -> float:
		return TAU

	static func create_vector():
		return Vector2(10, 10)

	func scale(vector, scaler):
		var x = vector.x * scaler
		var y = vector.y * scaler
		return Vector2(x, y)
