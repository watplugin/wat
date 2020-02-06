extends Node

func value():
	var x = 100
	yield(get_tree().create_timer(1.0), "timeout")
	return x
	
func execute() -> void:
	var b = value()
	b.connect("completed", self, "_check")
	var x = yield(value(), "completed")
#	print(x == 100)
	
func _ready():
	print([null, null, null])
	call_deferred("execute")

func _check(value = 5):
	print(value)
	print("checking?")
