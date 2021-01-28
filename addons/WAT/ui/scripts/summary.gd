extends HBoxContainer
tool

var time: float = 0
var runcount: int = 0
var running = false

onready var Time: Button = $Time
onready var Tests: Button = $Tests
onready var Passing: Button = $Passing
onready var Failing: Button = $Failing
onready var Runs: Button = $Runs

func time() -> void:
	runcount += 1
	time = OS.get_ticks_msec()
	running = true
	
func _process(delta):
	if running:
		Time.text = str((OS.get_ticks_msec() - time) / 1000)

func summarize(caselist: Array) -> void:
	running = false
	var took = (OS.get_ticks_msec() - time) / 1000
	var passed = 0
	var failed = 0
	var total = 0
	for case in caselist:
		total += 1
		if case.success:
			passed += 1
		else:
			failed += 1
	Time.text = took as String
	Tests.text = total as String
	Passing.text = passed as String
	Failing.text = failed as String
	Runs.text = runcount as String
