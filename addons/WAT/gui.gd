extends PanelContainer
tool

var d = [{}]

func _ready() -> void:
	#tests().connect("test", self, "_on_change")
	d = tests().array
	$GUI/Interact/CallSignal.connect("pressed", self, "_calling")

func tests() -> Resource:
	var x = load("res://addons/WAT/cache/cache.tres")
	x.count += 1
	x.array.append(x.count)
	print(x.count)
	print(d)
	return x
	
func _on_change():
	print("changed")
	
func _calling():
	tests()
#	tests().test_signal()
