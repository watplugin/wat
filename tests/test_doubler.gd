extends WATT

var double_register: WATDouble

func _pre():
	double_register = WATDouble.new(TestTest)
	double_register.stub("login", {"username": "alex", "password": "code"}, "Stub is Correct")
	double_register.stub("register", {"username": "Jack", "password": "hit"}, "Hello?")
	
func test_doubler_exists():
	expect.is_true(double_register != null, "double exists")
	expect.is_equal("Stub is Correct", double_register.instance.login("alex", "code"), "100 == 100")
	expect.is_equal("Hello?", double_register.instance.register("alex", "hit"), "Hello? == Hello?")
	expect.is_equal("Beep Beep", "Beep Beep", "Beep Beep == Beep Beep")