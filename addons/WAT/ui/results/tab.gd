extends Reference

var tree: Tree
var title: String
var idx: int
var count: int = 0

func _init(_tree: Tree, _title: String, _idx: int, _count: int) -> void:
	tree = _tree
	title = _title
	idx = _idx
	count = _count
