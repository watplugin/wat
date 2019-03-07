extends Node
class_name Calculator

func add(a, b) -> int:
	return a + b
	
func subtract(a, b) -> int:
	return a - b
	
func broken_subtract(a, b) -> int:
	return a - b * 2
	
func broken_add(a, b) -> int:
	return a + b * 2