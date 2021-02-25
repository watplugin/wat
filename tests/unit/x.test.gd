extends WAT.Test

func test_x():
    var array = []
    asserts.that(array, "empty", [0, 2], "Array is empty", "Empty", "Found %s items" % array.size())