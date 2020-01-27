extends Reference

var list: Array = []
var success: bool = false
var total: int = 0
var passed: int = 0

func caculate() -> void:
	push_error("Abstract Method Not Implemented")
	assert(false)
