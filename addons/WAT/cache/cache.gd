tool
extends Resource
class_name Cache

# NOTE
# DO NOT STORE SCRIPTS
# STORE CONTAINERS THAT STORE SCRIPTS (FOR REVERSE LOOKUP)
export(Array, Script) var pool: Array = []
export(Array, String) var directories: Array = []
export(Array, int) var hashpool: Array = []
export(Array, Script) var suitepool: Array = []

func scripts(path: String) -> Array:
	var tests: Array = []
	for container in pool:
		if container.path.begins_with(path):
			tests.append(container)
	return tests

func tagged(tag: String) -> Array:
	var tests: Array = []
	for container in pool:
		if container.tags.has(tag):
			tests.append(container)
	return tests
