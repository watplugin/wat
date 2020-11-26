extends Node


# Not actually the test but rather the controller
func run(test):
	add_child(test)
	test.start()
	yield(test, "COMPLETED")
	return
	
func run_(test):
	add_child(test)
	test.start()
	yield(test, "COMPLETED")
	
