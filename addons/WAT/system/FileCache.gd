extends Resource
tool
# Path, Script
export(Dictionary) var scripts = {}

func all() -> Array:
	return scripts.values()

func script(scriptkey: String) -> Script:
	return scripts[scriptkey]

func save():
	ResourceSaver.save(resource_path, self)
