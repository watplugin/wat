extends WATT

#func _pre():
#	print(100)
#
##func test_x():
##	print(10000)

var double_register: WATDouble

func _pre():
	double_register = WATDouble.new(TestTest)
	
func test_doubler_exists():
	expect.is_true(double_register != null, "double exists")