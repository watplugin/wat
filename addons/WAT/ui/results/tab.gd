extends Reference

var tree: Tree
var title: String
var idx: int = 0
var count: int = 0

func _init(_tree: Tree, _title: String) -> void:
	tree = _tree
	title = _title
