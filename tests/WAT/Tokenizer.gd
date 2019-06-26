extends WATTest

const tokenizer = preload("res://addons/WAT/double/scripts/tokenizer.gd")

func start():
	print("rawr")
	
func test_thing():
	print("Tokenizer: 1")
	expect.is_true(true, "true is true")

func test_tokenizer_when_given_calculator():
	print("testing")
	expect.is_true(true, "true?")
	
func test_third_thing():
	print("testing third thing")
	expect.is_true(true, "third true")

func test_a_b_c_d_e():
	expect.is_true(true, "abcde")
	
#func test_third_thing():
#	var source_data = tokenizer.start(Calculator)
#	var methods = source_data.methods
#	var add = methods[0]
#	var subtract = methods[1]
#	var multiply = methods[2]
#	var divide = methods[3]
#	expect.is_equal("Doubled_calculator", source_data.title, "Tokenized data name is source script name")
#	expect.is_equal('extends "res://Examples/calculator.gd"', source_data.extend, "Tokenized Data extends from source script")
#	expect.is_equal(4, source_data.methods.size(), "Tokenized Data has 4 Methods")
##	expect.loop("is_equal", [[add.name, "add", "method add was doubled"], [subtract.name, "subtract", "method subtract was doubled"], [multiply.name, "multiply", "method multiply was doubled"], [divide.name, "divide", "method subtract was doubled"]])
#	expect.is_equal(add.parameters.size(), 2, "add has 2 parameters")
#	expect.is_equal(subtract.parameters.size(), 2, "subtract has 2 parameters")
#	expect.is_equal(multiply.parameters.size(), 2, "multiply has 2 parameters")
#	expect.is_equal(divide.parameters.size(), 2, "divie has 2 parameters")
#	print(source_data.methods)

#[{name:add, parameters:[{name:a, type:null, typed:False}, {name:b, type:null, typed:False}], returns_value:True, retval:{type:var, typed:False}},
# {name:subtract, parameters:[{name:a, type:null, typed:False}, {name:b, type:null, typed:False}], returns_value:True, retval:{type:var, typed:False}},
# {name:multiply, parameters:[{name:a, type:null, typed:False}, {name:b, type:null, typed:False}], returns_value:True, retval:{type:var, typed:False}},
# {name:divide, parameters:[{name:a, type:null, typed:False}, {name:b, type:null, typed:False}], returns_value:True, retval:{type:var, typed:False}}]

#extends Reference
#
## Data Class to be passed around for building doubles
#
#var title: String
#var extend: String
#var methods: Array
#
#
#func _init(_title, _extend, _methods) -> void:
#	title = _title
#	extend = _extend
#	methods = _methods