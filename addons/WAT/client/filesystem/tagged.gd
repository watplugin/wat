extends Reference
# Tag / Resource Path
var tagged: Dictionary = {}
var _settings: GDScript
var _tests: Array = []

func _init(settings: GDScript) -> void:
	_settings = settings
	update()

func tag(tag: String, path: String) -> void:
	update()
	if not tagged[tag].has(path):
		tagged[tag].append(path)
	
func untag(tag: String, path: String) -> void:
	update()
	if tagged[tagged].has(path):
		tagged[tag].erase(path)
		
func is_tagged(tag: String, path: String) -> bool:
	update()
	return tagged[tag].has(path)
	
func swap(old: String, new: String) -> void:
	for tag in tagged:
		if tagged[tag].has(old):
			tagged[tag].erase(old)
			tagged[tag].append(new)
	
func update() -> void:
	for tag in _settings.tags():
		if not tagged.has(tag):
			tagged[tag] = []
			
func set_tests(tag: String, root: Reference) -> void:
	_tests.clear()
	for test in root.get_tests():
		if tagged[tag].has(test["path"]):
			_tests.append(test)
	
func get_tests() -> Array:
	return _tests


