# ![Icon](./icon.svg) WAT
![3.3.2](https://github.com/CodeDarigan/WAT-GDScript/workflows/%20%20Godot%203.3.2%20%20/badge.svg)

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q51D9K5)

1. [Getting Started](#Install)
2. [Project Settings](#ProjectSettings)
3. [GUI](#GUI)
4. [CLI](#CLI)
5. [Example Tests](#Examples)

## Install
<a name="Install"></a>
0. It is advised to download WAT from the Godot Asset Library.
1. You may download WAT or WAT Mono from the release page.
2. Extract the downloaded zip file.
3. Add the addons folder from the extracted files to your Godot Project.
4. Enable the Plugin in Project -> Project Settings -> Plugin Tab
5. You should see a new "Tests" button in the bottom middle bar of the Godot Editor.

## Project Settings
<a name="ProjectSettings"></a>
Once you have enabled the WAT Plugin, you will be able to see the settings in 
ProjectSettings -> General -> Wat (right at the bottom). If you don't see it, you may
need to close the project settings and then re-open.

- *Test Directory*

    The test directory is where WAT will look for your tests. It defaults to your project's root
    but it is suggested to use a dedicated tests folder. You can also use an absolute path external to your
    project (like "C:/Users/YourName/YourProject/Tests").

- *Results Directory* 

    The results directory is where WAT will store the results of your tests in JUnit Standard XML. It defaults to
    your project's root but it is suggested to store it inside your tests folder. This is usefulfor those of you 
    who use Continous Integration (such as the github workflow action for WAT itself.) 

- *Metadata Directory*

    The metadata directory is where WAT will store metadata about your test scripts. Namely wheter they failed the last time and which tags they have been given. It defaults to your project's root but it is suggested to be stored in your
    test directory.

- *Tags*

    You can add string tags to your test so that you can run tests that are split across different folders in a group. You
    define which tags can be added in this setting but you do the actual adding via the GUI.

- *Window Size*

    Defines the window size when running Tests.

- *Port*

    This port is the port used for debugging tests. It is unlikely you'll need to change this often.

- *Display*

    This defines wheter the Test Panel is stored in the bottom window or one of the many docks around Godot's Editor.

## Graphical User Interface
<a name="GUI"></a>

![Image](/images/gui.png)

## Command Line Interface
<a name="CLI"></a>
You can run tests in your command line interface by navigating to your Project Directory and executing the command:  *godot addons/cli.tscn [ARGUMENTS]*

__Run All Tests__

    godot addons/WAT/cli.tscn run=all

__Run Directory__

    // Where X is the path of the directory you want to run
    godot addons/WAT/cli.tscn run=dir+X

__Run Script__

    // Where X is the absolute path of the script you want to run
    godot addons/WAT/cli.tscn run=script+X

__Run Method__

    // Where X is the absolute path of the script where the method is contained
    // and where Y is the name of the method
    godot addons/WAT/cli.tscn run=method+X+Y

__Run Failed__

    godot addons/WAT/cli.tscn run=failed

__Run Tagged__

    // Where X is the name of the tag you want to run
    godot addons/WAT/cli.tscn run=tag+X

__Repeat Tests__

    godot addons/WAT/cli.tscn run=all repeat=2
    OR
    godot addons/WAT/cli.tscn run=all r=2

    Note: Argument order does not matter so you can do this either
    godot addons/WAT/cli.tscn r=2 run=all

__Run on X Threads__

    godot addons/WAT/cli.tscn run=all thread=3
    OR
    godot addons/WAT/cli.tscn run=all t=3

    Note: Argument order does not matter so you can do this either
    godot addons/WAT/cli.tscn t=2 run=all

## Examples
<a name="GDScriptExamples"></a>
- GDScript Examples
    - [Basic Test](/tests/examples/gdscript/example.test.gd)
    - [Yielding in Tests](/tests/examples/gdscript/yield.test.gd)
    - [Watching Signals in Tests](/test/examples/gdscript/watch_signals.test.gd)
    - [Test Doubles](/test/examples/gd/script/doubles)

<a name="CSharpExamples"></a>
- C# Examples
    - [Basic Test](/tests/examples/csharp/ExampleTest.cs)
    - [Awaiting in Tests](/test/examples/csharp/AwaitTest.cs)
    - [Watching Signals in Tests](/test/examples/csharp/WatchingSignalsTest.cs)








