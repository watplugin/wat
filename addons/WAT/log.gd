extends Reference

# Add a setting toggle to turn off calls

static func method(function: String, source: Object) -> void:
	if ignore():
		return
	print("Called [%s] from [%s] " % [function, source.get_script().resource_path])

static func event(sig: String, source: Object) -> void:
	if ignore():
		return
	print("Emitted [%s] from [%s] " % [sig, source.get_script().resource_path])
	
static func ignore() -> bool:
	return true
