# WAT

A Testing Plugin for Godot Game Engine

NOTE: ALPHA RELEASE. EXPECT BUGS AND BE DILLIGENT ABOUT BACKING UP YOUR WORK. DOCUMENTATION IS NON-EXISTANT.

[example](https://github.com/CodeDarigan/WAT/blob/master/screenshots/main.png)

## Quickstart Guide (intended for those familler with testing and or godot)

1) Add the WAT folder from here to your addons folder in your project
2) Turn WAT on in your Plugin settings
3) Create a test folder in the top level of your project directory
4) Create a script called "test_" + whatever you'd like to call it (e.g "test_login_functionality") that extends from WATTest
5) Tests have _start(), _pre(), _post() and _end() methods (if you require fixtures)
6) To write tests, create a method name "test_<NAMEHERE>" and use methods from expect (eg. expect.is_true(true, "true is true"))
7) You can double tests via WATDouble.new(script) (where script is a loaded script, class_name or string)
8) You can watch signal emits from the "watch(emitter, signal)" method inside WATTest scripts
9) When you want to run tests, go to "WAT:TestRunner" and click run.
10) Look into the expectations.gd script for what methods you can use

