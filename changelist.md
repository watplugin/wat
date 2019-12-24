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

# 24th December (Working on Xmas Eve! You better appriciate this!)

- Fix Occassional Linux Crash (commit 0a0e35c54247319a708db975db1b934e1d8ee3d9)

    Quite frankly, screw this whole damned thing. WAT would sometimes crash, as
    in segfault with a core memory dump, on Linux when using test double mechanisims.

    This was largely in part due to how we were handling static data by saving the containers
    as a resource. It seems creating multiple of these caused criss-cross memory issues.

    So now instead we append the container to a const collection on the test double instead. This
    is valid for now but we may have to update it come 4.0 but for now it is okay.