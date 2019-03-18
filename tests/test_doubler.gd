extends WATTest

var login: WATDouble

func _pre():
	login = WATDouble.new(Login)
	login.stub("login", {"username": "alex", "password": "code"}, "Logged In")
	login.stub("login", {"username": "jack", "password": "captain"}, "Hello Captain Jack")
	login.stub("register", {"username": "dank", "password": "pass"}, "Username 'Dank' is unacceptable")

func test_doubler_all_should_pass():
	# In real tests, we would usually expect these to be called from elsewhere
	login.instance.login("alex", "code")
	expect.is_equal(login.instance.login("alex", "code"), "Logged In", "Logged In == Logged In")
	expect.is_equal(login.instance.login("jack", "captain"), "Hello Captain Jack", "Hello Captain Jack == Hello Captain Jack")
	expect.was_called(login, "login", "Login was called")
	expect.was_not_called(login, "register", "Register was not called")

func test_doubler_all_of_these_should_fail():
	login.instance.login("alex", "explode")
	expect.was_not_called(login, "login", "Login was not called")
	expect.was_called(login, "register", "register was called")