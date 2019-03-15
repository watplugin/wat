extends WATTest

#var login = Login.new()

func test_watch_was_emitted_should_pass():
	var login = Login.new()
	self.watch(login, "LOGGED_IN")
	login.login("alex", "pass")
	expect.signal_was_emitted("LOGGED_IN", "LOGGED_IN was emitted")
	
func test_watch_was_not_emitted_should_pass():
	var login = Login.new()
	self.watch(login, "LOGGED_IN")
	expect.signal_was_not_emitted("LOGGED_IN", "LOGGED_IN was not emitted")
	
func test_watch_was_emitted_should_fail():
	var login = Login.new()
	self.watch(login, "LOGGED_IN")
	expect.signal_was_emitted("LOGGED_IN", "LOGGED_IN was emitted")
	
func test_watch_was_not_emitted_this_should_fail():
	var login = Login.new()
	self.watch(login, "LOGGED_IN")
	login.login("alex", "pass")
	expect.signal_was_not_emitted("LOGGED_IN", "LOGGED_IN was not emitted")