extends Object
class_name WATConfig

static func enforce_typed_parameters(checked: CheckBox):
	print('Setting to %s' % checked.pressed)
	ProjectSettings.set("wat/parameters", checked.pressed)
	
static func check_enforced_type_parameters() -> bool:
	var value = ProjectSettings.get("wat/parameters")
	return value