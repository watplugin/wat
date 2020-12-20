extends Label
tool

const SUMMARY: String = \
"Time Taken: {t} | Ran {r} Tests | {p} Tests Passed | {f} Tests Failed | Ran Tests {e} Times"

var time: float = 0
var passed: int = 0
var failed: int = 0
var total: int = 0
var runcount: int = 0

func start_time() -> void:
	runcount += 1
	time = OS.get_ticks_msec()

func summarize(caselist: Array) -> void:
	time = (OS.get_ticks_msec() - time) / 1000
	print(time)
	passed = 0
	failed = 0
	total = 0
	for case in caselist:
		total += 1
		if case.success:
			passed += 1
		else:
			failed += 1
	var summary = {t = time, r = total, p = passed, f = failed, e = runcount}
	text = SUMMARY.format(summary)
	
