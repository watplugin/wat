extends Reference

var _registery: Dictionary = {}

func register(klass: Object, dependecies: Array) -> void:
	_registery[klass] = dependecies

func unregister(klass: Object) -> void:
	_registery.erase(klass)

func resolve(klass) -> Object:
	var dependecies = _registery.get(klass, [])
	if dependecies.empty(): #
		return null # Return null? Shouldn't we just return the class?
	var instances = []
	for dependecy in dependecies:
		if _registery.has(dependecy):
			dependecy = resolve(dependecy)
		instances.append(dependecy)
	return klass.callv("new", instances)

func get_constructor(klass) -> Array:
	var constructor: Array = []
	var base: Array = _registery[klass]
	for dependecy in base:
		if _registery.has(dependecy):
			dependecy = resolve(dependecy)
		constructor.append(dependecy)
	return constructor