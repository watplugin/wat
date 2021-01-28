# WAT 5 Checklist

## CORE

#### [X] __Test__

- [X] Test Suite
- ~~Test Suite of Suites~~ (Underutilized)
- [X] Test Case
- [X] Test Controller
- [X] Yielder
- [X] Signal Watcher
- [X] Recorder
- [X] Any
- [X] Parameters

##### [ ] __Test Runner__

- [X] TestRunner (Scene)
- [X] TestRunner Script
- [X] Single Threaded Runner
- [X] Multi Threaded Runner

#### [X] __Assertions__

- [X] Assertions List (One Script)
- [X] Base Assertion
- [X] Assertion Groupings (via Scripts)

#### [X] __Test Double__

- [X] Double Factory
- [X] Double Registry
- [X] Double Method
- [X] Double Method(s) // Unnecessary?
- [X] Scene Director
- [X] Script Director
- [X] Script Writer

## [ ] EDITOR

- [X] Test Launcher
    - [X] Launch via Editor
    - [X] Launch via Game / CLI
    - [X] Launch within Editor
- [X] Test Gatherer

## [ ] USER INTERFACE

- [ ] Scenes
    - [ ] CLI (GUI exists in top folder for JetBrains Plugin)
    - [X] Main Menu
    - [X] Test Menu
    - [X] Results Forest
    - [X] Result Tree
    - [X] Summary
    - [X] Links
- [X] Scripts
    - [X] GUI
    - [ ] CLI
    - [X] Main Menu
    - [X] TestMenu
    - [X] Results Forest

## [ ] RESOURCES

- ~~Resource Manager~~ (Not using resources with maybe exception of cache so unnecessary)
- [X] Test Metadata
- [ ] Test Cache ( *potentially problematic* )
- ~~Test Results ( *potentially problematic* )~~ (Handle by JSON Metadata or XML Results)
- [X] XML Results

## [ ]  MISCELLANOUS

- [X] GUI (Scene)
- [ ] Plugin
- [X] Settings
- [X] DockController
- [X] Quickstart
- ~~Test Strategy~~ (Replaced by Test Networking)
- [ ] Plugin Signals On Test Explorer
- [ ] ClassDB (Used for doubling built-ins in exported scripts)
- [ ] Namespace
