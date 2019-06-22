extends SceneTree
tool

const RUN_ALL = "RUNALL"

func _init() -> void:
	print("HelloAgain")
	var command: String = Array(OS.get_cmdline_args()).pop_back().to_upper()
	command.erase(0, 1)
	execute(command)
#	quit()

func execute(command) -> void:
	print("checking command: %s" % command)
	match command:
		RUN_ALL:
			print("found run all")
			var wat = load("WAT.tscn").instance()
			get_root().add_child(wat)
			wat.RunAll.emit_signal("pressed")






#	print(args)
#func example(word):
#	print("word")
#
#class CmdLineParser:
#	var _used_options = []
#	# an array of arrays.  Each element in this array will contain an option
#	# name and if that option contains a value then it will have a sedond
#	# element.  For example:
#	# 	[[-gselect, test.gd], [-gexit]]
#	var _opts = []
#
#	func _init():
#		for i in range(OS.get_cmdline_args().size()):
#			var opt_val = OS.get_cmdline_args()[i].split('=')
#			_opts.append(opt_val)