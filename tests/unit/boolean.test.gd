extends WAT.Test
#extends "res://addons/WAT/test/test.gd"

func title():
	return "Given a Boolean Assertion"

func test_when_calling_asserts_is_true():
	describe("When calling asserts.is_true(true)")
	
	asserts.is_true(true, "Then it passes")
	
func test_when_calling_asserts_is_false():
	describe("When calling asserts.is_false(false)")
	
	asserts.is_false(false, "Then it passes")
		

## Only used sometimes
func test_when_calling_asserts_is_true_after_10s():
	describe("When a test runs for 10 seconds and then calls asserts.is_true(true)")
	
	OS.delay_msec(10000)
	asserts.is_true(true, "Then it passes")

## Only used sometimes
#func test_intentional_failure():
#	asserts.is_false(true)
