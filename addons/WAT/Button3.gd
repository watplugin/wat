tool
extends Button

func _pressed():
	var file: File = File.new()
	file.open("res://test.gd", file.WRITE)
	file.store_line("extends Node")
	file.close()