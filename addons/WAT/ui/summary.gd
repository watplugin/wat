extends HBoxContainer
tool

var time: float = 0
var runcount: int = 0
var running = false
var time_taken: float = 0.0

onready var Time: Button = $Time
onready var Tests: Button = $Tests
onready var Passing: Button = $Passing
onready var Failing: Button = $Failing
onready var Runs: Button = $Runs

func _ready() -> void:
	for child in get_children():
		child.set_focus_mode(FOCUS_NONE)

func time() -> void:
	time_taken = 0.0
	runcount += 1
	time = OS.get_ticks_msec()
	running = true
	
func _process(delta):
	if running:
		Time.text = str((OS.get_ticks_msec() - time) / 1000)

func summarize(caselist: Array) -> void:
	running = false
	time_taken = (OS.get_ticks_msec() - time) / 1000
	var passed = 0
	var failed = 0
	var total = 0
	for case in caselist:
		total += 1
		if case.success:
			passed += 1
		else:
			failed += 1
	Time.text = time_taken as String
	Tests.text = total as String
	Passing.text = passed as String
	Failing.text = failed as String
	Runs.text = runcount as String
	
func _setup_editor_assets(assets_registry):
	Time.icon = assets_registry.load_asset(Time.icon)
	Tests.icon = assets_registry.load_asset(Tests.icon)
	Passing.icon = assets_registry.load_asset(Passing.icon)
	Failing.icon = assets_registry.load_asset(Failing.icon)
	Runs.icon = assets_registry.load_asset(Runs.icon)
