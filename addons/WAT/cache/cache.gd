extends Resource
class_name Cache

# NOTE
# DO NOT STORE SCRIPTS
# STORE CONTAINERS THAT STORE SCRIPTS (FOR REVERSE LOOKUP)

export(Array, Script) var scripts: Array = []

# Dict<String, Array<Script>>
# We include each level of directory here
# ie "res://tests" and "res://tests/unit" are two different arrays
export(Dictionary) var directories: Dictionary = {}

# Dict<String, Array<Script>>
export(Dictionary) var tags: Dictionary = {}

func tagged(tag: String) -> Array:
	return tags[tag]
	
func directory(dir: String) -> Array:
	return directories[dir]
