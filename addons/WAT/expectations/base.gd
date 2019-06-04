extends Reference

const TYPES = preload("res://addons/WAT/constants/type_library.gd")
var success: bool
var expected: String
var result: String
var notes: String = "No Notes"

func type2str(value):
	return TYPES.to_string(typeof(value))