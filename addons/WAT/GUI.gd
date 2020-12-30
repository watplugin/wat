extends Container
tool

#func _ready():
#	get_parent().connect("resized", self, "resize")
#
#func resize():
#	var rect = Rect2(rect_global_position, rect_size)
#	var frontier = get_children()
#	while not frontier.empty():
#		var n = frontier.pop_front()
#		frontier += n.get_children()
#		fit_child_in_rect(n, get_global_rect())
#	#get_parent().fit_child_in_rect(self, rect)
