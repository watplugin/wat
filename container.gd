extends Reference

var registery: Dictionary = {}

func register(klass, dependecies: Array):
	registery[klass] = dependecies

func unregister(klass):
	registery.erase(klass)

func resolve(klass):
	var dependecies = registery.get(klass, null)
	if dependecies == null:
		return null
	var instances = []
	for dependecy in dependecies:
		if dependecy is Object:
			instances.append(resolve(dependecy))
		else:
			# We're just a random value
			instances.append(dependecy)
	return klass.callv("new", instances)

func get_constructor(klass):
	var constructor: Array = []
	var base: Array = registery[klass]
	for dependecy in base:
		if dependecy is Object:
			constructor.append(resolve(dependecy))
		else:
			constructor.append(dependecy)
	return constructor