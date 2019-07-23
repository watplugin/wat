extends WATTest

### BEGIN NOTE
# We cannot track bound arguments inherently (ie connect(signal, target, method, boundargs))
# Even if we bound them to the watcher, we wouldn't be able to check anything other than
# the fact that we bound them to the watcher which is a useless test
# Instead, if you want to track which arguments are passed, you should use spies on the target method
### END NOTE

func test_watcher_tracks_all_nonbound_arguments():
	describe("watch() tracks any argument that isn't bound at connection time (to an object other than watcher)")

	# Arrange
	add_user_signal("example")
	var watcher = load("res://addons/WAT/runner/watcher.gd").new()

	# Act
	watcher.watch(self, "example")
	emit_signal("example", 1, 20, 5)

	# Assert
	asserts.signal_was_emitted_with_arguments(self, "example", [1, 20, 5])

