tool
extends Control

var test: Resource
var container: Dictionary
const Tag: PackedScene = preload("Tag.tscn")
onready var TagSelector: Control = $Select.get_popup()
onready var TagList: Control = $TagList
const _cache = preload("res://addons/WAT/cache/cache.tres")

func global_tags() -> Array:
	# Add this to settings?
	return ProjectSettings.get_setting("WAT/Tags")

func tags() -> Array:
	# May need to add error handling here
	# May need to add error handling her
	return container.tags
	
func _ready() -> void:
	$Data/ClearAll.connect("pressed", self, "_delete_all")
	test = container.test
	TagSelector.connect("about_to_show", self, "_update_selectable_tags")
	TagSelector.connect("id_pressed", self, "_add_tag")
	populate()
	
func _delete_all() -> void:
	for child in TagList.get_children():
		TagList.remove_child(child)
		child.queue_free()
	container.tags = []
	#ResourceSaver.save(test.resource_path, test)
	
func populate() -> void:
	for t in tags():
		var tag: Control = Tag.instance()
		TagList.add_child(tag)
		tag.Name.text = t
		tag.Delete.connect("pressed", self, "delete", [tag])
		
func delete(tag: Control) -> void:
	TagList.remove_child(tag)
	tag.queue_free()
	container.tags.erase(tag.Name.text)
	save()
	
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
	container.tags.append(tagtext as String)
	save()
	
func save():
	pass
	#ResourceSaver.save("res://addons/WAT/cache/cache.tres", _cache)
