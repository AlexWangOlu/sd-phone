-- The phone's app catalog: dock, home wallpaper, and every app the phone knows about.
-- Per-app flags:
-- 手机的应用目录：Dock 栏、主屏幕壁纸，以及手机知道的每个应用。
-- 每个应用的标记：
--   base = true       ships installed and cannot be removed (never in the App Store)
--                     出厂已安装且不可移除（永不出现在应用商店）
--   enabled = false   the app does not exist on this server: hidden from the home screen
--                     and the App Store, uninstallable, and removed from phones that had it
--                     installed. Background work belonging to the app stops too: no ticks, no
--                     sweeps, no write-behind flushes. Its schema and stored data are left
--                     untouched, so switching it back on picks up where it left off.
--                     该应用在本服务器不存在：从主屏幕和应用商店隐藏、不可安装，
--                     并从已安装它的手机上移除。属于该应用的后台工作也会停止：
--                     没有定时任务、没有扫描、没有延迟写入刷盘。它的数据表结构和
--                     已存数据保持不动，因此重新开启会从上次中断处继续。
--   wifi = '<id>'     the app only downloads while the phone is on that Wi-Fi network, an `id`
--                     from configs/wifi.lua. The server re-checks the connection from its own
--                     coords, so the App Store dimming it is presentation only. Needs
--                     `base = false`, since it gates the download and a base app never downloads.
--                     该应用只有在手机连接指定 Wi-Fi 网络时才能下载，`<id>` 来自
--                     configs/wifi.lua。服务端会用自己的坐标重新检查连接，因此应用
--                     商店里把它变暗只是表现层。需要 `base = false`，因为它限制的是
--                     下载，而基础应用永不下载。
--   requires = {}     hide the app until this player clears a gate. Every condition must pass, the
--                     server answers them, and a hidden app's id never reaches the phone:
--                       item     = 'usb'            or { name = 'usb', count = 2, metadata = {...} }
--                       metadata = { vip = true }   framework player metadata
--                       jobs     = { police = 2 }   a name, an array, or name = minimum grade
--                       check    = 'res.export'     called as (source, appId); only true opens it
--                       consume  = true             using `item` unlocks it permanently instead
--                     Re-checked on every phone open and job change. A gate draws an icon - it
--                     authorises nothing, so gate the app's own callbacks server-side too.
--                     在玩家通过门槛前隐藏应用。每个条件都必须满足，由服务端判定，
--                     被隐藏应用的 id 绝不会发到手机：
--                       item     = 'usb'            或 { name = 'usb', count = 2, metadata = {...} }
--                       metadata = { vip = true }   框架玩家元数据
--                       jobs     = { police = 2 }   名称、数组，或 名称 = 最低职级
--                       check    = 'res.export'     以 (source, appId) 调用；只有返回 true 才开放
--                       consume  = true             使用 `item` 时永久解锁（消耗物品）
--                     每次打开手机和切换工作时重新检查。门槛只决定图标显示 - 它不
--                     授予任何权限，因此应用自己的回调也要在服务端做门槛判断。
--                     Full reference: https://docs.samueldev.shop/resources/phone/configuration
--                     完整参考文档：https://docs.samueldev.shop/resources/phone/configuration
return {
    -- Wallpaper name. Same registry as the lockscreen - see
    -- `web/src/wallpapers.ts`.
    -- 壁纸名称。与锁屏使用同一注册表 - 见 `web/src/wallpapers.ts`。
    Wallpaper = 'lockscreen.jpg',

    -- Apps shown in the dock (bottom row). Up to 4. App `id`s match
    -- the keys in `Apps` below - the icon, label, and route are
    -- looked up from there.
    -- Dock 栏（底部一行）显示的应用，最多 4 个。应用 `id` 与下面 `Apps` 中的
    -- 键对应 - 图标、名称和路由都从那里查找。
    Dock = { 'phone', 'messages', 'camera', 'photos' },

    -- Apps seeded onto page one of a BRAND-NEW phone before the rest spill onto page two. Once a
    -- player has arranged their own home screen theirs wins, so this only decides first impressions.
    -- 0 fills the page, and a value larger than the grid is clamped to it: a page holds 24 icons at
    -- the default icon size, 35 at the small one and 15 at the large, which each player picks in
    -- Settings, so the clamp is what keeps this honest across all three.
    -- 全新手机第一页预置的应用数，其余溢出到第二页。玩家一旦自行排列过主屏幕，
    -- 就以玩家的为准，因此这只决定第一印象。0 表示填满整页；大于网格容量的值会
    -- 被夹取：默认图标尺寸下一页放 24 个图标，小尺寸 35 个，大尺寸 15 个（每个
    -- 玩家在设置中选择），夹取保证了三种尺寸下都合理。
    FirstPageApps = 0,

    -- All apps. The homescreen renders every app whose `id` doesn't appear in
    -- `Dock` in a 4-column grid, in the order defined below. `route` is the SPA
    -- path the React app navigates to when the icon is tapped.
    -- `base = true` marks an app that ships with the phone (always installed,
    -- can't be removed). Apps without `base` are downloadable from the App Store
    -- and persisted per-character - see server/apps and phone_settings.installed_apps.
    -- `enabled = false` disables an app server-wide (see the header above).
    -- 所有应用。主屏幕把 `id` 未出现在 `Dock` 中的每个应用按下面定义的顺序以
    -- 4 列网格渲染。`route` 是点击图标时 React 应用导航到的 SPA 路径。
    -- `base = true` 标记手机自带应用（始终已安装、不可移除）。没有 `base` 的
    -- 应用可从应用商店下载并按角色持久化 - 见 server/apps 和
    -- phone_settings.installed_apps。`enabled = false` 在全服范围禁用应用
    -- （见上面的说明）。
    -- 注：label 为应用名称的英文后备值，实际显示名称由语言包 apps 命名空间
    -- 提供（中文语言包已包含），因此这里保持英文不动。
    Apps = {
        { id = 'phone', label = 'Phone', icon = 'phone', route = '/phone', accent = '#34c759', base = true, enabled = true },
        { id = 'messages', label = 'Messages', icon = 'messages', route = '/messages', accent = '#34c759', base = true, enabled = true },
        { id = 'mail', label = 'Mail', icon = 'mail', route = '/mail', accent = '#0a84ff', base = true, enabled = true },
        { id = 'maps', label = 'Maps', icon = 'maps', route = '/maps', accent = '#f0c43a', base = true, enabled = true },
        { id = 'compass', label = 'Compass', icon = 'compass', route = '/compass', accent = '#1c1c1e', base = true, enabled = true },
        { id = 'camera', label = 'Camera', icon = 'camera', route = '/camera', accent = '#1c1c1e', base = true, enabled = true },
        { id = 'photos', label = 'Photos', icon = 'photos', route = '/photos', accent = '#ffffff', base = true, enabled = true },
        { id = 'music', label = 'Music', icon = 'music', route = '/music', accent = '#fa233b', base = true, enabled = true },
        { id = 'weather', label = 'Weather', icon = 'weather', route = '/weather', accent = '#5ac8fa', base = true, enabled = true },
        { id = 'clock', label = 'Clock', icon = 'clock', route = '/clock', accent = '#1c1c1e', base = true, enabled = true },
        { id = 'calendar', label = 'Calendar', icon = 'calendar', route = '/calendar', accent = '#ffffff', base = true, enabled = true },
        { id = 'notes', label = 'Notes', icon = 'notes', route = '/notes', accent = '#fec547', base = true, enabled = true },
        { id = 'voicememos', label = 'Voice Memos', icon = 'voicememos', route = '/voicememos', accent = '#ff3b30', base = true, enabled = true },
        { id = 'bank', label = 'Bank', icon = 'bank', route = '/bank', accent = '#00b894', base = true, enabled = true },
        { id = 'health', label = 'Health', icon = 'health', route = '/health', accent = '#ff2d55', base = true, enabled = true },
        { id = 'documents', label = 'Files', icon = 'documents', route = '/documents', accent = '#3478F6', base = true, enabled = true },
        { id = 'id', label = 'ID', icon = 'id', route = '/id', accent = '#2C3440', base = true, enabled = true },
        { id = 'groups', label = 'Groups', icon = 'groups', route = '/groups', accent = '#6C63FF', base = false, enabled = true },
        { id = 'birdy', label = 'Squawk', icon = 'birdy', route = '/birdy', accent = '#1d9bf0', base = false, enabled = true },
        { id = 'services', label = 'Services', icon = 'services', route = '/services', accent = '#16B8A6', base = false, enabled = true },
        { id = 'pages', label = 'Pages', icon = 'pages', route = '/pages', accent = '#FBC02D', base = false, enabled = true },
        { id = 'marketplace', label = 'Marketplace', icon = 'marketplace', route = '/marketplace', accent = '#0a84ff', base = false, enabled = true },
        { id = 'darkchat', label = 'Dark Chat', icon = 'darkchat', route = '/darkchat', accent = '#1c1c1e', base = false, enabled = true },
        { id = 'cherry', label = 'Cherry', icon = 'cherry', route = '/cherry', accent = '#F0285A', base = false, enabled = true },
        { id = 'photogram', label = 'Photogram', icon = 'photogram', route = '/photogram', accent = '#D62976', base = false, enabled = true },
        { id = 'garages', label = 'Garages', icon = 'garages', route = '/garages', accent = '#6E5CF2', base = false, enabled = true },
        { id = 'homes', label = 'Homes', icon = 'homes', route = '/homes', accent = '#12B866', base = false, enabled = true },
        { id = 'ryde', label = 'Ryde', icon = 'ryde', route = '/ryde', accent = '#1c1c1e', base = false, enabled = true },
        { id = 'radio', label = 'Radio', icon = 'radio', route = '/radio', accent = '#30B0C7', base = false, enabled = true },
        { id = 'stocks', label = 'Stocks', icon = 'stocks', route = '/stocks', accent = '#16C784', base = false, enabled = false },
        { id = 'settings', label = 'Settings', icon = 'settings', route = '/settings', accent = '#8e8e93', base = true, enabled = true },
        { id = 'appstore', label = 'App Store', icon = 'appstore', route = '/appstore', accent = '#0a84ff', base = true, enabled = true },
        { id = 'calculator', label = 'Calculator', icon = 'calculator', route = '/calculator', accent = '#333335', base = true, enabled = true },
        { id = 'passwords', label = 'Passwords', icon = 'passwords', route = '/passwords', accent = '#1c1c1e', base = true, enabled = true },
        { id = 'cookie', label = 'Cookie', icon = 'cookie', route = '/cookie', accent = '#C77D2E', base = false, enabled = true },
        { id = 'wordle', label = 'Penta', icon = 'wordle', route = '/wordle', accent = '#6AAA64', base = false, enabled = true },
        { id = 'flappy', label = 'Flappy', icon = 'flappy', route = '/flappy', accent = '#4EC0CA', base = false, enabled = true },
        { id = 'blocks', label = 'Blocks', icon = 'blocks', route = '/blocks', accent = '#7C4DFF', base = false, enabled = true },
        { id = 'minesweeper', label = 'Minesweeper', icon = 'minesweeper', route = '/minesweeper', accent = '#E4483D', base = false, enabled = true },
        { id = 'casino', label = 'Casino', icon = 'casino', route = '/casino', accent = '#0F5132', base = false, enabled = true },
        { id = 'climber', label = 'Climber', icon = 'climber', route = '/climber', accent = '#8BC34A', base = false, enabled = true },
        { id = 'connectfour', label = 'Connect 4', icon = 'connectfour', route = '/connectfour', accent = '#1E66D0', base = false, enabled = true },
        { id = 'chess', label = 'Chess', icon = 'chess', route = '/chess', accent = '#3B3B3B', base = false, enabled = true },
        { id = 'battleship', label = 'Battleship', icon = 'battleship', route = '/battleship', accent = '#17A0B5', base = false, enabled = true },
        { id = 'vibez', label = 'Clout', icon = 'vibez', route = '/vibez', accent = '#A855F7', base = false, enabled = true },
        { id = 'weazelnews', label = 'Weazel News', icon = 'weazelnews', route = '/weazelnews', accent = '#C8102E', base = false, enabled = true },
        { id = 'streaks', label = 'Streaks', icon = 'streaks', route = '/streaks', accent = '#FF7A1A', base = false, enabled = true },

        -- The three terminals run on BOTH devices. The same code lays itself out per screen: a
        -- menu root that pushes one section at a time on the phone, the multi-tab browser on the
        -- tablet. This catalog is also what the tablet's ids validate against, so these rows are
        -- what let sd-tablet show them at all.
        -- 三个终端在两种设备上都能运行。同一套代码按屏幕自行布局：手机上是一次
        -- 推开一个分区的菜单根，平板上是多标签页浏览器。本目录也是平板 id 的校验
        -- 依据，因此这些行是 sd-tablet 能显示它们的前提。
        --
        -- `enabled = true` only says this SERVER has the terminals. Which of them a given player
        -- sees is decided per open by server/appgate.lua, from the departments in configs/mdt.lua:
        -- a `leo` department gets `mdt`, `ems` gets `emsmdt`, `doj` gets `dojmdt`, and anyone else
        -- gets no icon rather than one that refuses them. That gate is asked fresh on every open,
        -- by both devices, so a job change is picked up with no event to miss.
        -- `enabled = true` 只表示本服务器有这些终端。某个玩家能看到哪个，由
        -- server/appgate.lua 在每次打开时根据 configs/mdt.lua 中的部门决定：
        -- `leo` 部门得到 `mdt`，`ems` 得到 `emsmdt`，`doj` 得到 `dojmdt`，
        -- 其他人没有图标，而不是给一个会拒绝他们的图标。两种设备每次打开都会
        -- 重新询问该门槛，因此换工作会立即生效，不会漏掉任何事件。
        --
        -- `Enabled` in configs/mdt.lua outranks these rows and ships OFF, so all three are hidden
        -- everywhere and no terminal tables are built until you turn it on. Leaving these rows at
        -- `enabled = true` costs nothing while it is off.
        -- configs/mdt.lua 中的 `Enabled` 优先级高于这些行，且默认关闭，因此在你
        -- 开启之前，三个终端在各处都隐藏，也不会创建终端数据表。它关闭时把这些
        -- 行保持为 `enabled = true` 没有任何代价。
        --
        -- Keep `base = true`. The job gate is what hands a terminal out, so there is nothing to
        -- download; `base = false` would strand it behind an App Store entry instead.
        -- 请保持 `base = true`。工作门槛就是发放终端的方式，没有东西需要下载；
        -- `base = false` 反而会把它困在应用商店条目后面。
        { id = 'mdt', label = 'MDT', icon = 'mdt', route = '/mdt', accent = '#1D4ED8', base = true, enabled = true },
        { id = 'emsmdt', label = 'EMS', icon = 'emsmdt', route = '/emsmdt', accent = '#E11D48', base = true, enabled = true },
        { id = 'dojmdt', label = 'DOJ', icon = 'dojmdt', route = '/dojmdt', accent = '#6D28D9', base = true, enabled = true },

        -- Racing runs on both devices too, and unlike the terminals it carries no job gate. Its
        -- backend has its own switch, `Enabled` in configs/racing.lua; with that off this row shows
        -- an app with nothing behind it, so turn both off together.
        -- 赛车应用也在两种设备上运行，与终端不同的是它没有工作门槛。它的后端有
        -- 自己的开关，即 configs/racing.lua 中的 `Enabled`；关闭后这一行会显示
        -- 一个背后什么都没有的应用，因此请把两者一起关闭。
        --
        -- It ships earned rather than given: `consume` means using a `racing_usb` spends the item
        -- and installs the board on that character for good. The item has to exist in your inventory
        -- config or nobody can unlock it - see the snippet in the header above, and drop `requires`
        -- entirely if you would rather every player just have it.
        -- 它默认需要赚取而不是直接赠送：`consume` 表示使用 `racing_usb` 会消耗该
        -- 物品并把赛车程序永久安装到该角色。该物品必须存在于你的背包配置中，否则
        -- 没人能解锁 - 见上面说明中的片段；如果你宁愿每个玩家直接拥有，把
        -- `requires` 整个删掉即可。
        { id = 'racing', label = 'Racing', icon = 'racing', route = '/racing', accent = '#0A8C72', base = true, enabled = true, requires = { item = 'racing_usb', consume = true } },

        -- `base = false` rows are the App Store's catalog; flip one to `true` to ship it installed
        -- instead. `wifi` only means anything on a downloadable row, since it gates the download:
        -- `base = false` 的行是应用商店的目录；把某行改为 `true` 即可让它出厂
        -- 已安装。`wifi` 只在可下载的行上有意义，因为它限制下载：
        -- { id = 'darkchat', label = 'Dark Chat', icon = 'darkchat', route = '/darkchat', accent = '#1c1c1e', base = false, enabled = true, wifi = 'mazebank' },

        -- `requires` examples, none of them live - copy the tail of one onto a real row.
        -- `requires` 示例，均未生效 - 把其中一条的尾部复制到真实行上。
        -- { id = 'darkchat', ..., requires = { item = 'burner_phone' } },
        -- { id = 'stocks',   ..., requires = { metadata = { vip = true } } },
        -- { id = 'mdt',      ..., requires = { jobs = { police = 3, ambulance = 0 } } },
        -- { id = 'darkchat', ..., requires = { check = 'myserver.canSeeDarkweb' } },
        -- { id = 'health',   ..., requires = { item = 'health_usb', consume = true } },

        -- A `consume` gate spends the item itself, so leave `consume = 0` on the ox_inventory entry
        -- and point it at the export the phone makes - `health_usb` becomes `sd-phone.useHealth_usb`:
        -- `consume` 门槛会消耗物品本身，因此 ox_inventory 条目上保持 `consume = 0`，
        -- 并把它指向手机提供的导出 - `health_usb` 对应 `sd-phone.useHealth_usb`：
        --   ['health_usb'] = { label = 'Medical Data Key', stack = false, close = true,
        --                      consume = 0, server = { export = 'sd-phone.useHealth_usb' } },
        -- With no `item` at all, hand it out yourself: exports['sd-phone']:unlockApp(source, appId).
        -- 完全不用 `item` 时，你可以自行发放：exports['sd-phone']:unlockApp(source, appId)。
    },
}
