tool
extends Control

# TODO
# Implement Run Tags
# Implement Deleting Tags
# Add Counts
# OptionButton changes on selector

var test: Script 
onready var TagArray: Control = $Main/TagArray
onready var Options: Control = $Main/Options
onready var ShowTags: Button = $Main/Options/Button
onready var TagSize: Label = $Main/TagArray/Size
onready var TagSizer: SpinBox = $Main/TagArray/SpinBox
var _cache: Array
var _tags: PoolStringArray = []
var _count: int = 0

func _ready() -> void:
	ShowTags.connect("pressed", self, "_show_tags")
	TagSizer.connect("value_changed", self, "_set_sizes")
	add_tags()
	
func add_tags() -> void:
	if not test.has_meta("Tags"):
		test.set_meta("Tags", [])
		return
	print(test.get_meta("Tags"))
	_tags = test.get_meta("Tags")
	for tag in _tags:
		_add_tag(tag)
	ShowTags.text = "Array (size %s)" % _count as String
	TagSizer.value = _count
	if _count > 0:
		TagArray.visible = true
		
func _set_sizes(value: int) -> void:
	_count = 0
	clear_cache()
	for i in value:
		# if current index is greater than tags
		if i > _tags.size() - 1:
			# add default tag
			_add_tag()
		else:
			# add tag from index
			_add_tag(_tags[i])
			
func clear_cache() -> void:
	for item in _cache:
		item.get_parent().remove_child(item)
		item.queue_free()
	
func _add_tag(tag: String = "Untagged") -> void:
	var count = Label.new()
	var taglabel = OptionButton.new()
	taglabel.align = OptionButton.ALIGN_CENTER
	taglabel.action_mode = Button.ACTION_MODE_BUTTON_RELEASE
	expand(count)
	expand(taglabel)
	taglabel.connect("pressed", self, "_populate_menu", [taglabel])
	taglabel.connect("item_selected", self, "_save_tag", [taglabel])
	_count += 1
	count.text = _count as String
	taglabel.text = tag
	_cache.append(count)
	_cache.append(taglabel)
	TagArray.add_child(count)
	TagArray.add_child(taglabel)

func _save_tag(id: int, taglabel: OptionButton) -> void:
	if taglabel.get_item_text(id) == "Untagged":
		push_warning("Invalid")
		return
	test.get_meta("Tags").append(taglabel.get_item_text(id))
	print(test.get_meta("Tags"))
	push_warning("Saving Not Implemented")
	
func expand(control: Control) -> void:
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
func _populate_menu(menu: OptionButton) -> void:
	menu.clear()
	menu.add_item("Tag")
	for tag in ProjectSettings.get_setting("WAT/Tags"):
		if not tag in test.get_meta("Tags"):
			var data = {"tag": tag, "tags": test.get_meta("Tags")}
			print("{tag} is not in {tags}".format(data))
			menu.add_item(tag)
	
func _show_tags() -> void:
	TagArray.visible = not TagArray.visible

"""
0) Click Array Button -> Hides/Shows TagArray
1) On Load: Define Tag Array Size and Show
2) On Load: Populate With Tags via Metadata (on click instead?)
3) On MenuButton Clicked: Show Tag Options EXCEPT already selected
"""
