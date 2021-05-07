extends SpinBox
tool

var oldText

func _ready():
	get_line_edit().expand_to_text_length = true
	get_line_edit().connect("text_changed", self, "_on_text_edit_changed")
	get_line_edit().connect("focus_exited", self, "_on_focus_exited")
	connect("value_changed", self, "_on_value_changed")
	oldText = get_line_edit().text
	
	# Set's the text to itself in order to shoot an update to the line edit
	# This is needed or else the line edit starts off off-centered at startup
	get_line_edit().text = oldText

func _on_focus_exited():
	# Disgusting frame waiting workaround because there is currently no way to 
	# listen for when a spinbox is changed and the change is rejected.
	# (ie. inputting 20 in the spinbox when the spinbox already has a value of 20)
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	set_size(get_minimum_size())
	pass

func _on_value_changed(newValue):
	set_size(get_minimum_size())
	
func _on_text_edit_changed(newText):
	# Using regex since you cannot reliably detect if a string is not an int
	# (ie. String(invalid text) = 0, when 0 might be a value we want)
	var regex = RegEx.new()
	regex.compile("^(0|[1-9][0-9]*)$")
	
	# Remove prefix and suffixes
	newText = newText.trim_prefix(prefix + " ").trim_suffix(" " + suffix)
	
	# Try and parse the inputted text in the middle
	var result = regex.search(newText)
	var invalidInput = false
	
	# If input is not an integer (excluding empty input), then revert the input back
	if not newText.empty() and not result:
		get_line_edit().text = oldText
		invalidInput = true
	# If input is out of bounds, bring it back to the nearest bound  
	elif result:
		if int(result.get_string()) > max_value:
			get_line_edit().text = str(max_value)
			get_line_edit().caret_position = get_line_edit().text.length()
			invalidInput = true
		elif int(result.get_string()) < min_value:
			get_line_edit().text = str(min_value)
			get_line_edit().caret_position = get_line_edit().text.length()
			invalidInput = true
	
	if not invalidInput:
		oldText = prefix + " " + newText + " " + suffix
	
	set_size(get_minimum_size())
