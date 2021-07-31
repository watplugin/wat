# ![Icon](./icon.svg) WAT 
![3.2.3](https://github.com/CodeDarigan/WAT-GDScript/workflows/%20%20Godot%203.2.3%20%20/badge.svg)


[Documentation](https://wat.readthedocs.io/en/latest/index.html)

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q51D9K5)

# WAT Final Changelist

Thanks to @Jummit for a lot work on this one including new icons.

- New Icon

- Improved Yielder Code
- Buttons are not selectable
- Icons to link drop
- Exported values are now doubled properly


- [Add New WAT Icon (Big Thanks to Jummit for this!)](https://github.com/AlexDarigan/WAT/pull/226)
- [Replace Icons with Godot Icons](https://github.com/AlexDarigan/WAT/pull/220)
- [Make Summary Buttons Unselectable](https://github.com/AlexDarigan/WAT/pull/221)
- [Add Icons to Link Dropdown](https://github.com/AlexDarigan/WAT/pull/223)
- [Improved a number of Warnings]
- [Remove Non Functional Save Metadata Button](https://github.com/AlexDarigan/WAT/commit/68ac560307e6cb70862324d313be83b11eb3d5f0)
- [Fix Filter Results Error](https://github.com/AlexDarigan/WAT/commit/79a55c00282c1265001c13f9392b94ba9679e2a0)
- [Increase Timeout on Server To Prevent Early Exits](https://github.com/AlexDarigan/WAT/commit/fd5ae8d9fd9d57b2006e142ec39fa95b8ba1325b)
- [Exported Values are now doubled properly](https://github.com/AlexDarigan/WAT/commit/1c6cde758d1f3a1af12cbc624fa11a831db7d8d9)
- [Infer Type of Assertions Script](https://github.com/AlexDarigan/WAT/commit/6c4ab63da4eed03c33e3210629903bbb8d861878)

Mono

- [Fix Calling Tests With A Single Method](https://github.com/AlexDarigan/WAT/commit/6d896a3fb989516f00ff29967dfd97f3f3d29342)

- Replace Hook Methods with Hook Attributes
    - Title() is replaced by the [Title] attribute that is placed on top of the class and takes a string to name the test
    - [Start(), Pre(), Post() and End() methods are now replaced by [Start], [Pre], [Post] and [End] Attributes that take the name of their respective methods](https://github.com/AlexDarigan/WAT/blob/main/tests/mono/AttributeYieldTest.cs)
- Replaced the [RunWith(args)] attribute with an overload of the [Test] attribute (so to run a test with arguments, you just pass them in to the Test() constructor)

Async Updates
- [You can await in any Test Method that uses a TestHook Attribute provided you declare it to return Task instead of void](https://github.com/AlexDarigan/WAT/blob/main/tests/mono/AttributeYieldTest.cs)
- [You can now await a standard Event (ie takes 1 sender and 1 EventArgs object) using the UntilEvent Method](https://github.com/AlexDarigan/WAT/blob/main/tests/mono/UntilEvent.cs)


