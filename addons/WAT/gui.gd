extends Container
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

	
#func onresize():
#	x.rect_size = rect_size
#	#fit_child_in_rect($Panel, get_rect())
##	print(get_rect().size)
##	print(rect_size)
##	$Panel.rect_size = rect_size
##	$Panel.get_rect() = get_rect()
#var x
#func _ready():
#	connect("resized", self, "onresize")
#	x = self
#	for i in 1:
#		if(x.get_parent() != null):
#			x = x.get_parent()
#			print(x)
#	print(x.size_flags_horizontal)
#	print(x.size_flags_vertical)
#	x.size_flags_horizontal = SIZE_FILL
#	x.size_flags_vertical = SIZE_FILL
#	x.rect_min_size = Vector2(0, 300)
#	var p = PackedScene.new()
#	p.pack(x)
#	ResourceSaver.save("res://x.tscn", p)

func _ready():
	connect("resized", self, "onresize")
	
func onresize():
	print($Panel.rect_size)
	$Panel/QuickStart2.rect_position = ($Panel.rect_position + Vector2(0, $Panel.rect_size.y)) - Vector2(0, 50)
