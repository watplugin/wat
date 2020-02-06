tool
extends Control

var test: Resource
const Index: Resource = preload("index.tres")
const Tag: PackedScene = preload("Tag.tscn")
onready var TagSelector: Control = $Tags/Select.get_popup()
onready var TagList: Control = $TagList

func global_tags() -> Array:
	# Add this to settings?
	return ProjectSettings.get_setting("WAT/Tags")

func tags() -> Array:
	# May need to add error handling here
	return Index.tags[id()]
	
func id() -> int:
	# returns position in scripts array
	return Index.scripts.find(test)
	
func _ready() -> void:
	$Data/ClearAll.connect("pressed", self, "_delete_all")
	test = load(test.resource_path) # I think this gives us the binary path?
	if not Index.scripts.has(test):
		Index.scripts.append(test)
		Index.tags.append([])
		save()
	populate()
	TagSelector.connect("about_to_show", self, "_update_selectable_tags")
	TagSelector.connect("id_pressed", self, "_add_tag")
	
func _delete_all() -> void:
	for child in TagList.get_children():
		delete(child)
	
func populate() -> void:
	for t in tags():
		var tag: Control = Tag.instance()
		TagList.add_child(tag)
		tag.Name.text = t
		tag.Delete.connect("pressed", self, "delete", [tag])
		
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
	Index.tags[id()].append(tagtext as String)
	save()
	
func delete(tag: Control) -> void:
	print("deleting")
	TagList.remove_child(tag)
	tag.queue_free()
	Index.tags[id()].erase(tag.Name.text as String)
	save()

func save() -> void:
	var err = ResourceSaver.save(Index.resource_path, Index)
	if err != OK:
		push_warning(err as String)
