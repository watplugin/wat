extends Reference

# Data Class to be passed around for building doubles

var title: String
var extend: String
var methods: Array


func _init(_title, _extend, _methods) -> void:
	title = _title
	extend = _extend
	methods = _methods