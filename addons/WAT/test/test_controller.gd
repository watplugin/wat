extends Node

enum {START, PRE, EXECUTE, POST, END}
var _state: int = START
var _yielder
var _test

func _init(test) -> void:
	_test = test

func _change_state() -> void:
	if _yielder.is_active():
		return
	match _state:
		START:
			_pre()
		PRE:
			_execute()
		EXECUTE:
			_post()
		POST:
			_pre()
		END:
			_end()
			
func run() -> void:
	_start()
	
func _start() -> void:
	pass
	
func _pre() -> void:
	pass
	
func _post() -> void:
	pass
	
func _execute() -> void:
	pass
	
func _end() -> void:
	pass
	
