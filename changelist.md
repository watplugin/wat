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

- Added an "Expand Failures" option

    This expands all failure-based methods (right down to their base details) while collpsing all 100% passed tests, so you
    can get straight to the heart of the problem immediatly!

- Renamed TestSuite to TestSuiteOfSuites

    I've been reading a lot of xUnit Test Patterns by Gerard Mezaros. I'm trying to round out WAT's lexicon to be similair so
    this is something of a start. If Godot ever gets namespaces, it would be a lot easier!

- Give ResultsView a Minimum Height

    Mainly so you don't have to keep dragging it up every time you open it.