extends Node

const x = preload("res://Examples/Scene/Main.tscn")

func _ready():
#	print(x._bundled)
	for i in x._bundled.values():
		print(i)
#	var file = File.new()
#	file.open("res://Examples/Scene/Main.tscn", File.READ)
#	var text = file.get_as_text()
#	var list = text.split("\n\n")
#	print(list.size())
#	for i in list:
#		print(i, "\n------\n")
#	file.close()
	