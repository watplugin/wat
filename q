[33mcommit e2ac990d3dcd2b97f2c3b730a9758a00e57c77e5[m[33m ([m[1;36mHEAD -> [m[1;32mDoubleRefactor[m[33m, [m[1;31morigin/DoubleRefactor[m[33m)[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jul 9 01:37:39 2019 +0100

    Solve Cache Memory Issue in doubler.object()
    
    When we instanced a doubled script after we changed its
    source code the second time, we wouldn't be receiving the
    updated script. This is because a copy (with outdated source
    code) existed in memory already. That cached copy is what Godot
    returned to us.
    
    We tried a few things. For example, freeing the objects from memory
    but there wasn't a clean way to do this with reference-counted objects
    mid-test because they could still be referenced as temporary variables
    within the users test methods.
    
    Instead, we added an internal counter in the doubler that counted
    how many object instances were created along with how many files existed
    in the temp folder at the time. It should be impossible for scripts to have common
    names.
    
    So far it seems to work.

[33mcommit be895c6946f9798ec4948ef27647a11512225e1a[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon Jul 8 15:20:54 2019 +0100

    Add a number of tests for updated doubler
    
    For some reason we can't overwrite function data like
    we've done before. We keep getting the real value, not null.

[33mcommit e988d205f6bbb1adcd5ada5f5cfc3e4898aa8e1e[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 21:49:18 2019 +0100

    Fix clear_temporary_files

[33mcommit c4a617dbbe6edd3c793e2d0adfdc421077e04f82[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 21:47:09 2019 +0100

    Scrap sourcecode based doubles.
    
    We will just have to stick with single
    based interactive doubles.

[33mcommit 6b80f98165b23ac75c93d54e4a133413c9111d52[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 18:24:47 2019 +0100

    Add InnerClass Loader method

[33mcommit 1aacb18b655320ba55b3be63f08de9fb86e38c1b[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 16:57:23 2019 +0100

    Add option to double from class_named script
    
    along with a test.

[33mcommit 3946f126639c07a18eaee3277bb07ae9dec6e787[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 15:09:35 2019 +0100

    TestDrive Double Method
    
    Added a number of test driven methods to build the
    double method. Currently stuck on an aesthetic ideal so
    commiting now with our last test incomplete to remind me where
    I am later.

[33mcommit 37b4826d7836decb95dc07101e451b545f0b8d8d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 14:28:39 2019 +0100

    One more file to delete

[33mcommit 898abb9a55fbdbaa6463f01b8da71601657e8d4d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jul 7 14:28:10 2019 +0100

    Deleted Files.
    
    Starting from a different point.

[33mcommit f30383f759fe52522a3be92e00c8974d3cac89a8[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jul 5 13:25:39 2019 +0100

    Add Reference to Double Data
    
    When we double a script, we add a reference to the resource
    doubling it which all of the methods will be passed through to
    start.

[33mcommit 2af2872beabcdd9a5426508bd2df51a710e36189[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jul 4 20:22:19 2019 +0100

    Move double initialization into new factory

[33mcommit 74de947df3949265499c08a4507b1192d5a539dc[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jul 3 17:45:41 2019 +0100

    Base Dummy Method Implemented

[33mcommit 6593ecf056e971d4b0f5af282d51b2a66e1e84a2[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jul 3 13:04:23 2019 +0100

    Remove unstashed cruft

[33mcommit ce21dd9ae7310d54149b560cbd844504d911e5c3[m[33m ([m[1;31morigin/master[m[33m, [m[1;31morigin/HEAD[m[33m, [m[1;31morigin/Bootstrap[m[33m, [m[1;32mmaster[m[33m)[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 23:28:36 2019 +0100

    Move more constructor logic to parent

[33mcommit db204a3b630590a25f608a781ecb278f3e637d7f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 23:22:49 2019 +0100

    Rejig UI-Runner-Wrapper Constructor Logic
    
    Runner now holds a constant link to Yielder instead
    of taking it in as data from the root script. This was just
    being tramped down to the TestWrapper class anyway.
    
    We also moved the add_child method on Yield from the test
    wrapper up to the Runner. We want parents to work as factories
    for dependencies to avoid having logic (however minimal) in
    the children's constructor

[33mcommit 38d7580fb301c30266540ed97073ef71bdb769a0[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 23:15:30 2019 +0100

    Add Unit Test for Watcher
    
    Not much we can do here. Spies seem more
    versatile over all.
    
    Also added a reworded with_arguments expectation methods.

[33mcommit 66a8daed902f3f64fad4a4bf4245711465eae8ba[m
Author: Darigan <code@darigan.ie>
Date:   Sat Jun 29 17:43:16 2019 +0100

    Rejig some images

[33mcommit 1da9d5ac017e18e9584597a494cfa08ea8baf805[m
Author: Darigan <code@darigan.ie>
Date:   Sat Jun 29 17:33:13 2019 +0100

    Add Unit Tests for testcase

[33mcommit 560bf5846bf00b1bbb5a1e9072d40569880a62df[m
Author: Darigan <code@darigan.ie>
Date:   Sat Jun 29 16:59:23 2019 +0100

    Move Loader into Doubler
    
    Doubler is the only thing that uses this, we can probably
    re-arrange it to make more sense as a pure doubler that
    occasionally calls into Godot's ResourceLoader.

[33mcommit fecdc0b472a126fbb30387decb062bff61912660[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 14:53:34 2019 +0100

    Added Default Context Names to each Expectation Object
    
    Users no longer need to add a context. Everything will default
    to the expectation method name, with an optional context. This
    allows for detailed trees but without being verbose if users stick
    to one assert per test style

[33mcommit a178bfb05071b7dd53ff01ac48c1191a19b32fbb[m
Author: Darigan <code@darigan.ie>
Date:   Sat Jun 29 04:13:21 2019 +0100

    Add queue free on WM Quit Request to avoid DB Instances issues.

[33mcommit d490534c4d08f797be3bd5ff6857981675bcdac3[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 03:20:09 2019 +0100

    Expect/Result now shown as stack children of expectation
    
    This is just easier to navigate than tooltips. We will
    also be adding a default info about which expectation
    was invokved too (so we don't end up with blank lines
    if no context)

[33mcommit 06fa8f1fbfc2c8b1c650121e9b1eba04b816f61f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 02:53:57 2019 +0100

    Rename context to describe
    
    Mainly to put it in line with the described signal.

[33mcommit bc52489bee8af161dce70a680b3dfd98b8094a73[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 00:54:46 2019 +0100

    Add Context option to methods
    
    Method name will be included in source. We're most concerned with the
    results display.

[33mcommit c41b4334b2e58055a346bd1786c76432583ba1e5[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 00:40:30 2019 +0100

    Readd Expand/Collapse all code for results.

[33mcommit ac823f0a07b7b16391c9a25b631926e7543defcd[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 29 00:20:23 2019 +0100

    Move Error Handling from Runner to Validate
    
    No reason for runner to be calling this directly.

[33mcommit 1b0cfd3afd13b1a1be0cdda60f571d4c12a3eb86[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 21:30:01 2019 +0100

    Number of Changes.
    
    We added our first initial proper boostrapping tests. This
    however came with some costs. Namely we had to reverse the decision to
    allow any script that extended from WATTest to be run. We should
    be able to trust people and typing systems with that issue anyway.
    
    We also mucked around a bit with our results display. Scripts
    are now collapsed by default. Methods are not, though you can choose
    to expand them to see a range of asserts that may or may not
    have context written on them.

[33mcommit 57ebaac33e914d6ec32fd2be2ef4bb25a2e0ddba[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 19:59:13 2019 +0100

    Clear Test Folder
    
    Prerequisite for following unit tests.

[33mcommit 006f7340e620e7d3c585fbe05cac320a27b9c0f7[m[33m ([m[1;31morigin/Context[m[33m)[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 18:50:33 2019 +0100

    Create a Test Wrapper
    
    This is a shell to manage the execution of the test script
    while letting us take off major pressure from our runner which
    was starting to get overloaded with stuff.

[33mcommit 850cd8c9af455e29309d4879ef1d7d3bf56a4889[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 17:55:10 2019 +0100

    Update Yielder
    
    Yielder is now timer that restarts with an internal
    counter to check how many more yields are being invoked.
    
    Once this counter reaches 0, we resume the methods.

[33mcommit 467c03e3242a99debab6d4eb10625d1febc5671d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 16:31:14 2019 +0100

    Move Resume/Post Signal to Runner
    
    This makes the connection a lot more explicit and prevents
    multiple (invalid) resumes

[33mcommit 644f1a587b205961cf57906521d89d2be0c647e9[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 15:38:31 2019 +0100

    Refactor Results Display
    
    Create an abstract method to handle most of the construction logic
    
    Doing this for individual tabs is just a matter of calling it in
    a outer loop.

[33mcommit 4dd664f88352ed47a85a02794c555941309d384c[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 15:20:29 2019 +0100

    Refactor ResultDisplay
    
    Added a post fix passed/total number on tabs
    Hidden Root (Unnecessary and there wasn't much information
    we had to show)

[33mcommit 1c6e4b1409a7a34507a57d72943a14ee2a4165b6[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 15:15:51 2019 +0100

    Pass in Settings Dependecy into Validator
    
    This used to be a const but we want to make sure
    our testing framework is designed for testing.

[33mcommit f15e80792e70a7741336ed9fd2ea105224657f56[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 04:07:42 2019 +0100

    Remove Const ICONs from Results Manager
    
    We built this into the results itself.

[33mcommit aecc9a54657e12a97a717ee73f44b7a01c942a38[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 04:01:35 2019 +0100

    Refactor Results Display
    
    Extracted out single-use methods for each
    logic block in a loop. Had to keep the tree item
    creation at the top level though.

[33mcommit f10a7f14ec9bef7e4e70f5d4b796f063fd9dd65d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 01:43:57 2019 +0100

    Remove Started Signal from Runner
    
    Results now gets called directly from the Runner via
    the passed in dependency. I'm starting to think that we
    should avoid signals for non UI related events, using DI
    where we can instead.

[33mcommit 989040eeffef5132dd09998fdc08546f5fc566bf[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 28 01:32:12 2019 +0100

    Refactor Results to use a stair loop.
    
    I've tried to justify writing this with
    helper methods but it just isn't worth it.
    
    It is a three stair loop but it is fairly clear what is
    going on.

[33mcommit fc4eb0847bb5cec331cbb3202237a36718f44150[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 22:43:41 2019 +0100

    Use get_base_dir() instead of custom method
    
    I'm an idiot.

[33mcommit 8c2450dfe021342d399b570919d782de726b710b[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 22:16:40 2019 +0100

    Passed in Settings as a Dependecy to Results.
    
    We had CONFIG set as a constant. Where we can we
    want to avoid this (outside of image assets) so we
    can test everything easier (or make alternative routes to
    them easier, like a command line interface)

[33mcommit 75576e6a004743e283592e14034941796f3db63c[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 22:13:12 2019 +0100

    Inject Results into Runner
    
    This is instead of using a signal to display it. Less we
    can rely on string based things, the better.

[33mcommit c13c3fb5c272c1fd406fd10abc082c5830f95d5d[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 21:56:31 2019 +0100

    Removed Output
    
    1 - Executing (Script/Method) & (Script/Method) (Passed/Failed)
    messages were redundant with the result tree
    
    2 - There wasn't enough data to justify a seperate output tab. Prefering
    print.
    
    3 - It added a ridicolous amount of time to our tests.

[33mcommit 256784ee752ac8f6d1ef3c5f4740d76a7fcc0480[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 19:25:58 2019 +0100

    Refactor Output
    
    Changed to a RichTextLabel from a TextEdit Label. We've also
    reduced a number of messages such as running test x, running
    method x because this is information that results already tells us.
    
    We also removed a Yield Message because our timer should make it
    clear that we are yielding, not having the tests hang.

[33mcommit 42ff1c3dd4a917d96a4578617a93d13b6b4fc5a0[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 17:32:02 2019 +0100

    Move Caselist data up to Runner
    
    There wasn't enough data to justify having a ManagerClass. It
    was primarily an array anyway.

[33mcommit 4bb87ecd173910be7a8dbbd649eff8d388b1895b[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 17:21:43 2019 +0100

    Refactor Case Manager
    
    We have refactor the three case types into
    essentially one type (technically two). Methods
    are dictionary representations. When an expectation
    is called, it passes itself directly into the method.expectations
    list otherwise we just end up duplicating for no reason.
    
    We still need to re-handle crashing and tidying up the result
    calls.

[33mcommit 0b1b337ea69c7b90718b3b705a7ef9e38c4879c1[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 13:37:25 2019 +0100

    Update ResultTree Display
    
    Context is now shown on tree while the details are shown
    as a tooltip. We might be able to add more info to the tooltips later.

[33mcommit f4c720dd01bea43ca4c4866971411ba23f953305[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 13:02:39 2019 +0100

    Push Construction of Runner up to WAT
    
    We can remove a lot of unnecessary consts (that get in the
    way of testing it) by pushing up the defaults to the top level of
    WAT and then pushing in their instances to the Runner constructor method
    which also clears more room for the runner's further refactor.

[33mcommit 5ea5cd6489c100555ae96790b8ee7ca21314224b[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 27 12:19:54 2019 +0100

    Fix Bug where Output showed 0 * 4000 times on start up

[33mcommit 4057b4adb9b7bceb61734257f4d43c07ccd469d1[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 27 03:14:33 2019 +0100

    Refactor of Yielder complete
    
    Long methods but mainly construction, so no major issue.

[33mcommit 28390441fa1c1e2c3aff90d5e42c04536a064adf[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 27 02:58:43 2019 +0100

    Remove YieldTimer Class
    
    Redundant Code.

[33mcommit 9ced45f8cd56a77c78783afbda8417ead8b91c42[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 27 02:51:34 2019 +0100

    Reduce Yield Timer Code
    
    This is as far as we can get before running into breaking issues.

[33mcommit 0a0780cc658a9a99527a7a03d81f8a74521e1333[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 23:46:45 2019 +0100

    Split IO into loader and filesystem
    
    Had two very explicit different operations and was just
    taking up each others space. Loader handles loading/saving with
    files specifically for doubles & filesystem simply retrieves files
    or clear directories.

[33mcommit e4e413552871ccd78cf5055408af92d4d0ebe3f7[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 18:51:30 2019 +0100

    Change back to using the Queue based yield system

[33mcommit 64cbef5fea8bcdf76c8bd2a43a387d10950d3ea6[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 18:30:36 2019 +0100

    Use new "current" property in Yielder

[33mcommit f5b05494ce2af292c42b3822fc7236506a654204[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 18:13:29 2019 +0100

    Move Output Method up a level
    
    The parent Yielding item is responsible for the message being output now
    by asking for the data from the timer which helps us avoid dependecies up
    the chain.

[33mcommit 4807e156af536987c97c32d30c726279cfd8d210[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 18:05:47 2019 +0100

    Refactor Yielder Code

[33mcommit 3758db948af060eaab0d1f01285dd1898371eb07[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 17:30:29 2019 +0100

    Remove Runner Scene.
    
    This was merged into the main scene a while ago.

[33mcommit e5f58f59843566ca361c1cdaeeb898d7020844f1[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 17:29:33 2019 +0100

    Reduce another method in options to a paramterized one

[33mcommit 95641e8b739ae245271f17ac478b27ceccf8c854[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 17:26:00 2019 +0100

    Reduce more code in Options
    
    Error handling reduced to a single method.

[33mcommit c4e0ae2fcc4ee143b7bf02ef0efe9e3d6a148a2f[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 17:06:12 2019 +0100

    Fix Bug where not all methods were being tested
    
    We were popping a method from methods, and then checking if
    it was empty instead of the other way around.

[33mcommit d4b715c7579b40337435c6d6c2ebc23502deb96f[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 16:35:16 2019 +0100

    Parameterize IO List method to search for functions OR directories

[33mcommit 06e0586dd960eff8486565f31b1496acdc06eaff[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 16:10:40 2019 +0100

    Refactor Options IO
    
    Clears out a lot of unnecessary code. Moves some
    heavy lifting to IO. IO itself needs some more love
    to help with repeated code.

[33mcommit 1803df093bf5338723bcb7f2dd698ef485c707dc[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 14:16:21 2019 +0100

    Move method_prefix_set bool to VALIDATE
    
    Not the 100% best place for it but it is a similair check
    to the rest and has more room for it there than in the runner.

[33mcommit ba63cd5ee9512a2db5dec267b5aed0c2c7126d38[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 14:13:09 2019 +0100

    Refactor execute method code
    
    Seperate the clause to get the next method name

[33mcommit 4dda3d540bbecf1f5cccada1a115b689683a5ee0[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 14:07:25 2019 +0100

    Refactor Extracting Clean Method Name

[33mcommit 638251cc16e8bb5d842a0039d1b5c4c9e3dd0d31[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 13:58:48 2019 +0100

    Rearrange Methods
    
    I don't know how to handle the error issue? Maybe I could
    try a seperate script for them?

[33mcommit 5b58cd9ca470ae41167d52a847073e3f87289f04[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 13:48:36 2019 +0100

    Change var validate to const VALIDATE

[33mcommit d006ab2e2f91d5bc16655d04e5f32de69c55781c[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 26 12:16:54 2019 +0100

    Create Validator Script
    
    This helps us make sure our files are tests and also
    gets the proper test methods. Might be worth bringing some
    errors down here too.

[33mcommit f7c12e1d94f23306a71c7688005d035e988f301d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 03:12:05 2019 +0100

    Refactor Old IO into new IO Script

[33mcommit 7d6eb3f856dad586b209be66a2d131253370782f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 02:05:32 2019 +0100

    Refactor clear_temporary_directories method

[33mcommit 39188dc14391b8c19a8506d802116ff031ff8b70[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 01:34:26 2019 +0100

    Merge Collect Script into Runner
    
    We no longer have a need for collect script since it
    was repeating quite a bit of directory related code. So we've
    merged it into the runner script.

[33mcommit 7fe1c8a736edbd586ca31bb1bbec739d4e9c19ad[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 01:31:14 2019 +0100

    Create collect_tests method in Runner

[33mcommit c5137e6aaa512336f44d3ccd13ec3e360c57b933[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 26 01:08:23 2019 +0100

    Added file_list method to IO.
    
    A lot of methods scattered around should become redundant
    with this change. Scripts even.

[33mcommit aecbb2a931ce809a99e61b9e759b467b91b287a7[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:37:23 2019 +0100

    Create seperate error method

[33mcommit d32d9ec0931ba17ac64ee094dc4ce4df14758de8[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:32:43 2019 +0100

    Remove extraneous checks.

[33mcommit 06953faac6b33f0a5a9a7dbaa4653cbcbf6ad7e9[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:30:34 2019 +0100

    Merge UI scene into main WAT scene

[33mcommit f96cafdf386cf4e89e7880edb3a79df82211047a[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:26:51 2019 +0100

    Remove strip_edges
    
    This was overwriting the newlines we were adding (oops)

[33mcommit 9a6bc886398df95ce5f8df3a17395b7a60e639e9[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:16:17 2019 +0100

    Remove extraneous print statements

[33mcommit b0e5b1c46a9c8d96a4dfb9e26fc43d490453098b[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:15:17 2019 +0100

    Collapse test method to test constructor

[33mcommit 237990a95f725a774737418635cebbe01b62da57[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 15:08:12 2019 +0100

    Abstract add_result method in result_tree script

[33mcommit 15a7c85f77b2c2c0282543b2f53e63ca27d4633f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Tue Jun 25 14:40:50 2019 +0100

    Add Tests for WAT Rewriter
    
    Only a few tests but a start is a start.

[33mcommit 82e40fa51b11f39ff9d243046c794e370696a774[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon Jun 24 18:10:14 2019 +0100

    Rework expectation methods to use new context values.

[33mcommit fe0f09bc9ef2888f5be7ea181c8276774beb2ab0[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon Jun 24 00:23:05 2019 +0100

    Add New Screenshot

[33mcommit 21eca337eeca2ef3e67bbabaa037dd7d1d04be2c[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 20:23:50 2019 +0100

    Update Screenshots

[33mcommit 60cf2d221c205eea484882ca817c9f93603f581f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 18:48:53 2019 +0100

    Add Inlined Data for Expectation Methods

[33mcommit b6e5594f4fcd6fbdf66c4a6d68a41cf86f512d33[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 17:52:37 2019 +0100

    Fix Typo

[33mcommit 66bee063387b41facd8e9212ee40c327faaf8ef7[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 17:49:50 2019 +0100

    Fix Dir Loading Error
    
    Will have to refactor a lot of this to keep it consistent.

[33mcommit 8435450acef53fed0454b345486fd2e1e9ca1011[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 17:45:01 2019 +0100

    Add Print Stray Nodes

[33mcommit f53a5c96cb3ec01bb23f1c163b5e14db7e0576e2[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 17:32:49 2019 +0100

    Add Timer to single run buttons (not just run all)

[33mcommit 78fe08f97bddd9728586ecd1e55ac86eeecbb362[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 17:26:33 2019 +0100

    Add individual expectation methods for each built in type

[33mcommit d9e385ae590969a7082726b27c676d8cbb58cbd1[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 15:37:24 2019 +0100

    Add base elapsed timer
    
    Not 100% approx. Give about +2/-2 seconds.

[33mcommit 0ff31d0d1f1ecafd3d9bef7930968a75a2fecb11[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sun Jun 23 14:20:26 2019 +0100

    Tests can now use inline data

[33mcommit 5d21e15d96d59b79b30d5085271336980310b470[m[33m ([m[1;31morigin/Tabbed[m[33m, [m[1;31morigin/ParameterTests[m[33m)[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 21:47:52 2019 +0100

    Update Success/Fail/WarningCrash icons

[33mcommit 301c1cb223c0b341274a2c8619437b07a89062cd[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 13:48:52 2019 +0100

    Fix some typos

[33mcommit 26ba4f1dcc300bdcb133fe01ef1f848b39785556[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 13:23:20 2019 +0100

    Can crash tests on failure (if used during start)
    
    Not sure if I should include it for pre?

[33mcommit 1a841538946787855f659519e77ce430c2d0e155[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 12:46:33 2019 +0100

    Users can now add messages from tests to the output panel

[33mcommit f0c19653b10806e148c879a24e2f9fa3b0e55af1[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 12:38:21 2019 +0100

    Add is(not) freed expectation and related tests

[33mcommit ff9aec1d4bfacfa0b77c70a64c58da8aaeb6c43c[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 12:18:57 2019 +0100

    Remove display pass/fail tests from settings

[33mcommit 0867d98a3f9b8685c9f9d682ded4a37bf90710cf[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 03:37:50 2019 +0100

    Add main_test_folder where necessary

[33mcommit 5ee200caabf84d8a6f50c441896b41113ae831fd[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 03:22:12 2019 +0100

    Remove most print debug statements

[33mcommit ab2ec4959f21a8c751c7b06fff533c002b4ee5f2[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 03:14:27 2019 +0100

    Invert a boolean condition to make last commit work

[33mcommit edea68849a95e80df184608a142a275385f29916[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 03:10:03 2019 +0100

    Add a check to make sure the main test folder is set.

[33mcommit 9e8bd83cdefdee51ef7099709300fd8e5fd2bb41[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 03:02:55 2019 +0100

    Add default_strategy method in doubler
    
    Reads the settings in the script and then returnss an answer based
    on it

[33mcommit 20752f89e2dcc9dd3a545ffc4da1aba3bf679010[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 02:50:20 2019 +0100

    Fix Bug where OS.Alert would pop up for every method being checked
    
    We implemented a check to make sure we had a proper prefix for test
    methods (otherwise we end up trying to run EVERY method as a test method)
    but we did this in every check. We moved it up to the run function in Runner
    instead

[33mcommit d5a2493c90de92b166e804e4f9abb8e4a12589a0[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 02:31:27 2019 +0100

    Can now set prefixes for test methods.
    
    May want to add an invalidated method to this otherwise
    a bunch of non-run tests look liek failures.

[33mcommit 0384606864d19d52421bbcc08581ff93fbb51c4b[m
Author: CodeDarigan <code@darigan.ie>
Date:   Sat Jun 22 02:22:11 2019 +0100

    Test Scripts can now be seperated from prefixes

[33mcommit 201a9d2709652d07ccab4ed1d2ae503d2d4f4b0a[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 21 22:30:38 2019 +0100

    Add Success/Fail Icons to Test Tabs

[33mcommit 85d636d1b765bdd219a844c013cd63dd83f74fa6[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 21 21:15:36 2019 +0100

    Include a fail safe in case we add an empty test

[33mcommit 1088114b27ca5e84bec6d23b67add7567255732f[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri Jun 21 21:09:08 2019 +0100

    Option Buttons now set Menus once at Initialize
    
    With an inital set, we can avoid the weird popup effect.
    
    Note: There is also a bug where run all tests doesn't include
    subdirs if a test exists in the top level.

[33mcommit 6610bd581dbfd8acbc5ecf896381297619a6b51a[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 22:30:14 2019 +0100

    Add More Run Options

[33mcommit b2392d11556c1d2dc08d6296b790daa087b81329[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 21:58:36 2019 +0100

    Can Run Single Directories

[33mcommit 2029b0ca3818f62b207999055ce42ba1720d7c95[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 20:59:07 2019 +0100

    Add ability to Expand/Collapse Tests

[33mcommit a02802b3b726d69bfcde932fa6de8ab66f5668cc[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 20:30:15 2019 +0100

    Add Clear Output Signals.

[33mcommit 1f37d26ab6eba6123070a436090f4586757a65d3[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 18:41:49 2019 +0100

    Remove old files

[33mcommit 458a51abd54ff45839366c789685c22f5355ca40[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 17:19:41 2019 +0100

    Remove xxx.tscn

[33mcommit dc3a376e69fdf4fd3245cf2cb3bce1732f624ea0[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 17:15:54 2019 +0100

    Test Folders can now show up as seperate tabs

[33mcommit b272550d84260ef662fbf3ccca2a36c5c69961c9[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 16:05:02 2019 +0100

    Tree now displays results of all tests

[33mcommit b889cd4fc1ac63f6b2cd5d32702d39aee7339216[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Jun 20 15:52:55 2019 +0100

    Update Output
    
    We can now run tests, display the output in the output area
    and have syntax highlighting.

[33mcommit 2b7b60a3a201f348023c05ff7c529be729fe0499[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 20 14:32:26 2019 +0100

    Add Ability to Run Tests (Basic)

[33mcommit cc1f111417bae52d85508ed8ebae4e108ef62c12[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 20 14:00:35 2019 +0100

    Reupdate UI

[33mcommit a1186ff9881ed04d6f357c1b35de4ec5dfa83d54[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 20 12:50:07 2019 +0100

    Create New UI
    
    This will help streamline a lot of things in future.

[33mcommit 115d3b599446b6ad9eec2ff1f6bc54023152f0e0[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 20 11:18:06 2019 +0100

    Add Signal_was_emitted_with_arguments & bootstrap tests
    
    Adds another expectation method. We also re-arranged the folders into
    bootstrap which checks the success of methods, and exercise which contains
    intentionally failing tests.

[33mcommit c8c8858184b0255935cf8a0b4a8a56adfcf57021[m
Author: CodeDarigan <code@darigan.ie>
Date:   Wed Jun 19 20:02:43 2019 +0100

    Add test prefix to bootstrap

[33mcommit 459965709ee4adc3a304840795c340c15c9f8384[m
Author: Darigan <code@darigan.ie>
Date:   Wed Jun 19 12:19:29 2019 +0100

    Finish BootStrap Tests for Base Expectations
    
    There is still a lot of other expectation methods we
    need to test but the generic non-special ones are fall
    finished (at least for the ones that exist now)

[33mcommit cab7daaf99941439855a1f71965af5d0ea3c4b69[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 18 18:45:45 2019 +0100

    Bootstrap All BASIC Test Passing Here
    
    Basic mean nothing to do with doubles or signals at the moment.
    We also don't have the failing counterpart involved either.

[33mcommit 4070f3846faa1bd5a98d223c4aa46eff46175049[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 18 15:23:22 2019 +0100

    Add some basic bootstrap tests
    
    There is a lot to rewrite here so might be a while to
    clear them up but everything is in place to finish them
    easily.

[33mcommit a000bd1a2daf53c3021e8e2d33404b9c506bce18[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 18 14:57:09 2019 +0100

    Add Script of Consts to Expectation Methods.
    
    This was mainly to make bootstrap tests easier on
    me later.

[33mcommit 1ac97a16652442448106f2740bf73ba186caaea2[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 18 13:45:15 2019 +0100

    Refactor Rewriter
    
    We added a template object using formatted string content, set
    those values, and then use a getter to return the updated version.
    
    This makes it hell a lot more legible than the last version.

[33mcommit e8a505ab66918f1a4c77f2b7150a89ad48345bb9[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 22:02:45 2019 +0100

    Remove error messages
    
    These aren't handled well and we would be better served by one
    large focus on error handing at one point.

[33mcommit a6a9743c02217ff1374228aee0f5af0bf3fd3e7e[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 17:53:36 2019 +0100

    Fix Bug not clearing output/results after "_run_script"

[33mcommit fd26ddbd202b9503feb4786c29edf3349c3ca53e[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 17:41:41 2019 +0100

    Added Double Strategy
    
    You can now use DOUBLE.PARTIAL when doubling scripts to keep all of
    the methods intact and then choose which ones you want to double or
    stub

[33mcommit 1a3becc234dc0f285c008514c4c5da926d6df4cc[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 17:13:28 2019 +0100

    Double Strategy added to Double Objects.
    
    The last piece in the puzzle. When doubles get stubbed or defaulted,
    the lose their partial super calls.

[33mcommit c8743c4fea2708a34512d08c7b44281812fa9a1a[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 16:58:36 2019 +0100

    Update Rewriter Method Template for Double Strategy
    
    We add a check inside the double scripts to check if they
    are doubled or not. We need to implement the act of the strategy
    itself next

[33mcommit bde8332527e28cf410ec0955fc6fffff305360e4[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 16:33:26 2019 +0100

    Add ReturnValue checks in tokenizer
    
    This adds a check to see if a function returns a value (regardless
    of wheter it has a typed value or not) and then adds that as a boolean
    to the method dictionary.
    
    This will be used later for double strategies.

[33mcommit a88af85485a3be10e68a3023333ac73be69e7afe[m
Merge: f12ccc5 12e0b3a
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 15:56:12 2019 +0100

    Merge branch 'master' of https://github.com/CodeDarigan/WAT

[33mcommit f12ccc50d14623306b0d4203b537372e800fbd66[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 17 15:55:21 2019 +0100

    Add File Exists/File Does Not Exist Expectation
    
    Been a while coming this one.

[33mcommit 12e0b3a54313a203003019af925e13b8f35c2cd9[m
Author: Darigan <code@darigan.ie>
Date:   Thu Jun 13 13:19:36 2019 +0100

    Add Junk Params to until_signal on Watcher
    
    This causes an error if signals are called with args, so we
    have to fill it with a bunch of junk parameters.

[33mcommit f54f0e0590f8ea4a3054a0a2198a272af6ab4651[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 10 15:39:27 2019 +0100

    Use New Expectations Script
    
    Holy Shit. I forgot to remove the old expectation methods code
    which means I was getting way too many false positives.

[33mcommit 8cb63db85424c6ef3a4eea499b0b4171764cbaa8[m
Author: Darigan <code@darigan.ie>
Date:   Mon Jun 10 15:22:50 2019 +0100

    Inline Expectation Consts
    
    We only use these strings once, so the consts seem
    redundant, unnecessary and just taking up space.

[33mcommit 5b0789c4be1321fcaeff347c7638d6d653936ed8[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 17:13:49 2019 +0100

    Finish Refactoring Runner

[33mcommit a06ff6cda3ed8f75b6e1136890105bcc6317ad4d[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 17:02:39 2019 +0100

    X

[33mcommit fde1782f48e83dd632e5f12cdff50070e3f982c4[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 16:20:46 2019 +0100

    Save State
    
    We may be running into yield issues. Therefore saving state here.

[33mcommit eaef64defbb5a965cbf628c89a44217757d82165[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 15:24:27 2019 +0100

    Add _pre method

[33mcommit e35335738d22c4e5e21d55e576d2d0eb1b1022c9[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 15:11:30 2019 +0100

    Rename execute to _start
    
    See previous commit message.

[33mcommit dd4ac42b79d4922ba9236295231b672fca412688[m
Author: Darigan <code@darigan.ie>
Date:   Sun Jun 9 15:09:17 2019 +0100

    Rename "_start" to _run_all
    
    We are refactoring our runner to represent a test script strucutre,
    so _start essentially means start in the test script

[33mcommit bbb93db3249213d2f662da8f3c5b417e15676a33[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 18:13:02 2019 +0100

    Remove cruft image

[33mcommit 2d371fc042b5882a6f3ed4565e0cc2b62b98627c[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 18:11:20 2019 +0100

    Add Type2Str conversions for display

[33mcommit c2893c11c509feb83468f1fd0cffc60a84455df6[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 17:44:12 2019 +0100

    Fix Cruft

[33mcommit 3e2a21ccc8e99188f9b542fe0e55a86be4c38522[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 17:25:22 2019 +0100

    Collapse Runner Functions into one big function
    
    Ironically, we have much less code now. It seems we got lost
    in layers of abstraction to the point of nonsense. We still have to
    clean it up but this is a good start.

[33mcommit 3431c69e9646434e674759450f6c1a9ff77f6b51[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 13:56:09 2019 +0100

    Improve Watcher
    
    Watcher is now set as the meta value of the emitter, not of the test
    object. This allows us to remove more information from the base test
    script.

[33mcommit 069fe877f4589907bc6313604152893535fc54bc[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 13:25:56 2019 +0100

    Fix Cruft
    
    Godot doesn't play too well with VCS. Had to remove a random line I was
    using for a test

[33mcommit ffab056f3cd8720998b2d9ebea147e066bee3c3b[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 13:11:57 2019 +0100

    Revert API Incompatiable Change in Doubles.
    
    We had made changes to automatically free doubles. This
    broke compatability. Instead we now require them to be freed
    manually in fixtures (via double.instance.free())

[33mcommit c83c332e181751b1c93106f87e4d1d0c464fdd2d[m
Author: Darigan <code@darigan.ie>
Date:   Tue Jun 4 13:06:27 2019 +0100

    Remove Godot Cruft

[33mcommit bfeb4c48dd565e05d097817e2df4bba231ef12a0[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 29 12:46:46 2019 +0100

    Finish Refactoring Current Expectation Methods into Objects

[33mcommit 4cb44607686e0ab0c9bbf1d7d0671b24cf573347[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 29 12:20:32 2019 +0100

    Refactor Signal Expectation Methods into Objects

[33mcommit 7a9ba9cd63f85d2178cda14f0201d88042d18288[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 29 11:54:34 2019 +0100

    Add Basic Double Tests

[33mcommit 21322c2d2b11aa6c66b424dbe99ed642a2408ce7[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 29 11:42:22 2019 +0100

    Refactor Script Double Expectations

[33mcommit 480b84cd36a724bdd5f1be1f9af23e8f1ebcd493[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 29 11:20:24 2019 +0100

    Refactor String Expectations Methods into Objects

[33mcommit 75f412a374e09fc01d4569a57325cc443cce4597[m
Author: Darigan <code@darigan.ie>
Date:   Tue May 28 20:28:20 2019 +0100

    Refactor in/not in range expectation objects

[33mcommit 64e09709bfb2e4b79146a95f20da04e8542ff992[m
Author: Darigan <code@darigan.ie>
Date:   Tue May 28 19:06:01 2019 +0100

    BaseExpectation is now Reference Type.
    
    So we don't have to care about manually freeing it.

[33mcommit c8ae805daf8a028e35ae0953545bbd10b21a218a[m
Author: Darigan <code@darigan.ie>
Date:   Tue May 28 19:03:19 2019 +0100

    Refactor a number of stress tests

[33mcommit 2049f9524481e528473763fa7bca39681eb9b732[m
Author: Darigan <code@darigan.ie>
Date:   Tue May 28 14:58:29 2019 +0100

    Refactor is_not_equal, is_equal, is_false expectation objects.
    
    Note: We need to re-add typing to this. However we can update it
    with proper icons most likely too.

[33mcommit bfc9b45df409007645cf87f7ae3237f240ccc5ed[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 27 11:26:46 2019 +0100

    Add a number of empty implementations

[33mcommit 58a49d2dc8dfb64ef6cdf978887f946a29cd76bd[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 27 10:55:57 2019 +0100

    Start Refactoring Expectations into Obejcts
    
    We're creating a factory system so we can create the objects
    themselves (for the sake of testing them against something like GUT)

[33mcommit f28fc85afa2ac6820ba7a88766e7262c833811e5[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 20:15:48 2019 +0100

    test_strings_methods.gd now extends from WATTest

[33mcommit 092c4f5e1a33b7ed013952262adb7c88a7cae192[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 18:39:55 2019 +0100

    Modify Base Tests
    
    Collections aren't equivelant in operations. Therefore we want
    to make new expectation methods to handle them. We will
    probably end up expanding our expectations into seperate classes
    based on type with the primary script passed in as a default.

[33mcommit 46860b372057915428fe8eaa7d554ae56548fdb8[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 16:18:08 2019 +0100

    Add a number of passing tests
    
    There is a lot of tests so can't realistically
    add them all at once, so woohoo for branches

[33mcommit 643125d08688ca2b8559981494627efcb881f6be[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 15:19:18 2019 +0100

    Remove old tests

[33mcommit a9f827fc77b2795b67b1330e45028ee9d1a48d4c[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri May 24 15:12:56 2019 +0100

    Remove Capatalization

[33mcommit bf9db131ff8c1ba80f9673b3152536ceb9453e70[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri May 24 15:12:12 2019 +0100

    Remove capatalization

[33mcommit 3fcddcc75a01d65dcd4320ee5d57b18cd57657ff[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 15:04:42 2019 +0100

    Fix Memory Leak on Exit
    
    Case and Collect were still nodes but no longer in the tree, so
    they weren't being freed properly. We have changed them to reference
    and no errors on godot exit.

[33mcommit 3f0bf73a3377c346d66befe1dddc3f50af5bc3fd[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 14:43:54 2019 +0100

    Cache totals/successes of case objects
    
    We couldn't do a cache of successes for the main object
    in a clear way though, so we stuck with the function

[33mcommit c67ba1332481d6bb9d6bfc7308e1de29dfc4db99[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 14:16:44 2019 +0100

    Push down string case details to Cases
    
    Do most of conversion work via the caser itself, then get the
    result and output it from there.

[33mcommit 9ce9283c1af341bd7e6bbca68a209207e684d23e[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 14:00:59 2019 +0100

    Refactor Collector to a Static Script
    
    Plus fixed some capatalziation on cases.
    
    We'll probably want to bundle this into IO at some point.

[33mcommit 15c4ff21fb6004227fc5375e4b0958d142e6a22e[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 13:56:24 2019 +0100

    Refactor CaseManager Node to Cases Script.
    
    No reason to use it as a node when it is a simple
    data structure that doesn't need tree access.

[33mcommit c10e0711cad3956f80e9e69dd0e5ca5f9403d785[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 13:51:26 2019 +0100

    Remove unused variables from WATTest

[33mcommit 6d10e221130f87a474b2ebd2b47fa4362c98fc3b[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 13:49:36 2019 +0100

    Refactor CaseManager to handle case completely

[33mcommit e61bbd921d42c7fe43d133c9072b26d871ee3d8f[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 10:38:04 2019 +0100

    Rename Tests to working state

[33mcommit 2c614ad9f0e7666b0b494c97175ba58ebac9cfef[m
Author: CodeDarigan <code@darigan.ie>
Date:   Fri May 24 10:36:47 2019 +0100

    Uncapatalize blank.gd
    
    Hopefully for the last goddamn time.

[33mcommit e0ceba6120cfe886c974b846f6886edc8a163c0a[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 00:17:08 2019 +0100

    Add a Warning for an empty set of tests

[33mcommit 1b438a56e6a0eae75ce00d23b559beeb36f98158[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 00:10:35 2019 +0100

    Add Warning with early exit on incorrect script select
    
    People renamed scripts and tried to run them (apparently breaking
    godot on them). So I add a check to see if it existed which alerts
    the user and exit returns

[33mcommit c79f87dea8161795d7dcc81f717ef0a6a7c74702[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 24 00:02:07 2019 +0100

    Fix Method Cases used as Inputs instead of TreeItems
    
    This was breaking the expand all/collapse all function

[33mcommit 1db145c345fd06b87fff58e4a94a935647f90088[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 23 23:54:02 2019 +0100

    Add Expand/Collapse Results All Button
    
    Methods can now open all cases + all methods at once or close them.

[33mcommit aed9464ef390488ab70a2733af284732cc0e0911[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 23 23:39:57 2019 +0100

    Fix DefaultSettings not Updating Display
    
    Forgot a method call

[33mcommit 8270ec137b9e7e21f31c91003adac400197d6254[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 23 23:34:34 2019 +0100

    Add NOT_IN const string to Operators

[33mcommit 1cd667d4b4c60801ef657ba6eea80f5b62eca9a0[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 22 10:32:54 2019 +0100

    Fix issues

[33mcommit a573911ab7692b3d557daf821bd2e2ff4c9188d6[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 18:00:52 2019 +0100

    Update README.md

[33mcommit e56d1ad42da3b41b5472aff5e93d0c376386ccdd[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 17:55:25 2019 +0100

    Add YT Link

[33mcommit bada2cdc81b2add6499381e49a80d04288cca476[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 17:53:44 2019 +0100

    Update README.md

[33mcommit d0952eb6dd7fce8cbfe4128149635074c8f0c2b4[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 17:52:45 2019 +0100

    Update README.md

[33mcommit 3965650fb75f559d67af93749fe835ac80e8b745[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 17:52:22 2019 +0100

    Update README.md

[33mcommit 060fdf3ea35c5c3e0c03a66e373a2c76c426d618[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 20 16:11:01 2019 +0100

    move LICENSE to WAT Folder

[33mcommit 967ff31071f48605fb395983016fc8cdcedeb740[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 15:49:44 2019 +0100

    Create README.md

[33mcommit eca98ca1e1c9d22747fa9243302d40d769f351e2[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 15:49:25 2019 +0100

    Delete readme.md

[33mcommit 283f830f0a2b300e7403371c3cecdae6aaedb28d[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 15:48:37 2019 +0100

    Delete README.md

[33mcommit d544fd423a93701a86b0750d54b669de958618c5[m
Author: CodeDarigan <code@darigan.ie>
Date:   Mon May 20 15:47:39 2019 +0100

    Create readme.md

[33mcommit 44e4f57bb6f0b19ab06af8b6a2d4b1d5cd6b5895[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 20 14:08:43 2019 +0100

    stable

[33mcommit 3f8eac984d297cb6b89a1d1c73786fde5572b466[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 20 13:11:04 2019 +0100

    Update Main Pic

[33mcommit e75d07cb7d5140e44fbcd3765fc86abd46b0f9a3[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 20 13:05:33 2019 +0100

    Add is(not) builtin methods
    
    We also had to modify our stringify functions so we wouldn't always return
    an int.

[33mcommit 340ae03a1b4bf61ee14abf84d6e91542b6fdfb01[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 20:04:00 2019 +0100

    Tests with totals <= 0 are shown as failed

[33mcommit 96022efbf6b3199f753c0aefe4728e4169189c59[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 17:24:56 2019 +0100

    Implement Single Script Runner
    
    *This doesn't validate if it is a valid script but
    we can fix that later

[33mcommit 8ffdbafbbf575fa5a0325eb71ba2a30b111fb41a[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 16:49:26 2019 +0100

    Improve Logger
    
    Displays all levels (expect, method and script) with pass/fail
    colors. We will implement a level change to log them properly.
    
    Number of color keywords added.
    
    We have also made sure that the text edit is modified before the
    results show up.

[33mcommit 85788b20e6c484c644e303ed9b1b914534d7a46b[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:25:35 2019 +0100

    Change Layout.tscn to UI.tscn

[33mcommit 60ca8e70e6f0eabf085455ec4ee4e688b42835aa[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:23:36 2019 +0100

    Move Runner scene into its own folder

[33mcommit 6cfa51298af154c752d2ae1911562ef62a7d75ba[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:21:40 2019 +0100

    Move WAT main scene to top level

[33mcommit 82ea96ffdddd214641d7f4f4948e6d938a53b741[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:20:39 2019 +0100

    Rename Main Scene to WAT.tscn

[33mcommit 93b1d238d7877bfd78f261bbb2d210d80661552e[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:17:16 2019 +0100

    Rearrange double folder

[33mcommit dc2822f4f419da76cef4a86ec1b5fd0ea4bbdf2c[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:12:53 2019 +0100

    Rename Layout to UI

[33mcommit 91c56f3ca3307167ed8d0bc685e03de7451bd9e7[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:07:56 2019 +0100

    Save Runner as its own scene

[33mcommit 16240ff7dd0e84ecebca3dc08832095245381ec2[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:07:12 2019 +0100

    Save Layout as own scene

[33mcommit 530372117feaf66040a3d51b322c7dd11b04fd02[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:06:17 2019 +0100

    Move WATConfig into utils

[33mcommit 79a960a04c168339bfa5fca29b9dc837126ecc8d[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 14:05:10 2019 +0100

    Move IO into Utils folder

[33mcommit d5cee6971799137232e863e77aa1993274d73b4d[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 03:27:00 2019 +0100

    Move test/method collecting into its own node

[33mcommit c1b907ea53a379ae16f741774166871858a3fb5d[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 01:26:11 2019 +0100

    Add Typing in runner.gd

[33mcommit e726139a19045d66c5999f59992eba80ff284648[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 01:22:10 2019 +0100

    Move Outputs to more relevant areas.
    
    Reducing what we can for the runner.

[33mcommit 0eae937cce5bb4f6d0261d95862be2cf532b07b4[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 00:56:48 2019 +0100

    Add "finish" method

[33mcommit 420470451cca29fe36b1e8a3386840b8da6e2ff7[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 00:55:24 2019 +0100

    Add "end" method

[33mcommit ca3495ab9b75fecc5adcdfa31cdc1b7414470a8e[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 00:52:48 2019 +0100

    Abstract Start Method

[33mcommit ce0994eec2bdc75b19dbab345e99042560836109[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 19 00:47:14 2019 +0100

    Unabstract runner.gd methods
    
    This is prep for future refactoring. We're collapsing it
    before expanding it out into a clearer abstraction.
    
    We've also moved away from using a rather pointless cursor method
    to pop_front of collected test script/methods.

[33mcommit 5208c995901fa8a415a86c01f87938a43e1a30c3[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 23:01:49 2019 +0100

    Fix Memory Leak in Examples
    
    Missed simple inits here and almost gave me a heart attack. Memory is contained
    completely now.

[33mcommit b98dca24d3a07391b1ab219e8a9e920815d0cef1[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 22:54:23 2019 +0100

    Remove Memory Leaks.
    
    This was EVERYWHERE in the project. My bad for not looking at it sooner.
    
    We've added a print stray nodes button for quick debugging and the only
    stray nodes that exist are ones by the editor ourselves that we can't do
    anything about but doesn't interrupt anything else (or give us the classic
    error on exit).

[33mcommit c949208ba4e4f894cde68c143cdf69b7eca5243f[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 20:25:53 2019 +0100

    Working on memory management. Changing computers

[33mcommit d89d19341d25c02d0fab9e5a688ea903ceae50ce[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 17:09:21 2019 +0100

    Change cursor to use back() instead

[33mcommit 02cf326d6dc5648fec6d75305fe89ce405532998[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 15:36:39 2019 +0100

    Refactor Results Display
    
    Moved most of our totalling logic into the case objects themselves,
    so now we just have a simple enough for loop to handle display. It
    is three indentation levels but its not complicated enough to justify
    abstraction

[33mcommit 2a78e89005735d6714a800d1bc83818fb9f9acd8[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 14:51:17 2019 +0100

    add clean method func

[33mcommit ea135ca6a3c60ad1ebd526408e280cc6cbab1588[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 14:45:04 2019 +0100

    Add Case to CaseList on Construction
    
    Reduces some redundant code

[33mcommit 9967a4d09a5395ab59e4565ee68479dbb50faa97[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 14:26:45 2019 +0100

    Create CaseMananger
    
    Moved Case Construction to here. Move more logic soon too.

[33mcommit 00ae8de108ba97a22a4a48835ba5ae5c7b21433c[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 13:26:52 2019 +0100

    Refactor Yielder
    
    We moved the Yielder as a Child of the Runner. This allowed us
    to move a lot of the logic out of the runner for a cleaner (but
    still not clean enough) system.

[33mcommit 5ed489354a9cf5401039a274d7b0acaee447c6a4[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 12:37:44 2019 +0100

    Reduced three branchs to single if/else

[33mcommit f14be756e8b13d69dfbf4b9e8db799983e572c8e[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 12:08:40 2019 +0100

    Refactor If Branch into simple ternary

[33mcommit d37ff8e54afe52225391547523f2ab5899a081df[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 12:04:40 2019 +0100

    Refactor Rewriter Return Value
    
    To make the branching clearer mainly. I still think this could be better.
    Maybe inverse it?

[33mcommit 7831a53e51a1f57efbfa47827543ee72ed148157[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 11:52:24 2019 +0100

    Move Rewriter Logic to Tokenizer
    
    Strip_edges is a godsend.

[33mcommit 5d6ce2e198cc0eb175ffd74de8eccb38ea2d2486[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 00:56:04 2019 +0100

    Fix Void Error Properly
    
    Random non printable chars (probably created through conversion methods)
    removed with strip edges. Can now handle both void and ignore void settings.
    No errors.

[33mcommit 09d8e0aab8b7b615a194c529a66598107d689d09[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 00:43:42 2019 +0100

    Used strip edges to fix odd chars

[33mcommit 0604e0aa49d830690c207a06318349af358a0dc1[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 18 00:05:30 2019 +0100

    Fixed (?) Void Error in doubles
    
    I wrote and unwrote dedent a lot and now I'm not running into any issues at all.
    
    Not only that but bool no longer has a random newline between it and :

[33mcommit f331fb76480d9f8d729824d7e3ba6b072a6dcfb1[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 16:50:23 2019 +0100

    Improve Name Display Methods
    
    Had to mod these to handle additional prefixes, they're in a rough
    messy state at the moment but they do work.

[33mcommit eaf49a0d78718e5fd1f1c06716e1483d1bc70039[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 16:37:35 2019 +0100

    Expand on Config Settings

[33mcommit e364b9732d1b0dbb2de0c1ce0d54f2beeed8aca3[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 14:29:13 2019 +0100

    Expand WATconfig.gd
    
    No functionality yet. Still require a method to set defaults
    (and a method to accurately fix the UI if we already had wat values
    predefined).

[33mcommit 218a17815d8df62ef04ebc240f64089b552ea5ae[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 14:16:33 2019 +0100

    Start Config
    
    Not much yet but a start nontheless

[33mcommit e536a744303d54f8ef6ea6d728010a0dcdcac5bc[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 13:36:15 2019 +0100

    housekeeping

[33mcommit f46562003fbdb5617a88407ae954b23b968db6f4[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 13:07:07 2019 +0100

    Implement Queues for Results and Output Display

[33mcommit 4ee6aef793bab4a54bed9000c7fd2f094d762231[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 12:10:27 2019 +0100

    Refactor Double/IO
    
    Much cleaner now and still works.

[33mcommit 7f32e09bc5e07aca901962132fa83da1a9f9572e[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 17 11:48:54 2019 +0100

    Quick fix for IO
    
    A lot of junk left here but it works for the time being.

[33mcommit f7e7ea31d825e7cbe8e91348a040125f575c075e[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 16 23:46:34 2019 +0100

    Add _count() method
    
    This is used to generate a new number based on the contents of the temp
    directory, that number is then added to a doubled file name to help differentiate it
    between similariy named files.

[33mcommit 44f7a1ad156411234cf34054bea6df71abc4dfad[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 16 18:18:55 2019 +0100

    Finish Doubling***
    
    Scene Doubling now successfully doubles nested scenes. We've managed
    to reduce a number of indirect but not abstraction methods.
    
    We still require to clean up the namespace of saved doubles (in case
    we make more doubles of the same type)
    
    There is also some concern here about paths. Changing absolute to relative
    paths help but sometimes you may run into issues depending on your code.

[33mcommit a1bf20b78df64879c67d5be2411c8c1e604a58de[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 16 16:41:22 2019 +0100

    Fix assignment error

[33mcommit a700daa631ba92d43f4c8bbed17143e86e2ed552[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 16 16:31:16 2019 +0100

    moving computers

[33mcommit 493ce6dec38d4a87124c1b17c9d7de427545061e[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 16 15:50:16 2019 +0100

    Half-Refactor Double Scenes
    
    Made major progress here but we're not quite done yet. We need to
    make sure we can double nested scenes as well as create script_data
    information.

[33mcommit 75d9f565393316974d828c246597caf87fd5292e[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 23:52:47 2019 +0100

    Clear up some cruft, add a comment

[33mcommit cc54ff89d6bf8ae70d107a49a9a72c64472d8aeb[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 18:44:16 2019 +0100

    Push test methods into runner
    
    The less data we have in the test script itself, the
    better for users to avoid breaking anything (even if they
    are other developers)

[33mcommit 77ab2c9e3fa1cd82c22f7b9edf3acb41165052f7[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 18:07:03 2019 +0100

    Reduce Rewriter Code
    
    I think we could reduce this even further but I'm not sure how.
    We are able to add in a partial strategy easy now though, along with
    configs.

[33mcommit b626e3573965be3732631cddbde8bbb07b95d192[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 17:15:03 2019 +0100

    Update UI

[33mcommit 03f78468ddbf19457f7be8810ac2359978369c16[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 12:16:16 2019 +0100

    Rename test sub folders
    
    Names aren't accurate but it is nice to show how the subdirs can be used

[33mcommit 09f2be65382f60943b7b5dd82a6460317dedd0c6[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 12:15:26 2019 +0100

    remove print statement

[33mcommit ab484e7373c85733f21c0d3f48a92a14bc9018f8[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 12:14:31 2019 +0100

    revert some things

[33mcommit 856befaf4e34cae1f4308966ceb4efbc26c706b9[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 12:09:43 2019 +0100

    Fix blank.gd error

[33mcommit 2fcc025a7c5f7db87bfdf7faac1beb4f8f9e68a9[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 15 12:00:13 2019 +0100

    Update Display
    
    Everything in the one main screen. The bottom output panel is hidden
    almost (because we have our own).
    
    Some buttons are just placeholders but we will update that later.

[33mcommit fc77633d99aafaf4fb99bb1679c0dd77dd64b306[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 13 12:07:23 2019 +0100

    Remove _virtual methods from test.gd
    
    Our tests are controlled by the Main UI, so instead of using:
    
    _post():
            post()
    
    We now just haveu users override the methods since they can't access the
    other ones.

[33mcommit 0a21ef3e37d366933bcf9889061e5a87415967cc[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 13 11:52:54 2019 +0100

    Reduced Example Test Yields to 1 Second

[33mcommit 1a682d000764119424f05d87cd83b61624a2f4ce[m
Author: Darigan <code@darigan.ie>
Date:   Mon May 13 11:51:11 2019 +0100

    Add Reset Method to Main UI

[33mcommit 876b0c78b425a4b058bd8dec673ece649068fd0b[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 14:32:13 2019 +0100

    clear log.tscn

[33mcommit fa510626bec9b39533e3834917f22a423bc8a636[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 14:24:28 2019 +0100

    improve yield logging

[33mcommit 020a33f29c155cbf6c9b68f7c5b1a24ac204b0c4[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 14:11:15 2019 +0100

    Minor improvement to logging

[33mcommit ed401da6062ce82dbde596e4cc072d138ce51666[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 14:06:45 2019 +0100

    remove keyword highlighting

[33mcommit 3be082291c6010e6957f30952561a492045ad3c6[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 14:00:05 2019 +0100

    rename Blank.gd to blank.gd

[33mcommit 1811eed5b3c6e2d70054a2c7da647ef161ec8794[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 13:56:28 2019 +0100

    Split to() into on_signal and on_timeout
    
    Still a mess behind the scenes but it is much easier to help for the
    users.

[33mcommit c0f442ac1a28465ef54864c036c4d1148adeaa8e[m
Author: Darigan <code@darigan.ie>
Date:   Sun May 12 13:42:06 2019 +0100

    Add YIELD constant (alias for finished)

[33mcommit a3afbac0900542828056c90638c1d094282e729d[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 20:11:00 2019 +0100

    Add Hash == Hash expectation

[33mcommit a6abf707dcd3f1c4f15c2f85c87e0f2f7223ff3a[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 19:51:57 2019 +0100

    Add Primitive Yield Queue
    
    This allows us to resume after a yield automatically so less
    cognitive overload for our users.

[33mcommit d3b8e55816c6e68e6ec77ea6050988f9528a66b1[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 16:58:08 2019 +0100

    housekeepin

[33mcommit 088870eda8b93ed9a86938eaaba4736f3f5a85ab[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 16:30:45 2019 +0100

    Remove WAT prefix from log output
    
    Since it has its own output mechanisim, we don't need this
    anymore.

[33mcommit 104f54b84be3e1b4e4dade7c1ee8a5875d97273b[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 16:24:11 2019 +0100

    Add resume method call
    
    It froze here because we forgot. Need to have it handle itself in the background.

[33mcommit 2b7d112d797f710dd31b32048d21cd247fe3c284[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 16:02:01 2019 +0100

    moving

[33mcommit db81011ba9e257bc4c0727fa8b42035b8b58ebcc[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 14:12:13 2019 +0100

    Logger Log's Yield Time Left on Same Line
    
    Reduces quite a bit of unnecessary lines

[33mcommit 5f112206e5f7d4115b89731668683ca03c7e5b37[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 13:27:05 2019 +0100

    Added Basic Logging

[33mcommit 16e19c99d59e2058bdec214229cbdfbfd9600bb6[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 12:38:15 2019 +0100

    Add output method to test runner
    
    A pre-requisite for a future output manager, want to
    remove stand alone print statements

[33mcommit feb58eb02130fe45edfc08677d4644ff66c0c294[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 11:40:07 2019 +0100

    Add Test Subdirectories
    
    This lets people organize their tests better. Currently we are only
    going one level deep but hopefully it should suffice for now.

[33mcommit 03c74c3b13af8cbae2258eda1feb56f392c98c0d[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 01:42:51 2019 +0100

    Refactor Yielder to built-in to() method of test.gd
    
    Pushing more things behind the scenes.

[33mcommit 3bd32948c950d5c0009d3b1e183151a07e756412[m
Author: Darigan <code@darigan.ie>
Date:   Sat May 11 01:07:54 2019 +0100

    Refactor Finish Test to Test Script itself

[33mcommit aa10c2de7d16d353b1df492820a14596ecf06239[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 21:54:35 2019 +0100

    Reverse expect.is_true and is_false result msg

[33mcommit ce1b6bab2f9cfff6d721e04555bd444d4423f156[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 21:36:04 2019 +0100

    Remove testrunner.resume from Yielder
    
    This would cause issues when using multiple yielders, we resume
    manually now but in future we may also be able to implment it into
    the post teardown test method

[33mcommit 7c6588df2853ae62b1444e2f025603951ef1ca5f[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 14:58:02 2019 +0100

    Add Basic Logging
    
    Helps with Yielding (so we can see something happen even
    if it does get cloggy).

[33mcommit d6c6f630bec27ca00ad591197a4428006ec765af[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 11:31:27 2019 +0100

    Refactor Display to Display after ALL Tests
    
    Previously, it would be display tests while running them. This
    caused odd looking issues with yielders where it would be
    test-blank for a few moments-test
    
    We will instead be introducing a test dialog box while running. We
    can also store error output here when we're finished (and an option
    to show/hide after tests)

[33mcommit c01a7b3c49281138d0a8a281bab71e8dfae03220[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 02:41:30 2019 +0100

    Add Basic Yielding Mechanic

[33mcommit 2bad7138ea4a2bae7e48b76d31c4ebcf9b00abd5[m
Author: Darigan <code@darigan.ie>
Date:   Fri May 10 01:56:18 2019 +0100

    Save State
    
    This commit does not introduce anything new. Instead we are saving the
    last known working state before a big change here.

[33mcommit 6dbb7314768db766c40b84d2f5b855f8885f6869[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 9 23:00:51 2019 +0100

    Refactor Test Runner into one main method.
    
    This is a pre-emptive refactor for future work when handling pausing/yielding
    and related abstractions.

[33mcommit 456e57e7fcf55dfe3655f9a0e273a2529785b1d2[m
Author: Darigan <code@darigan.ie>
Date:   Thu May 9 14:20:06 2019 +0100

    Change Run Loop to Manual Iterator
    
    This is some pre-defined work so we can handle yielding much better in
    future versions.

[33mcommit f81404ad2794066fd812ec3b3e93120009ffd4c0[m
Author: Darigan <code@darigan.ie>
Date:   Wed May 8 12:34:55 2019 +0100

    remove namespace

[33mcommit 7a3319efab18220f1a8595049c31520c15fb0b35[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 18:19:19 2019 +0100

    Move construction logic out of scene data to doubler
    
    Trying to keep construction related methods to the doubler factory

[33mcommit bc6112a91e3216ada74f66b43eb5600536565785[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 18:13:57 2019 +0100

    Revert "Remove calls to save double scripts/scenes"
    
    This reverts commit 454819d5db0b2461b76cbd8d3f10a3414e1d48aa.
    
    I messed up. This is necessary for scripts at least.

[33mcommit 454819d5db0b2461b76cbd8d3f10a3414e1d48aa[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 18:06:05 2019 +0100

    Remove calls to save double scripts/scenes
    
    These methods were being called but we weren't actually using them
    for any purpose since we would just receive the instances we've created before-hand.
    They may be unnecessary all together

[33mcommit 21bc7967159d61b01e2e39c5a7e67ff799fb119a[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 12:29:05 2019 +0100

    Add absolute path to blank.gd inside IO

[33mcommit d892fb97a908743a186adeddc8c31f30487de849[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 12:10:35 2019 +0100

    Move input_output.gd to main WAT folder

[33mcommit 7ebb37f3e67153af89e44d051d5fce9b93a56d7a[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 12:09:27 2019 +0100

    Move clear_dir method from test to input_output.gd

[33mcommit 50e4da7b7518e554d99cb878071d5d821d73d6da[m
Author: Darigan <code@darigan.ie>
Date:   Fri Apr 5 12:05:53 2019 +0100

    Move Operator Constants into its own script

[33mcommit da97c575324e0644f6f601568c8790376175f918[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:44:48 2019 +0100

    Remove builtin class_name

[33mcommit a844bbf171a4b448a64d9a9cee0989cae2d16f73[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:41:17 2019 +0100

    Breaking Change. Replace double with DOUBLE const in test script.

[33mcommit 57da049262d9865588bc6c19876dadadc5a534c6[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:39:01 2019 +0100

    Remove class_name WATExpectations

[33mcommit 7cc958383130f20f12d7ecd884daf53470100b0b[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:37:37 2019 +0100

    Remove WATCase class name

[33mcommit e9dae3b3781020f2915c9e6483374a4dcad32952[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:35:42 2019 +0100

    Change WATTest to TEST const in display

[33mcommit 1722b11645ab0a9d7af7ef84f5d42c0ca238d207[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:30:05 2019 +0100

    Add more const preloads

[33mcommit bb83e3bf8a530c97390ce5476dfd33e4bca25dd4[m
Author: Darigan <code@darigan.ie>
Date:   Thu Apr 4 12:26:27 2019 +0100

    Add a number of const preloads to test.gd
    
    We're trying to clear up the namespace.

[33mcommit e5413466c0c2b5cdb06c97db8e451a671e5cfcae[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 20:12:42 2019 +0100

    Remove some comments

[33mcommit 08e8616fed27ad3ba93920fa6b9271a99c7a499e[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 20:11:15 2019 +0100

    Undo the last commit. It left other nodes confused to roots whereabouts.

[33mcommit 57bb0dc3ad11822d4f683c7d2fa015ddcbf0c701[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 20:09:56 2019 +0100

    Reorder _create_scene_double conditions
    
    So that the least frequent is at the bottom.

[33mcommit 03e09fc5b83e6f7e0d197292e064d984cd6e24f1[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 20:08:06 2019 +0100

    Add boolean method for grandchild check

[33mcommit 4278dc38a4570baa19780673d346ca092d0080bd[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 20:04:20 2019 +0100

    Change second if to elif

[33mcommit 387d64418e6532f10445b217717a425cd84dc552[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:59:28 2019 +0100

    Add more add_child methods that mutate in place
    
    We might be seeing a new class here that has these operations built in.

[33mcommit 76b9e976f8d78f3a38f609c2374970608c7c8cce[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:49:41 2019 +0100

    Add "add_granchildren" method that mutates in place

[33mcommit c9b256daf5fb1017472b960ec9235503d81a6d1d[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:40:42 2019 +0100

    Instance node in a seperate method

[33mcommit 0a240770643a2c9907bb37c52d7a83b7dd59ed83[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:35:36 2019 +0100

    Extract semi-complex logic to helper method

[33mcommit f66677094e53c785e9dd8667cd7be418b7f96eda[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:26:04 2019 +0100

    Add Boolean Helper Methods

[33mcommit 173f38deb06f253bae1bb4d4f1bd30039b3d8527[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:21:21 2019 +0100

    Fix Comment

[33mcommit ac4073072c88f91628f9b411a681b161b71c3511[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:20:05 2019 +0100

    Remove unused method

[33mcommit c7f200006e033f3235372b5929940abbee6ea187[m
Author: Darigan <code@darigan.ie>
Date:   Wed Apr 3 19:08:35 2019 +0100

    Fix Blank.gd to blank.gd

[33mcommit 978c466de936b6c217f1d3fd87ca6c617eeb8ca1[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Wed Apr 3 14:23:03 2019 +0100

    Delete .gitattributes

[33mcommit d8db365a4eab38d0b713bf4974835958543d5573[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Wed Apr 3 14:22:01 2019 +0100

    Create .gitattributes

[33mcommit 53c1db10e953c65bbc23b86758eccb030faad830[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Sat Mar 30 13:52:49 2019 +0000

    Update README.md

[33mcommit a035e382b0d38ca90b366e67b9c396d4f2576ca8[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Sat Mar 30 13:47:52 2019 +0000

    Update README.md

[33mcommit a6c28eee86d1eb47fdc3582fd29743c0e30430c9[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 30 13:02:13 2019 +0000

    Add default method for stub default return values

[33mcommit 69ec6fe8b03336b03d9a50f84dd043cd6999923d[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 30 12:15:39 2019 +0000

    more example images

[33mcommit 454a27d12b17a30f9e78a188e5d50d4295204af6[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 30 12:09:01 2019 +0000

    Add protected fixture methods that handler future boilerplate
    
    IAMGNI

[33mcommit 65d691349d86d568964d522560ec2b4501391319[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 18:37:46 2019 +0000

    fix error from last commit

[33mcommit 8265f89fb5394607a7c0ca771bbf2baea56364de[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 18:35:03 2019 +0000

    housekeepingo

[33mcommit 7e79c26d83e759d8f1efa88b093b1872b96b7f25[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 18:33:35 2019 +0000

    Refactor was not called

[33mcommit e38823bbed98473b43c8f4eb9e58f2dc1eed5ff2[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 17:18:45 2019 +0000

    Add Calc example with images

[33mcommit da3ad512f295603c6d4767e96c0caeeda75529d9[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 16:56:10 2019 +0000

    add image

[33mcommit 686e2108338bace00d90245fb09a691527124569[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 12:50:14 2019 +0000

    Implement execute method for doubles
    
    Hiding implementation from users, previously would have
    had to do "double.instance.method".

[33mcommit 8cb53dc78c5b0f6a996588ab00ac060eb74e8b96[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 12:19:13 2019 +0000

    Add bool to script/scene doubles for was_called methods

[33mcommit 6b9e2e5690ea85df8fd5587f44fbc1113e8719cc[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 12:06:29 2019 +0000

    Change "paths" to "outline"
    
    Don't want to get confused with filepaths.

[33mcommit dac68d6884945faf4f408d310f6cee72c38f7a75[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 29 12:04:47 2019 +0000

    Refactor Load/Save from Doubler into their own IO script

[33mcommit dda5b30d83ff623533c05e5f1dd4315a5d27b4ba[m
Merge: 2e0df4a ebdea5f
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 19:49:58 2019 +0000

    Merge branch 'master' of https://www.github.com/CodeDarigan/WAT

[33mcommit 2e0df4a45192124ac4cc77df4969a096d837ae68[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 19:21:01 2019 +0000

    Delete Temp Dir feature implemented
    
    Can now do one immediate subfolder as well.
    
    remove a lone print debug

[33mcommit ebdea5f418e69842ab45d58669c6b62fd4ca4528[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 19:21:01 2019 +0000

    Delete Temp Dir feature implemented
    
    Can now do one immediate subfolder as well.

[33mcommit b919c43b9865a402d83169aec931835f6d246269[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 17:27:12 2019 +0000

    remove a lone print debug

[33mcommit 11e86e741b56142b19aeb095f7a581091c4e46c1[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 17:25:06 2019 +0000

    Scene Doubling working
    
    We require a delete doubles to handle subfolders as well.
    It is unlikely we will need to account for extra folders for
    duplicate scenes (seeing as these should be flushed anyway?)
    
    There is also an errorneous one being printed somewhere.

[33mcommit ce07ebabfce30cb20fb4b25070c650594b79f31a[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 28 02:42:11 2019 +0000

    Major work done. Scene Roots are not being doubled.

[33mcommit 974d0bed3a9721af4bb1d991c07f9a5f344c903d[m
Author: Darigan <darigan@protonmail.com>
Date:   Wed Mar 27 22:43:54 2019 +0000

    Refactor Doubler Script to help for future scene version
    
    Note: Is complaining blank.gd is being loaded from elsewhere. Best guess
    is a cache error.

[33mcommit 22c528aff8b8db4ad69b3736b53b2fba62c708b8[m
Author: Darigan <darigan@protonmail.com>
Date:   Tue Mar 26 17:21:07 2019 +0000

    sloppy commit, revert this soon

[33mcommit 518bf848a9bb43773dd8a0f946e8684f58347e22[m
Author: Darigan <darigan@protonmail.com>
Date:   Tue Mar 26 12:04:22 2019 +0000

    remove extraneous print debug

[33mcommit d79c5a6ff731305ddd1239d598eda6ae8158ceb9[m
Author: Darigan <darigan@protonmail.com>
Date:   Tue Mar 26 12:03:06 2019 +0000

    Change method manager to be the double instance rather than the factory
    
    Less code in one place, much easier to manage overall.

[33mcommit a35a5b2f7a9dc75c8f2dddba327fb96bcdfd5f86[m
Author: Darigan <darigan@protonmail.com>
Date:   Tue Mar 26 11:31:10 2019 +0000

    Extract _double_script, _double_scene & boolean methods from _init

[33mcommit 9a0c53d95d592eafe2cbf22454d5ad75d1b6e005[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 24 01:39:09 2019 +0000

    Remove string typing from event variable
    
    No "any" equivelant and it can be String or Null.

[33mcommit 4d50e13571bdd6e9f528f42ee31a2af6b0796c77[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 24 01:37:48 2019 +0000

    Remove some commented out code

[33mcommit a20e487bf57988aee3e7ee98ed2753a86eaf0c90[m
Merge: 9d24e4b 0e95222
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 24 01:32:41 2019 +0000

    Merge branch 'master' of https://github.com/CodeDarigan/WAT

[33mcommit 9d24e4b3daaba22be873adf809da3de930d3670e[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 24 01:30:14 2019 +0000

    Move saving/loading/instance out of rewriter to parent doubler class.
    
    We might require splitting this up further soon as well.

[33mcommit 0e952229665164b1fec87132cee9e17aa62276cc[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Tue Mar 19 13:12:30 2019 +0000

    Remove comment to use delete_doubles again

[33mcommit f785757c86aae8779cb7fe5f025e8e42564f9d42[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Tue Mar 19 13:07:07 2019 +0000

    Refactor WATCHER into its own script

[33mcommit 80bd8a74c584684972c8c43d28fd494b35639f97[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Tue Mar 19 12:48:06 2019 +0000

    Fix no-return type functions to only use ":"
    
    Had to dedent a line to remove empty spaces.

[33mcommit 0c1575e91aab6569fd542008adc76180cc9e943e[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 20:23:47 2019 +0000

    add clean name to tree items for methods

[33mcommit 1707899ef7ce8a66b78860bcbefa9bf30a208327[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 20:11:38 2019 +0000

    Remove a debug scene

[33mcommit 5b97547d3a36d16e0c19ef4fd444a17d5cac3eff[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 20:09:05 2019 +0000

    housecleaning

[33mcommit e7402bf7a6c6f6b0e9d43e688f5d180e28fafd0d[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 19:54:12 2019 +0000

    Refactor Double.gd
    
    We add all the methods during doubles init rather than adding a check per method
    (this was really bad? Like why did I do that)

[33mcommit b84dcae28390fc859031f181f2a53e752bfbf858[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 19:43:43 2019 +0000

    Refactor Split rewriter into tokenizer and rewriter
    
    Both phases are now much more simpler in handling and less cognitive overload
    altogether.

[33mcommit 449ddb9b5134deececf447aa4bd172629dd697ee[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 12:07:47 2019 +0000

    Fix double writer method tokenizer
    
    It was writing methodname(firstarg: rather than method_name

[33mcommit b5f6355374c4670df379e828d0af5d2e0f09cbf6[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 11:57:48 2019 +0000

    Refactor Method.gd
    
    Create some sub-methods to help filter. Builtin functional methods
    would be a great help but they don't yet exist.

[33mcommit 08cce2250c816e905654530acb2a5238de76a5b2[m
Author: Darigan <darigan@protonmail.com>
Date:   Mon Mar 18 10:59:25 2019 +0000

    Refactor Inner Method Class of Double
    
    Moved it to its own script to better contain future methods.

[33mcommit 7775a7437bc989a1165959a67c62e07901e099f2[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 17 12:34:35 2019 +0000

    Add OP.BLANK const & Refactor "" using it

[33mcommit e1d9e1eb5de93f5285fcf4554bac6887b23b8530[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:31:47 2019 +0000

    Fix Image

[33mcommit 59d05f59bbd96b56aee9769f5671b7c5f64f2ff0[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:31:07 2019 +0000

    Add image

[33mcommit 5c68066e71d576f9e60ff6059128cc664fa8db5e[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:29:43 2019 +0000

    Add image

[33mcommit 299ff8914164c54dc0791afdd16889c9d593dc02[m
Author: CodeDarigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:27:35 2019 +0000

    Add quickstart guide

[33mcommit 42695a61609af763f5cc240ac6d02c7f48a57da5[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:17:08 2019 +0000

    Add Simulate Method
    
    Untested but alpha is alpha

[33mcommit 7d64525891a0a88d6504761d40d2ad9e10bdc2e2[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:14:35 2019 +0000

    Remove unnecessary print statement

[33mcommit 62406821c7249c8da5a59edb7e40b1208adf92cf[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 21:13:32 2019 +0000

    Add was/was not emitted and basic watching capability

[33mcommit 9329622df2c0d1aeb1e312cb7e2535e18d6955ab[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 19:53:30 2019 +0000

    Housecleaning

[33mcommit d34d204c550f76f334ec9a6f61fd415123797f08[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 15:09:32 2019 +0000

    Refactor some double call count code

[33mcommit 45cf56b190020bdf68e02dd8c26996cad3928353[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 14:58:50 2019 +0000

    Add a bunch of expectation methods

[33mcommit 8f5f44c56f3131fafbe0d9fb6eeba5613dc589aa[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 14:12:47 2019 +0000

    Fix bug in WATCase where success = false was reassinging the parameter not the class property

[33mcommit ffef63a1861df35e89e11457dce4650c41f94278[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 14:02:27 2019 +0000

    Reorganize Folder Structure; Delete namespace
    
    Namespace script caused bunch of cyclic references, so we're just
    going prefix everything with WATThing

[33mcommit 46a5d853088300966cc6744d6f40688e31eff979[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 15 13:10:32 2019 +0000

    Fix Method Total failure to reset after script; Refactor WAT to use namespace file
    
    The namespace file is the only thing we use an actual class name on, so we can
    avoid naming conflicts with the rest of godot or peoples projects. In the future
    we can probably use this to handle config options as well.

[33mcommit 92ec95b66b217ee5e0a3eb0c21a57a34106ff88c[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 17:35:40 2019 +0000

    update readme

[33mcommit ee9e28200944e7d5e46d930b457f0f2674b503c5[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 16:08:23 2019 +0000

    Remove "self" from a number of methods.
    
    According to sources in Discord, it is actually slower as of now.

[33mcommit 796ac54f5574ddc733a83b68b7dca2246c28aa3b[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 15:59:06 2019 +0000

    Add Delete Temp Folder Method in WATT

[33mcommit 897c91705380ed0ee45cd490929fe44b87c873bf[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 15:39:08 2019 +0000

    Add was and was not called expectation methods
    
    Reorganized some folder structure too

[33mcommit bc8810ba8ee4ee7a99cc6ecae29d88b559f0acc8[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 13:32:26 2019 +0000

    Implement Doubler Stub Method
    
    A bit messy but not a lot of code so we can handle soem refactoring later.

[33mcommit f64bcbb686566f1a77bde17bcfa48cd8cbe9a5d7[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 12:47:11 2019 +0000

    Double Writer can now return a real instance
    
    Since we're extending from other scripts, we don't actually
    need to do anything with const/var/signal since they'll exist in the parent script.

[33mcommit 00e640401a3dc741944919d46d80771b9ca50e61[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 12:22:34 2019 +0000

    Rewrote Writer to use Source Data Class & recursively add source code from parent scripts

[33mcommit cffccc28ba0503fbdd2892dbd42f6c44bba58860[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 10:55:36 2019 +0000

    Add var/const/signal rewrite
    
    I can't find a reason to change these. Even with setget methods, we will
    eventually come across them defined in the source.

[33mcommit 26557fb705cb4258b7c072f608f26fda5c352ebd[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 10:41:29 2019 +0000

    Refactor data access to helper queries in Writer.gd
    
    Right now all of this is being performed on class level data but
    it might be best to handle it as a series of transform methods
    (this way the data structure is new each time).

[33mcommit 336f700e389a5285ee6b492e08a2ed36645d5d83[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 10:38:03 2019 +0000

    Refactor extends string logic to helper method

[33mcommit a3ccb30859bb2983967d262d2978fa60837ad467[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 14 01:18:28 2019 +0000

    Refactor complex string split logic into helper quries in writer.gd

[33mcommit 2774135ae7323e2c460f1491b5ba738b3be97402[m
Author: Darigan <darigan@protonmail.com>
Date:   Wed Mar 13 23:11:19 2019 +0000

    Change "str" in element for element.begins_with("str")
    
    By forcing a begin, we can ignore inner classes for now until we're more suited
    to implementing time. Refactored some other code as well.

[33mcommit 5cf9fdbb46bcf2a623328585f83094dbc645b319[m
Author: Darigan <darigan@protonmail.com>
Date:   Wed Mar 13 21:11:37 2019 +0000

    Create Successful Double Writer Feature
    
    We store created scripts in user/WAT (should be user/WATemp).
    
    We'll handle most of the call logic in a seperate doubler property script
    
    There might be some I/O conflicts we have yet to deal with yet though.

[33mcommit 5f6d6c7be5633b0b04386369fa712ec7a9752215[m
Author: Darigan <darigan@protonmail.com>
Date:   Wed Mar 13 19:27:50 2019 +0000

    Create Writer Script
    
    Not yet finished. However we did manage to create a successful tokenizer.

[33mcommit 95eb372d0cde6c956a6219b03bb2214e960cdccb[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Wed Mar 13 16:04:07 2019 +0000

    Moving

[33mcommit 52368eb0792fba8f415f40c1eeb9118b8d70c150[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Wed Mar 13 12:53:23 2019 +0000

    Create simple load/save method for doubles

[33mcommit 2b27299f37b6e1e4e41f248d30dfacd199881eb3[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Wed Mar 13 11:56:33 2019 +0000

    Create Doubler Script with some Comments

[33mcommit d16a409cfc3b2e4b8ef9f881a1e7ef43ff63b00b[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Sun Mar 10 19:58:12 2019 +0000

    Add clear method to main scene

[33mcommit b6917bbad3aa5f9c64a1db4cc631651d5f328f42[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Sun Mar 10 19:53:30 2019 +0000

    Add a few comments in expectation for method suggestiosn

[33mcommit 699f97c863bd3abe8618ab2edf4a7b60fb0d82ce[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Sun Mar 10 19:46:44 2019 +0000

    Add Spaces around operators in result column

[33mcommit a6b9240beb80a1d4729d123f5f2fbe6e3104d3aa[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Sun Mar 10 19:33:05 2019 +0000

    Add failing tests for greater than expect method

[33mcommit 2c886d2359e0005eff2399788ad9c2f6c220fa07[m
Author: Darigan <47497501+CodeDarigan@users.noreply.github.com>
Date:   Sun Mar 10 19:27:15 2019 +0000

    Add is_less_than method to expectations.gd + pass & failing tests

[33mcommit 25452549dad44a022bae2c871de2c59c1dfd7d0b[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 13:07:53 2019 +0000

    Add more const string operators

[33mcommit aac9fb7dcbb9fb0dea030f544244c3cc06f565de[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 13:05:41 2019 +0000

    Refactor message -> expected, got -> result

[33mcommit 7fd4f5320988e247fb73ccd778b943bd0359112a[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 13:01:39 2019 +0000

    Add String check for greater than (also change has to get("notes") in display

[33mcommit 53777615e4476b9d5df2d4923ed52fd492f6875e[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 12:57:52 2019 +0000

    Add is greater than expectation
    
    - Added some more constants
    - Added a type check for collections

[33mcommit c60ac951ea252e8d2e88aa662375481549d38a5d[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 12:36:05 2019 +0000

    Add Operator String Constants to expectations.gd
    
    We show the real result including correct operator (so if
    we're checking something is equal but it isn't, we use the
    inequal operator).

[33mcommit 98b89826a8f975dfb4fc6f77394f4c6946a35150[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 12:17:37 2019 +0000

    Add is_not_equal method and tests

[33mcommit 06accb84419d978820b0b289455e9a062f66782d[m
Author: Darigan <darigan@protonmail.com>
Date:   Sun Mar 10 11:34:33 2019 +0000

    Refactor display methods into Transform method
    
    Note: We're apparently commiting more here but it wouldn't
    add these commits in a previous version? Check here for
    unintended consequences.

[33mcommit b43311d4a1c71eea51dc9f3dc93c985430044e61[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 15:02:50 2019 +0000

    comment somethings out

[33mcommit 5972ead48f4231606bf9a9a4b9065495ec5d8573[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 14:32:36 2019 +0000

    Color Column 1 Success if successful expectation
    
    (as well as column 2)

[33mcommit 3475fdaf88fb288f7fc02fb222aadb828e7233f4[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 14:29:38 2019 +0000

    Add Builtin Type Stringify Feature
    
    This allows us to show the real values being used
    so people can see if they used the wrong ones somewhere.

[33mcommit 8ae0496e14269eb38d183bdd74d20153946867ab[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:44:56 2019 +0000

    Fix Bug so base root turns green on full success in both columsn

[33mcommit 104b370c491d5622710d3b19624532467619db0a[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:40:11 2019 +0000

    Fix Success not being switched to false on failure in testcase object

[33mcommit 9e53926c30f51cb967dddd30a28479535d7be1ca[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:36:10 2019 +0000

    Add FAILED Color and check for Pass/Total features

[33mcommit 8c01e83b22ab4e820c51b870e848d72f194eb27f[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:30:43 2019 +0000

    Add all passed/total test features

[33mcommit a436942a640033e9f32d46ee0167b01a08e5006b[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:23:25 2019 +0000

    Add Script PASSED / TOTAL method display

[33mcommit 1c69850f3e052566d67284593dba62d9ab28d7ee[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:16:30 2019 +0000

    Create const TOTAL Dictionary
    
    const because we need the script total to persist through each display rotation,
    we require a manual clear in future.

[33mcommit 3617a700813dc50a0c10c69668dcb5d8f7a41366[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 13:08:23 2019 +0000

    Fix

[33mcommit 0329dc5b4d742401487e573113018ed9681dd144[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 12:41:28 2019 +0000

    Refactor Display Methods into a chain of responsbility system

[33mcommit 9e5d227aa6e9000fdfe5a1c174457039a1dc6b90[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 12:11:23 2019 +0000

    Add is_equal tests to test_primitives.gd

[33mcommit fee99a9357c0f42dd3b4b56ef1f25d221dd584c2[m
Author: Darigan <darigan@protonmail.com>
Date:   Sat Mar 9 11:56:02 2019 +0000

    Remove "expected, got" parameters
    
    I haven't considered a proper way of doing this that doesn't result in
    "true"

[33mcommit 75d02c3d20c4b4f614b64481da43d8f6d1d9d403[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 15:50:59 2019 +0000

    Add "Expected X, Got Y" to expectation methods.

[33mcommit a78cb4daa42e379e2e3431333999100e0ae492e9[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 15:37:27 2019 +0000

    Correct bad.dictionary to bad.dict

[33mcommit 11b6c45088a2a5bd2d6265fb9a0737e09bae5295[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 15:30:14 2019 +0000

    Removed "self." from primitive test script
    
    This is apparently slower?

[33mcommit 9be4c8016659949ff14115d5ca0eaa48963a7210[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 15:28:20 2019 +0000

    Add Primitive Test Method intended for total failure
    
    We're basically pretending we got the wrong return value
    from all of these stand alone expressions.

[33mcommit f5ea2185bf25166d0796ae16fa3b0176aaee9996[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 15:00:10 2019 +0000

    Remove Calculator Tests in favor of Primitive Tests
    
    Primitive Stand alone tests are easy to confirm. So we will work with them
    for the time being.

[33mcommit f665fb7738d15000a6bc1c43c3392754df5557a3[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 11:36:40 2019 +0000

    Refactor _display parameters
    
    Takes a structure generic now instead of splitting it as a parameter,
    less type safety but also significant less arguments too.

[33mcommit 3fc061f1502e19b6492d2b4e753c939ce0b644c9[m
Author: Darigan <darigan@protonmail.com>
Date:   Fri Mar 8 11:28:51 2019 +0000

    Trim Trailing Whitespace

[33mcommit 4f57c05ffb117bd4206b6d8fed17868658d66c0b[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 17:39:30 2019 +0000

    Refactor Main Run Method
    
    We return an array of preloaded scripts now instead of path. Looks
    a lot better.

[33mcommit 8faa15c73ededb2e2a91735bdf3072611d3c66dd[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 17:33:57 2019 +0000

    Refactor Method of getting Script Details for Test Case
    
    This was all over the place, we can get it from the test
    script itself by using get_script().get_path()

[33mcommit 6de11917c89304b25ffbc6e76e0cbc54b2d76d7b[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 15:49:18 2019 +0000

    Add Iterator Method to collect all tests within test folder
    
    A good start, we'll probably fix a lot of this up with configs.

[33mcommit ca7b2e29b8ff2d1b77cd4c8c202886ac3db4640e[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 15:36:40 2019 +0000

    Remove superfluous "success" treeitem in display

[33mcommit e6f86396dc069ecf1b0eaa608a00f86117438580[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 15:29:39 2019 +0000

    Reorganize Structure
    
    Trying to keep top layer clean

[33mcommit a8b04be6a91b40f8df37c92d0484117938fa171d[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 15:23:52 2019 +0000

    Remove useless statements

[33mcommit 7de91f843bfe00abdf9385305d16dbdc757b258b[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 15:21:07 2019 +0000

    Implement Basic Working Functionality
    
    There was a lot of moving parts to this but it is working in its
    rawest form so it was a good start.

[33mcommit 0d9daa130e8549130ea56363fa46fe827db3a42c[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 14:39:28 2019 +0000

    Add Test Script, Case & Expectations
    
    A bit much for one commit but we'll get to a point soon were we can be more atomic about
    everything.

[33mcommit fbbc9b0e1f154c1787ad4d719dcbae9615d70d69[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 14:07:46 2019 +0000

    Create Display (Tree) Script on Main Scene
    
    - Reset Method (called on load into)
    - Display and _display method placeholders

[33mcommit 0f6816bf203dc4696a5aa0a916deb7a957e70413[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 13:39:05 2019 +0000

    Rewrite README.md with brief feature outline

[33mcommit 3603491bf5b9f5a0671b5738ad518a20865bfa8c[m
Author: Darigan <darigan@protonmail.com>
Date:   Thu Mar 7 12:51:25 2019 +0000

    Implement Base Skeleton
    
    No functionality yet. We've decided to go with a main screen plugin
    (now that it is an option). Should be divided between top menu, side
    config panel and main tree display.

[33mcommit 4d5f9973e5cb770ae8954729b10dd26a21f88d59[m
Author: CodeDarigan <code@darigan.ie>
Date:   Thu Mar 7 11:11:33 2019 +0000

    Initial commit
