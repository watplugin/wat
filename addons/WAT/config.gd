extends Object
class_name WATConfig

# set double strategy (full, everything gets doubled and doesn't auto-call super OR partial, everything gets doubled and everything calls super default)
# defaults

static func _set_parameters(tick: CheckBox):
	ProjectSettings.set("wat/parameters", tick.pressed)
	
static func _set_return_value(tick: CheckBox):
	ProjectSettings.set("wat/returnvalue", tick.pressed)
	
static func _set_exclude_void(tick: CheckBox):
	ProjectSettings.set("wat/voidexcluded", tick.pressed)
	
static func _set_text_prefixes(prefixes: Array):
	ProjectSettings.set("wat/testprefixes", prefixes)
	
static func _set_method_prefixes(prefixes: Array):
	ProjectSettings.set("wat/methodprefixes", prefixes)
	
static func _set_double_strategy(tick: CheckBox):
	ProjectSettings.set("wat/doublestrategy", tick.pressed)
	
static func parameters():
	return ProjectSettings.get("wat/parameters")
	
static func return_value():
	return ProjectSettings.get("wat/returnvalue")
	
static func void_excluded():
	return ProjectSettings.get("wat/voidexcluded")
	
static func test_prefixes():
	return ProjectSettings.get("wat/testprefixes")
	
static func method_prefixes():
	return ProjectSettings.get("wat/methodprefixes")
	
static func double_strategy():
	return ProjectSettings.get("wat/doublestrategy")

static func defaults():
	# if not have
		# create new setting
	# if setting already exists
		# affect buttons (ie false = unticked box)
	pass