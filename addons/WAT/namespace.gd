extends Node
class_name WAT

# We use a WAT namespace so we aren't polluting the global namespace with WATStuff

const DOUBLE: Script = preload("TestDoubling/Doubler.gd")
const EXPECTATIONS: Script = preload("Scripts/expectations.gd")
const TEST: Script = preload("Scripts/test.gd")
const CASE: Script = preload("Scripts/case.gd")