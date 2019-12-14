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
    
# 14th December 2019

- Merged https://github.com/CodeDarigan/WAT/pull/47
    
    Change UI Screen
    
    UI Panel moved to the bottom panel to help prevent unnecessary context switching.
    (Basically you can see the immediate code you're testing)
