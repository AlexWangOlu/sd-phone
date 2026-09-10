-- Cell towers - degradable cellular service by location. Enabled off leaves every phone on full
-- service, with StatusBar.SignalBars still drawing its static bar count.
-- 手机信号塔 - 按位置衰减的蜂窝服务。关闭时所有手机始终满格服务，
-- StatusBar.SignalBars 仍绘制其静态信号格数。
return {
    -- Master switch. False leaves every phone on full service no matter where its owner stands,
    -- so a server can keep the mast list below intact while the system is parked. An empty
    -- Towers list does the same thing on its own, as does a list where every entry is malformed:
    -- a typo must never leave a whole server without phones.
    -- 总开关。false 时无论机主站在哪里，所有手机都满格服务，因此服务器可以在
    -- 系统搁置期间保持下面的塔列表不变。空的 Towers 列表本身效果相同，所有条目
    -- 都格式错误的列表也是如此：拼写错误绝不能让整个服务器的手机失灵。
    Enabled = false,

    -- Each entry is a mast position and the flat radius it covers. Service at a point is the
    -- BEST reading across every tower: 1 - distance / range. So a player 200 units from a
    -- 250-range tower (20%) who is also 750 units from a 1000-range tower (25%) gets 25% - the
    -- further mast wins because it reaches better.
    -- 每个条目是一个塔的位置和它覆盖的平面半径。某一点的服务取所有塔中的最佳
    -- 读数：1 - 距离 / 范围。因此玩家距 250 范围的塔 200 单位（20%），同时距
    -- 1000 范围的塔 750 单位（25%）时得到 25% - 更远的塔因覆盖更好而胜出。
    --
    -- Distance is horizontal only. The Z you put here is ignored by the maths, so you can paste
    -- coordinates straight off an antenna prop without the height eating your coverage, and a
    -- pilot at altitude keeps the same service as the ground below them.
    -- 距离只算水平方向。你填的 Z 不参与计算，因此可以直接从天线模型上复制坐标，
    -- 高度不会吃掉覆盖范围；高空飞行员与其正下方地面的服务相同。
    --
    -- This curated eight-mast network covers the whole map. Every town and populated area holds
    -- a usable signal, the back country thins out, and the far corners genuinely drop to nothing:
    --   full service   Los Santos, LSIA, Vinewood, Chumash, Zancudo, Harmony, Sandy Shores, Paleto
    --   fringe         Vespucci Beach, Grapeseed and Chiliad's summit sit around two bars
    --   texts only     Raton Canyon
    --   no service     Mount Gordo, the eastern desert and open ocean
    -- 这套精心布置的八塔网络覆盖全图。每个城镇和人口区都有可用信号，郊外变弱，
    -- 偏远角落真正降到无服务：
    --   满格服务   洛圣都、洛圣都机场、好麦坞、丘马什、桑库多、哈莫尼、沙滩海岸、佩立托
    --   边缘       维斯普奇海滩、葡萄籽和奇力耶德山顶约两格
    --   仅短信     拉顿峡谷
    --   无服务     戈多山、东部沙漠和远海
    Towers = {
        { tower = vec3(  -75.00,  -818.00, 326.00), range = 2200.0 },  -- Downtown Los Santos 洛圣都市中心
        { tower = vec3(-1050.00, -2750.00,  20.00), range = 1800.0 },  -- LSIA and the south docks 洛圣都机场和南部码头
        { tower = vec3( -438.00,  1075.00, 352.00), range = 1800.0 },  -- Galileo Observatory, Vinewood Hills 伽利略天文台，好麦坞山
        { tower = vec3(-3050.00,  1250.00,  20.00), range = 1600.0 },  -- Chumash, Great Ocean Highway 丘马什，大洋公路
        { tower = vec3(-2050.00,  3200.00,  32.00), range = 1700.0 },  -- Fort Zancudo 桑库多堡垒
        { tower = vec3(  280.00,  2900.00,  44.00), range = 1800.0 },  -- Harmony, Route 68 哈莫尼，68号公路
        { tower = vec3( 1858.30,  3694.04,  37.91), range = 1700.0 },  -- Sandy Shores and the Alamo Sea 沙滩海岸和阿拉莫海
        { tower = vec3( -180.00,  6350.00,  31.00), range = 1600.0 },  -- Paleto Bay and the north coast 佩立托湾和北海岸
    },

    -- Map blips for the masts. This is a setup and debugging aid rather than something to run on
    -- a live server: drawing the coverage circles is how you see where masts overlap and where
    -- the gaps actually fall, which is hard to judge from coordinates alone. Off by default, and
    -- deliberately independent of the Enabled switch above, so a network can be laid out and
    -- looked at before the system is ever switched on.
    -- 信号塔的地图图标。这是搭建和调试辅助，不是给正式服务器常开的东西：画出
    -- 覆盖圆才能看到塔在哪里重叠、缺口实际在哪里，单看坐标很难判断。默认关闭，
    -- 且有意与上面的 Enabled 开关无关，因此系统开启前就可以布置并查看网络。
    Blips = {
        Enabled = false,

        -- The marker sitting on the mast itself. Sprite and colour are GTA's own ids; the full
        -- lists live at https://docs.fivem.net/docs/game-references/blips/ Markers are drawn
        -- short-range so eight of them do not crowd the minimap; open the pause map to see the
        -- whole network and its circles at once.
        -- 塔本身的标记。Sprite 和 color 是 GTA 自己的 id；完整列表见
        -- https://docs.fivem.net/docs/game-references/blips/ 标记按短距离绘制，
        -- 八个不会挤满小地图；打开暂停地图可一次看到整个网络及其覆盖圆。
        Sprite = 1,
        Color  = 3,
        Scale  = 0.8,
        Label  = '手机信号塔',

        -- The translucent circle showing what that mast reaches. Its size is always the tower's
        -- own range, never a separate number, so the picture on the map cannot drift out of step
        -- with the service the maths actually gives you. Alpha is 0 to 255.
        -- 显示该塔覆盖范围的半透明圆。其大小始终是塔自己的范围，绝不是单独的
        -- 数字，因此地图上的画面不会与实际计算出的服务脱节。Alpha 为 0 到 255。
        Radius = {
            Enabled = true,
            Color   = 3,
            Alpha   = 80,
        },
    },

    -- Seconds a caller may hold a live call without call-grade signal before it drops, with both
    -- sides told they lost service. The grace period stops a call dying because someone clipped
    -- the edge of a dead zone for a moment, and the countdown resets the instant signal returns.
    -- Set 0 to cut the moment coverage goes, or false to let a connected call survive anywhere.
    -- A payphone leg is never dropped: a booth is a landline and has no cell signal to lose.
    -- 通话中没有通话级信号时，呼叫方可保持多少秒后挂断，双方都会被告知失去
    -- 服务。宽限期避免通话因某人瞬间擦过盲区边缘而中断，信号一恢复倒计时立即
    -- 重置。设 0 表示覆盖一消失就挂断，设 false 让已接通的通话在任何地方都不
    -- 中断。公用电话一侧永不挂断：电话亭是固话，没有蜂窝信号可丢。
    DropCallsAfter = 6,

    -- Minimum level each capability needs. Text and Data sit on the first bar's cutoff, so both
    -- work anywhere the phone shows a bar at all; a voice call is the demanding one and needs
    -- more. That ordering is deliberate: a call wants sustained bandwidth in both directions,
    -- while a text or a feed request is a short burst that a weak signal still carries.
    -- 各项能力所需的最低信号等级。短信和数据设在第一格的临界点，因此手机只要
    -- 显示一格就能用；语音通话要求高，需要更多信号。这个顺序是有意的：通话需要
    -- 双向持续带宽，而短信或信息流请求是弱信号也能承载的短突发。
    --
    -- The practical result is a one-bar band where you can text and browse but not call.
    -- 实际效果是存在一个“一格信号区”：能发短信和浏览，但不能打电话。
    Thresholds = {
        Text = 0.05,
        Call = 0.15,
        Data = 0.05,
    },

    -- Ascending cutoffs mapping level to the 0..4 status bar bars. Bar count is how many
    -- cutoffs the level reaches, so anything under the first shows no bars at all. Keep the
    -- first entry equal to Thresholds.Text: a phone that cannot manage a text should not be
    -- claiming a bar.
    -- 把信号等级映射到 0..4 格状态栏的递增临界点。格数是等级达到的临界点数量，
    -- 因此低于第一个临界点时完全不显示格。请保持第一个条目等于
    -- Thresholds.Text：连短信都发不出的手机不该显示有信号。
    Bars = { 0.05, 0.25, 0.50, 0.75 },

    -- App namespaces that keep working on no signal whatsoever. Everything not listed needs
    -- Thresholds.Data, so an app added later is covered by default.
    -- 在完全没有信号时仍可工作的应用命名空间。未列出的一切都需要
    -- Thresholds.Data，因此以后新增的应用默认受数据门槛保护。
    --
    -- contacts, messages and call are here because reading your phone book and threads is
    -- on-device behaviour: they stay readable in a dead zone and it is the SEND that fails,
    -- refused server-side against Thresholds.Text and Thresholds.Call. Leaving `call` out would
    -- also block hangup and decline, stranding a player whose signal drops mid-call in a session
    -- they cannot end. radio is RF, not cellular. payphone is a landline, and being reachable on
    -- one in a dead zone is the entire point of it. voice carries both the voice memo library
    -- and the peer signalling a live call's audio runs on, so gating it would connect calls that
    -- nobody can hear. cookie is a single-player clicker whose save is the player's own
    -- progress; refusing it would lose their clicks rather than tell them anything useful.
    -- contacts、messages 和 call 在这里，因为读取通讯录和会话是设备本地行为：
    -- 在盲区仍可阅读，失败的是“发送”，由服务端按 Thresholds.Text 和
    -- Thresholds.Call 拒绝。如果不包含 `call`，挂断和拒接也会被挡住，信号中途
    -- 消失的玩家会困在一个无法结束的通话里。radio 是射频，不是蜂窝。payphone
    -- 是固话，在盲区能用公用电话被联系到正是它的全部意义。voice 同时承载语音
    -- 备忘录库和实时通话音频所用的对等信令，限制它会接通没人听得见的通话。
    -- cookie 是单机点击游戏，存档就是玩家自己的进度；拒绝它只会让点击白给，
    -- 提供不了任何有用提示。
    Offline = {
        'settings', 'phone', 'apps', 'sim', 'admin', 'badges', 'compat',
        'notes', 'documents', 'photos', 'albums', 'music', 'clock', 'voice',
        'contacts', 'call', 'calls', 'messages', 'payphone', 'share', 'airshare',
        'radio', 'cookie', 'medical',
    },

    -- Single actions that need Thresholds.Data even though the app around them is offline-safe,
    -- written as '<app>:<action>'. These win over the Offline list above.
    -- 虽然所属应用离线可用、但单个操作仍需要 Thresholds.Data 的动作，写作
    -- '<应用>:<动作>'。这些优先于上面的 Offline 列表。
    --
    -- Downloading an app really is a download, while the rest of the App Store is the phone's own
    -- state: the catalogue, the home layout and deleting something already on the device all keep
    -- working with no signal, which is how a real phone behaves.
    -- 下载应用确实是下载，而应用商店的其余部分是手机自己的状态：目录、主屏幕
    -- 布局和删除设备上已有的内容在无信号时都继续可用，真实手机就是这样。
    --
    -- A Medical ID is emergency information about the person holding the phone, so reading and
    -- editing your own card is device behaviour and stays available in a dead zone. Looking up
    -- someone ELSE's from the medical terminal is a remote record read, so it is gated.
    -- 医疗急救卡是持机者本人的紧急信息，因此阅读和编辑自己的卡片是设备行为，
    -- 在盲区仍可用。从医疗终端查询“别人”的卡片是远程记录读取，因此受门槛限制。
    Gated = {
        'apps:install',
        'medical:lookup',
    },

    -- Reads whose last good answer is kept, so a data app in a dead zone shows what it was
    -- showing before the signal went instead of an empty "nothing here yet" screen. The cache is
    -- per phone session and is replaced by the real answer the moment coverage returns.
    -- 保留上次成功结果的读取操作，这样盲区里的数据应用显示信号消失前的内容，
    -- 而不是空白的“这里还没有东西”屏幕。缓存按手机会话保存，覆盖恢复的瞬间
    -- 就会被真实结果替换。
    --
    -- ONLY EVER LIST READS HERE. An action that changes something must not be cached: replaying
    -- its old success would tell the player their post went out when it never left the phone.
    -- Posting, liking, sending and buying all still fail in a dead zone, which is correct.
    -- 这里只能列“读取”操作。会改变东西的动作绝不能缓存：重放它过去的成功会
    -- 让玩家以为帖子发出去了，而实际上根本没离开手机。发帖、点赞、发送和购买
    -- 在盲区仍然失败，这是正确的。
    Cached = {
        -- Squawk 微博
        'birdy:me', 'birdy:feed', 'birdy:profile', 'birdy:profilePosts', 'birdy:notifications',
        'birdy:notificationCount', 'birdy:trending', 'birdy:hashtag', 'birdy:followList',
        'birdy:dmList', 'birdy:dmThread',
        -- Photogram 照片社交
        'photogram:feed', 'photogram:explore', 'photogram:profile', 'photogram:profilePosts',
        'photogram:saved', 'photogram:comments', 'photogram:stories', 'photogram:activity',
        'photogram:counts', 'photogram:followList', 'photogram:followRequests',
        'photogram:dmList', 'photogram:dmThread',
        -- Vibez 短视频
        'vibez:feed', 'vibez:discover', 'vibez:profile', 'vibez:profilePosts', 'vibez:likedPosts',
        'vibez:savedPosts', 'vibez:comments', 'vibez:activity', 'vibez:counts', 'vibez:followList',
        -- Everything else that opens onto a list 其他打开就是列表的内容
        'mail:list', 'mail:savedEmails', 'darkchat:rooms', 'darkchat:notifications',
        'cherry:state', 'cherry:thread', 'marketplace:list', 'pages:list',
        'weazelnews:feed', 'weazelnews:view', 'stocks:market',
        'banking:overview', 'garages:list', 'homes:list', 'services:directory', 'services:inbox',
        'ryde:history', 'ryde:leaderboard',
        -- Police terminal. Reads only, and `mdt` is deliberately absent from Offline above: a
        -- terminal with no signal must refuse rather than pretend, and a stale record is still
        -- better than a blank pane on a patrol that clips a dead zone.
        -- 警务终端。只读操作，且 `mdt` 有意不在上面的 Offline 中：无信号的终端
        -- 必须拒绝而不是假装，但对擦过盲区的巡逻来说，旧记录仍好过空白面板。
        'mdt:bootstrap', 'mdt:home', 'mdt:persons:search', 'mdt:persons:get',
        'mdt:vehicles:search', 'mdt:vehicles:get', 'mdt:reports:list', 'mdt:reports:get',
        'mdt:cases:list', 'mdt:cases:get', 'mdt:warrants:list', 'mdt:offences:list',
        'mdt:roster:list', 'mdt:logs:list',
    },
}
