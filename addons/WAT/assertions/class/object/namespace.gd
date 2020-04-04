extends Reference

const IsFreed: Script = preload("is_freed.gd")
const IsNotFreed: Script = preload("is_not_freed.gd")
const HasMeta: Script = preload("has_meta.gd")
const DoesNotHaveMeta: Script = preload("does_not_have_method.gd")
const HasMethod: Script = preload("has_method.gd")
const DoesNotHaveMethod: Script = preload("does_not_have_method.gd")
const HasUserSignal: Script = preload("has_user_signal.gd")
const DoesNotHaveUserSignal: Script = preload("does_not_have_user_signal.gd")
const IsQueuedForDeletion: Script = preload("is_queued_for_deletion.gd")
const IsNotQueuedForDeletion: Script = preload("is_not_queued_for_deletion.gd")
const IsBlockingSignals: Script = preload("is_blocking_signals.gd")
const IsNotBlockingSignals: Script = preload("is_not_blocking_signals.gd")
const IsConnected: Script = preload("is_connected.gd")
const IsNotConnected: Script = preload("is_not_connected.gd")

# Questionable Assertions
# 1 - Can Translate Messages - I don't know how this work right now so
# I'm going to avoid it.

# 2 - is_class. This exists elsewhere but this only works for built-in classes


