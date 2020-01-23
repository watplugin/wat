extends Resource

#export(String, FILE) var test_loader = "res://addons/WAT/runner/loader.gd"
export(Resource) var test_loader = preload("res://addons/WAT/resources/loader.tres")
export(GDScript) var exit = preload("res://addons/WAT/exit.gd")
export(Resource) var test_results = preload("res://addons/WAT/resources/results.tres")
