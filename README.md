# WAT

A Testing Plugin for Godot Game Engine

## Overview

### Basics

- Test Script
- Test Case - Stores result of a test: *When using nested classes, each class get its own case object*
- Display
- Expectations *The actual test methods*
- Assert *Used for setup/teardown, cancels the test due to broken fixtures*

### Doubles

- Rewrite Source Code *We may never need to actually save these scripts since they'll be passed around via DI*

- The default rewrite is for your immediate script: We may need to use a config to default
back to how far we want to rewrite the source code when it comes to extended. May need to
use get_base_script recursion along with a null check

- Stub Methods (predefine parameter sets, loop through on call)

- Spies
  - How many times x Signal was emitted
  - How many times x method called
  - Record call with Kwargs
  - Record what value it returned when called
  - If Method was called by Signal? (Not sure if possible?)

- Doubling Scenes

    I'm not sure how to approach this or the particular use case for it (that cannot
    already be achieved by doubling scripts themselves)

### Helpers

- Simulate
- Yield / Yield For X

### Configurations

- Command Line vs Display
- Enforcing Strict Syntax
- Inner Classes
- Prefix Settings
- Directories (We'll start off with a basic generic "tests" folder for the moment)
- Print to console or not
- Change test prefix
- Change file prefix
- Directory information
- Log Levels