extends WATTest

# Scenes don't hold any static state; only references to other resources
# (We might need to load these resources each access but probably not?)
# We want to prevent dictionary errors on unreference...\
# We could probably handle this memory manually?
# We don't want to be calling object more than once on each resource

# I don't think we need to save the scene since we're creating
# the tree on the fly but it might end up necessary for Godot
# to read the scene contents

# testWhenDoublingAScene..
	# We get a non-null value back
	# We get an Object back
	# When calling Object
		# We get a node back with children
	# We can call get_node
		# Which gives us a resource
		# That we can stub