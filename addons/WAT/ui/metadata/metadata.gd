tool
extends Control

var test: Resource
const Tag: PackedScene = preload("Tag.tscn")
onready var TagSelector: Control = $Select.get_popup()
onready var TagList: Control = $TagList
const Metadata = preload("../../cache/metadata.tres")

func global_tags() -> Array:
	# Add this to settings?
	return ProjectSettings.get_setting("WAT/Tags")

func tags() -> Array:
	# May need to add error handling here
	var tags = []
	if(test.has_meta("tags")):
		tags = test.get_meta("tags")
	else:
		test.set_meta("tags", [])
	return tags
	
func _ready() -> void:
	for key in ProjectSettings.get("WAT/Tags"):
		if not Metadata.scripts.has(key):
			Metadata.scripts[key] = []
	$Data/ClearAll.connect("pressed", self, "_delete_all")
	test = load(test.resource_path) # I think this gives us the binary path?
#	if test != null and not Metadata.scripts.has(test):
#		# Used to store data between runs
#		Metadata.scripts.append(test)
	TagSelector.connect("about_to_show", self, "_update_selectable_tags")
	TagSelector.connect("id_pressed", self, "_add_tag")
	ResourceSaver.save(Metadata.resource_path, Metadata)
	populate()
	
func _delete_all() -> void:
	for child in TagList.get_children():
		TagList.remove_child(child)
		child.queue_free()
	test.set_meta("tags", [])
	ResourceSaver.save(test.resource_path, test)
	
func populate() -> void:
	for t in tags():
		var tag: Control = Tag.instance()
		TagList.add_child(tag)
		tag.Name.text = t
		tag.Delete.connect("pressed", self, "delete", [tag])
		
func delete(tag: Control) -> void:
	TagList.remove_child(tag)
	test.get_meta("tags").erase(tag.Name.text)
	tag.queue_free()
	Metadata.scripts[tag.Name.text].erase(test)
	ResourceSaver.save(test.resource_path, test)
	
		
func _update_selectable_tags() -> void:
	TagSelector.clear()
	for tag in global_tags():
		if not tag as String in tags():
			TagSelector.add_item(tag)
	TagSelector.update()
			
func _add_tag(id: int) -> void:
	var tagtext: String = TagSelector.get_item_text(id)
	var tag: Control = Tag.instance()
	TagList.add_child(tag)
	tag.Name.text = tagtext
	tag.Delete.connect("pressed", self, "delete", [tag])
	var currentTags = test.get_meta("tags")
	currentTags.append(tagtext as String)
	test.set_meta("tags", currentTags)
	Metadata.scripts[tag.Name.text].append(test)
	var err = ResourceSaver.save(test.resource_path, test)
	if err != OK:
		push_error(err as String)
