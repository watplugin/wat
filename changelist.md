WAT Version 5.0.0

## 15 November 2019:
- Added Official Chagelist

## 16 Novemeber 2019:

- Commit #6efd2386020ef25acd26070fccb5266e37471cc9 - Temp folder is now created per test run

    Temp Folder is now created each time we run the tests. Previously it
    was only created on plugin load which caused some 404 errors. It checks
    now just in case.

- Commit #98cc2de800d64bec389792ee25a25f80149da782 - Add exit codes to CLI

    Previously we were only printing 0 & 1 so it didn't work properly with CI. It should
    work fine now though!

## 17th Novemeber 2019

- commit 5f04ea965083c82681ddb948c332989502566e0f

    Move Call To Quit in CLI.gd

    The CLI's init function was to run and then to quit. This caused issues
    when we yielded because we kept going back to quit before finishing. We've
    moved quit to execute after we handle results.
    
## 14th December 2019

- Merged https://github.com/CodeDarigan/WAT/pull/47
    
    Change UI Screen
    
    UI Panel moved to the bottom panel to help prevent unnecessary context switching.
    (Basically you can see the immediate code you're testing)

## 19th Decemeber

### Functionality

- Introducing TestSuites (commit c424c56ce5bde8067510a53a8d0850be68b10de6)

    Created TestSuite which allows you to create inner-class WATTests. To use this
    extend WAT.TestSuite and then create inner classes that extend WATTest / WAT.Test

- Introducing WAT namespace (commit commit 4af35f304d1fff34e735fc3373f230f0a20d6216)

    This allows us to define a central place for tests you
    extend from. Basically you can now "extends WAT.Test"
    rather than "extends WATTest".

    We encourage users to WAT.Test as WATTest will be deprecated
    come version 5.0

### 3.2 Compatability Fixes

- Fix Name Conflict: to_string is no longer valid because of a builtin method in Godot

- Fix Double Writer

- until_signal/timeout now use the CONNECT_DEFERRED flag to avoid locks

## 24th December (Working on Xmas Eve! You better appriciate this!)

- Fix Occassional Linux Crash (commit 0a0e35c54247319a708db975db1b934e1d8ee3d9)

    Quite frankly, screw this whole damned thing. WAT would sometimes crash, as
    in segfault with a core memory dump, on Linux when using test double mechanisims.

    This was largely in part due to how we were handling static data by saving the containers
    as a resource. It seems creating multiple of these caused criss-cross memory issues.

    So now instead we append the container to a const collection on the test double instead. This
    is valid for now but we may have to update it come 4.0 but for now it is okay.

## 27th December

- Add Script Template Generator (commit  219bcb3)

    You can define your own templates in Godot 3.2. WAT now includes a button that will add
    a WAT Template to your script_templates folder (if it isn't already created, WAT will
    create it)

## 28th December

- Refactor Test Doubles to be created in memory instead of saved in the filesystem (commit 266bbd)

    After writing the test double script implementation we now use script.reload() to
    have the implementation loaded into memory. From here we can instance it. So we
    no longer have to rely on the filesystem to create test doubles. This should
    significantly improve performance if you were heavy on test doubles beforehand.

# 20th January

The Holidays are over but friends do I have a gift for you!

- WAT now runs in the scene context!

    Don't worry! As a user you will still be using WAT through the Editor Interface but I did some trickery behind
    the scenes which means when you click run WAT will now run in the Scene context (as if it were a game) instead of
    the Editor context. This is important for two HUGE reasons;

        1. Autoloads do not exist for the editor. Only for the games in Godot! This change now allows the use of autoloads
        within tests. I'll leave it up to you to decide if that's good or not!

        2. You can now debug your tests! If a test is giving you trouble, you can set two breakpoints between the start and end of it
        to thoroughly debug it! Similar to Autoloads previously, you couldn't access debugging features in the tests (you also couldn't
        use methods like get_stack(), print_stack() or print_debug() but you can now). I can't express to you just how excited I am
        about how much more useful this makes WAT.

- Command Line Interface is now a Scene

    With the changes made to WAT on the visual end to run as a scene. I wanted the same ability for the CLI. So I've changed
    it to a scene. You still use it in the exact same way except no need for the prefixed -s and of course .gd becomes .tscn.

    You can debug command line tests by adding in -d option

        .e.g godot -d addons/WAT/cli.tscn -run_script="res://test/unit/mario.jump.test.gd"

- Yields can now be used in all of the virtual methods in test

    The test controller has been reworked into something of a state machine that can be influenced by the yielder. Essentially
    this means you can now yield in start(), pre(), post() and end() as well as test methods. You can also yield as many times
    as you like without issue!

- Added an "Expand Failures" option

    This expands all failure-based methods (right down to their base details) while collpsing all 100% passed tests, so you
    can get straight to the heart of the problem immediatly!

- Renamed TestSuite to TestSuiteOfSuites

    I've been reading a lot of xUnit Test Patterns by Gerard Mezaros. I'm trying to round out WAT's lexicon to be similair so
    this is something of a start. If Godot ever gets namespaces, it would be a lot easier!

- Give ResultsView a Minimum Height

    Mainly so you don't have to keep dragging it up every time you open it.

## UPCOMING RELEASE NOTES BELOW

# 29th January

- Add Go To Method In Results Display

    On the right side of the results display after running a test, you can click a function (fn) icon symbol and it will open the script
    editor to that method (approximately)

- Added Subcall To Doubled Methods

    You can pass in a FuncRef or an object with a call_func method that takes an object and an array of arguments and then pass that in to be subcalled
    when a test doubled method is called. This can be useful if you want to get some indirect access to state or have a tighter control over where you
    want the call branch to go.

# Feb 1st

- Add Links

    Added four links, one that points to documentation (hopefully update), one to post an issue directly to github, another
    to post a doc request to github and finally one to my Ko-Fi if you want to help me improve WAT (to make a living from this, one
    can dream)

# Feb 5th

- Add assert.fail(context = "")

    An assertion that always fail (along with an error message) for non implemented tests.

# Feb 6th

- Yielding now returns an array of six values

    yield(until_signal()) or yield(until_timeout()) now returns an Array of up to 6 values. If you're expecting a single return
    value it is element 0, if you're expecting an array or dictionary return value, it is nested. Any values you're not expecting should
    be defaulted to null.

# Feb 7th

- Add QuickPlay Button

    Add a QuickPlay Button to allow you to run all your tests very quickly

- You can now change the dock position via a list of choices ProjectSettings/WAT/Display that updates in real time

# March 9th 2020

- Add Signal Was Emitted X Times


# March 23 2020

- Users can now double built in classes

    You can now double a built in class by passing in a string of that class name to the first argument of the direct.script()
    method. I don't know if you need this but WAT did for the change below so I got added.

- Double All Nodes In A Scene

    Previously when doubling a scene, I would only double the nodes with a script which caused problems internally when people
    were trying to access methods like is_on_floor on a KinematicBody2D that store its functional code outside of it. Now I double
    everything to make sure this doesn't happen.

# 5th April 2020

- Add Object Assertions

    Add an assertion per boolean method (except can_translate()) in the object API. Likely won't be doing this for other classes.

# 6th April

- Add Assert.That

    I was initially planning on wrapping every single boolean method in Godot but that is honestly just too much. So Instead I've created
    assert that that takes an object, a string method of that object, any additional arguments and tries its best to make a custom assertion on
    command. In addition to this you can add your own custom success and failure messages in it along with the usual context string.

- Remove crash on failure

    I don't think anybody knew this but in older versions of WAT you could intentionally crash scripts if a precondition failed.
    I've removed this for now but it may come back later.

# 7th April 2020

- Added JUnit XML (for the continous integration afficnados)

    Test Results are now saved as JUnit XML which is fairly standard for a number of other testing related software. It can
    be especially useful when using Continous Integration to give a nicer view than WAT's output print.

    You can edit where this is stored in ProjectSettings/WAT/Results_Directory

# 8th April 2020

- Dependencies can now be passed on double

    Instead of passing dependecies when directing a script, you can now pass them in when calling double on a
    director instead. This will only work if you didn't pass them in already.


# 11th April 2020

- Automate Spying On Test Double Methods

    There wasn't any real reason for this to not exist. Users could simply choose to ignore it if they didn't need it
    but it does no harm by existing (and on a personal note it has tidied up core code)

# 15th April 2020

- Fix Parameterized Testing Bug

    Parameterized Tests were broken so that a script with one test didn't work. This has now been fixed.

# 19th April 2020

- Remove More Options From GUI

    Print Stray Nodes wasn't working and we will be adding a WAT Template if it doesn't already exist on PluginLoad.

- Scene/Script Directors now return the same double on call

    Null is bad so this was our second best option. Directors will return the same double if they call double any time after
    the first time they called double)

- GUI now stays on Results Screen

    When using the WAT GUI it now stays on the test results screen instead of being moved to the output panel. You can still move
    out of this manually but it doesn't do it by default anymore

# 24th April 2020

- Add Recorder Object To Test Script

    By passing the object you're tracking along with an array of properties on that Object as a String, you can now record their changes
    once per process call. Obviously this isn't perfect and it can screw with reference or shallow objects (like dictionaries etc)

- Describe Is Now Optional

    Describe is now an optional choice. If you choose not to use it your test will use the method named (formatted to look pretty) instead (and now
    if you forget describe your tests won't crash)

- Assertion Context is Now Optional

    Previously for the GUI to make visual sense you would have to have added a context String to your assertion. No longer. Now you can omit it entirely and assuming
    all of your context strings are blanks for each assertion in that one test your test will be collapsed immediatly.

- Add Tagged Tests

    You can add tags to your tests. When you click on a WAT.Test Script, an inspector plugin should open with the dropdown to "add tag" which chooses from a list of tags
    you've defined in WAT/Settings/Tag. You can run these tags via the tag selector afterwards. The system that uses this is smart so it should be able to track when you moved
    a tagged test script to a different area of the test directory. Meaning that your tests no longer require an obvious filepath
