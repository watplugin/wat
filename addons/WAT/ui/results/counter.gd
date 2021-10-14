extends Reference
# Counter TreeItem component for tests passed over total executed.

signal counter_changed

var component: TreeItem
var path: String
var title: String setget set_title
var passed: int = 0 setget set_passed
var total: int = 0 setget set_total
var show: bool = true

func _init(_component: TreeItem) -> void:
	component = _component
	connect("counter_changed", self, "display")

func set_passed(_passed: int) -> void:
	passed = _passed
	emit_signal("counter_changed")

func set_total(_total: int) -> void:
	total = _total
	emit_signal("counter_changed")

func set_title(_title: String) -> void:
	title = _title
	component.set_text(0, _title)

# Displays (total / passed) in the component text.
func display() -> void:
	if show:
		component.set_text(0, "(%s/%s) %s" % [passed, total, title])
