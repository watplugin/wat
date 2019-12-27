extends Reference


var total: int = 0
var passed: int = 0
var title: String
var path: String
var methods: Array = []
var crashed: bool = false
var crashdata: Reference
var success: bool = false

func add_crash_data(data) -> void:
	crashdata = data
	crashed = true

func add_method(method: String) -> void:
	methods.append({title = method, expectations = [], total = 0, passed = 0, success = false, context = ""})

func _add_expectation(expectation) -> void:
	var method: Dictionary = methods.back()
	method.expectations.append(expectation)

func _add_method_context(context: String) -> void:
	if methods.back().context == "": # Only set context per method once
		methods.back().context = context

func crash(expectation: Reference) -> void:
	crashdata = expectation

func calculate() -> void:
	if crashed:
		return
	for method in methods:
		for expectation in method.expectations:
			method.passed += int(expectation.success)
		method.total = method.expectations.size()
		method.success = method.total > 0 and method.total == method.passed
		passed += int(method.success)
	total = methods.size()
	success = total > 0 and total == passed
