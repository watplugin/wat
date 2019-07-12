extends Reference

var registery: Dictionary = {}

func register(klass, dependecies: Array):
	registery[klass] = dependecies

func unregister(klass):
	registery.erase(klass)

func resolve(klass):
	var dependecies = registery[klass]
	var instances = []
	for dependecy in dependecies:
		if dependecy is Object:
			instances.append(resolve(dependecies))
		else:
			# We're just a random value
			instances.append(dependecy)
	return klass.callv("new", instances)