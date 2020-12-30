extends HBoxContainer 
tool

var time: float = 0
var runcount: int = 0

func start_time() -> void:
	runcount += 1
	time = OS.get_ticks_msec()

func summarize(caselist: Array) -> void:
	time = (OS.get_ticks_msec() - time) / 1000
	var passed = 0
	var failed = 0
	var total = 0
	for case in caselist:
		total += 1
		if case.success:
			passed += 1
		else:
			failed += 1
	$Time.text = time as String
	$Tests.text = total as String
	$Passing.text = passed as String
	$Failing.text = failed as String
	$Runs.text = runcount as String
	
