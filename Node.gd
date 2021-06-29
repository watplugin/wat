extends TextEdit

func _ready() -> void:
	var d = Directory.new()
	d.open("res://Test")
	d.list_dir_begin(true)
	var n = d.get_next()
	while n != "":
		print(n)
		text += "\n"
		text += n
		n = d.get_next()
	d.list_dir_end()
