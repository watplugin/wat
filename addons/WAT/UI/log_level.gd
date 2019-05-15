extends OptionButton

func _enter_tree():
	add_item("Only Failed", 0)
	add_item("Passed/Failed", 1)
	add_item("All", 2)