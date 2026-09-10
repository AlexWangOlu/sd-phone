-- Wi-Fi - local networks that carry data where the cell towers cannot, or will not. Enabled off
-- leaves the whole system inert and the phone falls back to cell service alone.
-- Wi-Fi - 在手机信号塔覆盖不到（或不覆盖）的地方承载数据的本地网络。关闭后
-- 整个系统不起作用，手机仅回退到蜂窝网络。
return {
    Enabled = true,

    -- Each network is a router somewhere in the world. `id` is what everything else refers to:
    -- the exports, the app gating, and a player's remembered networks, so renaming one drops
    -- every connection to it. `ssid` is only ever what the player reads on screen.
    -- 每个网络就是世界某处的一台路由器。`id` 是其他所有东西引用的键：导出、
    -- 应用开放判断和玩家记住的网络都用它，因此重命名 id 会断开它的所有连接。
    -- `ssid` 只是玩家在屏幕上看到的名称（已汉化为中文）。
    --
    -- `password` nil or omitted leaves the network open, which the phone shows without a padlock
    -- and joins in one tap. Anything else is checked SERVER-SIDE, so the answer never travels to
    -- a client that has not earned it.
    -- `password` 为 nil 或省略时网络为开放网络，手机不显示挂锁图标，点一下即可
    -- 加入。其他情况在服务端校验密码，因此答案绝不会发送给未通过验证的客户端。
    --
    -- Unlike cell towers, range here is a true sphere: distance counts height. A router is a box
    -- in a room rather than a mast on a hill, so the floor above should be able to sit outside a
    -- network the floor below is on.
    -- 与手机信号塔不同，这里的范围是真正的球体：距离计算高度。路由器是房间里的
    -- 一个盒子，而不是山顶的塔，因此楼上一层理应可以处在楼下网络的覆盖之外。
    Networks = {
        -- Open networks: public places that would plausibly hand out free Wi-Fi.
        -- 开放网络：很可能提供免费 Wi-Fi 的公共场所。
        { id = 'legion',    ssid = '军团广场免费WiFi',   coords = vec3(  195.0,  -935.0,  30.7), range = 55.0 },
        { id = 'pier',      ssid = '德尔佩罗码头访客',   coords = vec3(-1850.0, -1240.0,   8.6), range = 65.0 },
        { id = 'lsia',      ssid = '洛圣都机场航站楼',   coords = vec3(-1035.0, -2730.0,  20.2), range = 80.0 },
        { id = 'pillbox',   ssid = '皮尔博克斯医疗中心', coords = vec3(  298.0,  -584.0,  43.3), range = 50.0 },

        -- Secured networks: somewhere with a reason to keep people out.
        -- 加密网络：有理由不让外人进入的地方。
        { id = 'missionrow', ssid = 'LSPD-安全网络',     coords = vec3(  441.0,  -982.0,  30.7), range = 45.0, password = 'lspd1234' },
        { id = 'mazebank',   ssid = '花园银行-企业网',   coords = vec3(  -70.0,  -800.0,  44.2), range = 50.0, password = 'maze2024' },
        { id = 'lifeinvader',ssid = 'LifeInvader-员工', coords = vec3(-1047.9,  -233.5,  39.0), range = 40.0, password = 'gofuckyourself' },
        { id = 'unicorn',    ssid = '独角兽-VIP',        coords = vec3(  127.0, -1298.0,  29.2), range = 35.0, password = 'backstage' },
        { id = 'casino',     ssid = '钻石赌场-访客',     coords = vec3(  925.0,    46.0,  81.1), range = 60.0, password = 'jackpot' },

        -- Out in the sticks, where the towers do not reach. This one is the point of the whole
        -- feature: a dead zone you can still get data in, if you know where to stand.
        -- 信号塔覆盖不到的偏远地区。这正是整个功能的意义所在：只要知道站在哪里，
        -- 在信号盲区也能上网。
        { id = 'gordo',      ssid = '戈多山护林站',      coords = vec3( 2900.0,  5800.0,  98.0), range = 70.0, password = 'ranger' },
        { id = 'sandy',      ssid = '沙滩海岸医疗中心',  coords = vec3( 1839.0,  3672.0,  34.3), range = 45.0 },
        { id = 'paleto',     ssid = '佩立托治安官',      coords = vec3( -448.0,  6012.0,  31.7), range = 45.0, password = 'paleto' },
    },

    -- What a connection actually carries. Data is the whole point of Wi-Fi, so it is on; calls
    -- and texts ride the cellular network and stay refused in a dead zone unless you switch
    -- Wi-Fi calling on here, which is a real thing phones do.
    -- 连接实际承载什么。数据是 Wi-Fi 的全部意义，因此开启；通话和短信走蜂窝
    -- 网络，在信号盲区仍不可用，除非你在这里打开 Wi-Fi 通话 - 现实中的手机
    -- 确实有这个功能。
    Provides = {
        Data = true,
        Call = false,
        Text = false,
    },

    -- Rejoin a network the player has connected to before as soon as they walk back into it,
    -- without asking for the password again. False makes every join deliberate.
    -- 玩家走回以前连过的网络范围时自动重新加入，不再要求输入密码。false 则
    -- 每次加入都需手动确认。
    Remember = true,

    -- Seconds between scans while the phone is on screen. Nothing runs while it is holstered.
    -- 手机在屏幕上显示时的扫描间隔（秒）。手机收起时不运行任何扫描。
    ScanSeconds = 2,

    -- Level below which the phone gives up and drops the connection, 0 to 1 across the radius.
    -- A little above zero so a player standing exactly on the edge does not flap in and out.
    -- 信号低于此值时手机放弃并断开连接，在覆盖半径内为 0 到 1。略高于零，避免
    -- 正好站在边缘的玩家反复断连重连。
    DropBelow = 0.05,
}
