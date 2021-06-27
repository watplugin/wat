extends WAT.Test

# Load Resource
# It Has Tags
# Save Resource elsewhere
# Remove original resource
# Is the new path updated?

# We likely only need to update the files when they're moved (and only because
# ..they store important tag metadata). All other elements can just force an update..
# ..with that said we only need to flag the update, we don't need to change anything..
# ..until we open the menu for the time since the update
# so fileremoved, foldermoved, folderremoved, resourcesaved we just flag
# ..whereas with file moved, we update

func test_deleted_resource_has_no_res_path() -> void:
	var resource: Resource = Resource.new()
	var _err: int = ResourceSaver.save("res://test.tres", resource)
	yield(get_tree(), "idle_frame")
	var source: String = "res://test.tres"
	var _errx: int = Directory.new().remove(source)
	asserts.is_equal(resource.resource_path, "", 
		"A deleted resource has no resource_path")
