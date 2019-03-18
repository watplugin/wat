extends Node
# TestScene

var tokenizer = preload("res://addons/WAT/double/tokenizer.gd")
var rewriter = preload("res://addons/WAT/double/rewriter.gd")

func _ready():
	var source = tokenizer.start(Login)
	rewriter.start(source)
	# grab instance
	# set double as instance.set_double(meta, instance)
	# method crap
	
