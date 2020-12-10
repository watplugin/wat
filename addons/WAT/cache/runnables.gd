tool
extends Resource

export(Array, Script) var tests = []

func clear():
	tests = []
	ResourceSaver.save(resource_path, self)
	ResourceLoader.load(resource_path, "", true)
