extends WAT.Test

const x = preload("res://new_script.gd")

func test_simple() -> void:
	parameters([["addend", "augend", "result"], [2, 2, 4], [4, 4, 8], [5, 5, 10]])
	var context = "%s + %s = %s" % [p["addend"], p["augend"], p["result"]]
	asserts.is_equal(p["addend"] + p["augend"], p["result"], context) 
