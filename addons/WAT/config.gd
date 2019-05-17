extends Object
class_name WATConfig

# set double strategy (full, everything gets doubled and doesn't auto-call super OR partial, everything gets doubled and everything calls super default)
# defaults

static func _set_parameters(tick: CheckBox):
	ProjectSettings.set("wat/Parameters", tick.pressed)

static func _set_return_value(tick: CheckBox):
	ProjectSettings.set("wat/Returnvalue", tick.pressed)

static func _set_exclude_void(tick: CheckBox):
	ProjectSettings.set("wat/Voidexcluded", tick.pressed)

static func _set_script_prefixes(prefixes: String):
	ProjectSettings.set("wat/Scriptprefixes", prefixes)

static func _set_method_prefixes(prefixes: String):
	ProjectSettings.set("wat/Methodprefixes", prefixes)

static func parameters():
	return ProjectSettings.get("wat/Parameters")

static func return_value():
	return ProjectSettings.get("wat/Returnvalue")

static func void_excluded():
	return ProjectSettings.get("wat/Voidexcluded")

static func script_prefixes() -> String:
	return ProjectSettings.get("wat/Scriptprefixes")

static func method_prefixes() -> String:
	return ProjectSettings.get("wat/Methodprefixes")

static func defaults(force: bool = false):
	print("IGNORE ANY 'Property not found' WARNINGS HERE")
	if ProjectSettings.get("wat/Parameters") == null or force:
		ProjectSettings.set("wat/Parameters", true)
	if ProjectSettings.get("wat/Returnvalue") == null or force:
		ProjectSettings.set("wat/Returnvalue", true)
	if ProjectSettings.get("wat/Voidexcluded") == null or force:
		ProjectSettings.set("wat/Voidexcluded", true)
	if ProjectSettings.get("wat/Scriptprefixes") == null or force:
		ProjectSettings.set("wat/Scriptprefixes", "test")
	if ProjectSettings.get("wat/Methodprefixes") == null or force:
		ProjectSettings.set("wat/Methodprefixes", "test")
	print("FINISHED SETTING DEFAULTS OR HISTORICAL VALUES")