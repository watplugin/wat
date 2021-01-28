# Check WAT5 Log too

commit 2bea561c05cd75cfd905c0efd2af3bd2ad143e54
Author: Alex <code@darigan.ie>
Date:   Thu Jan 28 23:02:36 2021 +0000

    Fix Junit NOW

commit 53ac66f1f2890ccbb7e035f1d3a655ba9dd4713a
Author: Alex <code@darigan.ie>
Date:   Thu Jan 28 23:00:39 2021 +0000

    Fix JUnit XML Now

commit 3d3c7fceac204170686cefeca3faeed10f6d928a
Author: Alex <code@darigan.ie>
Date:   Sun Jan 24 20:08:12 2021 +0000

    Add Run In Editor Toggle

    Editor Runs don't allow for debugging but are at least 2 seconds quicker
    than game context runs.

    Note we have some issues with threaded tests terminating a bit too early
    so we need to stop that.

commit fb2ba589c472388acc41ba8e780359dd0ff41a4b
Author: Alex <code@darigan.ie>
Date:   Sun Jan 24 19:01:32 2021 +0000

    Add Multithreaded Runner

commit f589f65773a1994973a8cc58b19f166f08e6508f
Author: Alex <code@darigan.ie>
Date:   Tue Jan 5 22:13:19 2021 +0000

    Can Now Export Tests - Check this

commit ac6efee3615a6ed5cffd1748ab6af3182c0a59f0
Author: Alex <code@darigan.ie>
Date:   Tue Jan 5 13:04:37 2021 +0000

    Remove Warning

commit 4a946f0e7a0f93d9486556ebf8d37201b79a9f37
Author: Alex <code@darigan.ie>
Date:   Tue Jan 5 13:02:52 2021 +0000

    ReAdd Single Threaded Tests

    Also added thread spinbox to UI and a max check for threads (if
    people went over this, the main threaded ended up never returning)

commit 5288fa348ebac41efa00730125ab4e1be560f754
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 23:11:15 2021 +0000

    Run All working with threads (shaky)

commit 8d825e6ef09f17224e3ce4b795da68ee149d0845
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 22:36:13 2021 +0000

    Threaded Tests Working

commit 533479926da69ddfb43a6bb4de06535e7187d128
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 22:21:20 2021 +0000

    TestRunner runs Threaded Tests

commit a7cea0824780bf01eacbbae6a1a747718fd73a2f
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 21:47:40 2021 +0000

    Add Yield Time to Metadata

commit 8f27b06d579b2216b3dece7ff0036316a05e8244
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 18:32:53 2021 +0000

    Add Disconnect FileManager (+ fix typo)

commit 1e0fefa2dcf36df1ac24dbb0854c370493cd0382
Author: Alex <code@darigan.ie>
Date:   Mon Jan 4 18:29:06 2021 +0000

    Connect FileManager via Plugin (No Implementation)

commit 66f6765da3056b74d1a2f079735a3c2af8438dd7
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Thu Dec 31 12:27:05 2020 +0000

    Summary runs in real time

    Also remove debug prints

commit aa0663ca3453c0f4599d6a6e0b3d049c3607ed3a
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Wed Dec 30 00:41:02 2020 +0000

    Add Icons To TestSelector

commit c3124a6ca262886f86b6cdfd89ca9cebac895165
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Wed Dec 30 00:25:20 2020 +0000

    Update Summary With Icons

commit f91bd53816a2d14c8a4e8d403a2e5a399cea2f2a
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Wed Dec 30 00:12:18 2020 +0000

    Update Theme To Match Editor Default

commit ca9086b2f47078d25f7a76c63d077357b1964548
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Mon Dec 28 16:08:01 2020 +0000

    Streamline Tags

commit 4f68a61d57211db76c51bf36660bf1baed3a2da6
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Sun Dec 27 23:03:45 2020 +0000

    Add Shortcut Operation

commit 7405d81bb6dbc5ae75ef94c017c31b10f166eef9
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Thu Dec 24 12:05:16 2020 +0000

    Use Goto Function Via Signals

commit 7b35dda6edd5211ee5eed43f62f3a6e40f5dc548
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Thu Dec 24 11:49:15 2020 +0000

    Add Editor Context Launcher

commit b12de004b8f795f15fb58677239feb2320465ed2
Author: AlexAndDraw <darigan@protonmail.com>
Date:   Wed Dec 16 16:31:04 2020 +0000

    ReAdd Ability To Run Within Editor

commit 1cb67d09529a5804dbcba0b7cee28357e7e0f6e5
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Thu Dec 3 20:34:25 2020 +0000

    Improve TestSelection

commit d91afbff674e11a9dc892170a768f80712c88cf3
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Thu Dec 3 17:02:45 2020 +0000

    Add Start Of Popup Selection

commit 90b07c9fcecd0de2d7bcafad1211ccca709c9563
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Wed Dec 2 12:28:58 2020 +0000


commit 456384ed539e350244b2d279ecc5da1e9f50664d
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Fri Nov 27 22:52:52 2020 +0000

    Make Use Of New Play_Custom_Scene Method

    With this change we've solidified a breaking change

commit 24ec5ab1ce72ea97757cc8bdf914a85d67dd5930
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Wed Nov 25 16:18:06 2020 +0000

    Change Bool To Correct Value

commit d50e0fcc28d60231d203157beef0ce4dca39505c
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Sun Nov 8 02:20:19 2020 +0000

    Split Run/Create In Runner

commit 888d082aefa7b1cbe9464a1a0a8b8479c6518914
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Sat Nov 7 11:09:01 2020 +0000

    Remove Script Templates.

    Unnecessary and unhelpful. Usually just gets in the way.

commit 2973cb04227887e13f4f47ca4b4a93dd246100cb
Author: AlexAbdDraw <darigan@protonmail.com>
Date:   Sat Nov 7 11:08:01 2020 +0000

    Add Window Sizing Operation

commit 51c75eb5d7689eb3ac3b60a1da518ae426ce02cc
Author: Alex <darigan@protonmail.com>
Date:   Tue Sep 8 11:01:07 2020 +0100

    Add Ability To Run As Scene



- Fix Double Scenes not handling Exported Nodepaths (commit 4760fb45ac923e33128319d26640016660caf1e3)
- Double Default Arguments of Base Classes (commit eb41c0133ba5f28de8985dad57af34dfe13fea54)
