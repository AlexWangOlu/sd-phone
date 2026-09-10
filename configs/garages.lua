-- Garages app - reads the player's owned vehicles from whichever garage system
-- is running and shows them (location, stored/out, fuel/engine/body, etc.).
-- Read-only apart from Valet below, which is the one path that takes a vehicle
-- out of its garage; with Valet.Enabled = false nothing here ever writes.
-- 车库应用 - 从正在运行的车库系统读取玩家拥有的车辆并展示（位置、存放中/
-- 已取出、油量/引擎/车身等）。除下面的“代客泊车”外全部只读，代客泊车是
-- 唯一把车从车库取出的途径；Valet.Enabled = false 时这里不会写入任何数据。
return {
    Enabled = true,

    -- 'auto' picks the first started resource from the list below. Override
    -- with an exact resource name if auto-detect guesses wrong (e.g. you run
    -- two garage resources side by side). Nearly all supported systems persist
    -- owned vehicles in the framework table (`player_vehicles` on QB/QBox,
    -- `owned_vehicles` on ESX); only the garage-name + state columns differ,
    -- so the bridge resolves those defensively (see bridge profiles).
    -- 'auto' 从下面的列表中选择第一个已启动的资源。自动检测猜错时（例如
    -- 同时运行两个车库资源），用确切资源名覆盖。几乎所有受支持的系统都把
    -- 拥有车辆存在框架数据表中（QB/QBox 为 `player_vehicles`，ESX 为
    -- `owned_vehicles`）；只有车库名和状态列不同，因此桥接层会防御性地解析
    -- 它们（见桥接配置）。
    System  = 'auto',

    -- Resources checked, in priority order, when System = 'auto'. The first
    -- one that's `started` wins. Add custom/renamed resources here.
    -- ND_Core is last on purpose: on ND it owns the vehicles itself (`nd_vehicles`, with its own
    -- stored/impounded flags), so it is the fallback once no dedicated garage resource is running.
    -- ND keeps no garage-NAME column, so vehicles list with their status but without a location.
    -- System = 'auto' 时按优先级检查的资源，第一个 `started` 的生效。可在此
    -- 添加自定义/重命名的资源。
    -- ND_Core 有意放在最后：在 ND 上车辆由它自己拥有（`nd_vehicles`，带自己的
    -- 存放/扣押标记），因此它是没有专用车库资源运行时的回退。ND 没有车库名称列，
    -- 所以车辆会显示状态但没有位置。
    Resources = {
        'qs-advancedgarages', 'jg-advancedgarages', 'qbx_garages', 'qb-garages',
        'mt_garages', 'cd_garage', 'okokGarage', 'codem-garage', 'lunar_garage',
        'nc_garage', 'op_garages', 'aty_garage_v2', 'aty_garage', 'esx_garage',
        'kartik-garages', 'ND_Core',
    },

    -- Default for whether a real photo of each vehicle (matched by spawn name)
    -- shows in the list + detail view, instead of the plain coloured car icon.
    -- When AllowImageToggle is on this is just the starting value each player can
    -- override; when it's off this value is forced for everyone.
    -- 是否在列表和详情页显示每辆车的真实照片（按生成名称匹配），而不是纯色
    -- 汽车图标。AllowImageToggle 开启时这只是初始值，每个玩家可自行更改；
    -- 关闭时该值对所有人强制生效。
    ShowVehicleImages = true,

    -- Let players switch photos <-> icons from a button in the Garages app
    -- header. Each player's choice is remembered on their own device and
    -- survives relogs / restarts. Set false to hide the button and force
    -- ShowVehicleImages for everyone.
    -- 允许玩家在车库应用顶栏通过按钮切换照片 <-> 图标。每个玩家的选择保存在
    -- 自己设备上，重登/重启后保留。设为 false 隐藏按钮并对所有人强制使用
    -- ShowVehicleImages。
    AllowImageToggle = true,

    -- Where the photos come from. `{model}` is replaced with the lowercased
    -- spawn name. Defaults to the official FiveM image set (covers base + DLC
    -- vehicles); point it at your own CDN if you host your own. Any vehicle
    -- without a matching image (e.g. a custom add-on) falls back to the icon.
    -- 照片来源。`{model}` 会替换为小写的生成名称。默认为 FiveM 官方图集
    -- （覆盖本体 + DLC 车辆）；如果自己托管可指向你的 CDN。没有匹配图片的
    -- 车辆（如自定义模组车）回退为图标。
    VehicleImageUrl = 'https://docs.fivem.net/vehicles/{model}.webp',

    -- Let players pick one of their own Photos as a vehicle's picture, from the
    -- vehicle's detail page. The choice is saved per character and plate and
    -- shows in place of the stock photo, even for players who switched the app
    -- to icons. Only a photo already in that player's own Photos library is
    -- accepted, so no outside URL can be stored. Set false to hide the option.
    -- 允许玩家在车辆详情页从自己的照片中选一张作为车辆图片。该选择按角色和
    -- 车牌保存，并显示在官方照片的位置，即使玩家把应用切换为图标模式也是
    -- 如此。只接受该玩家自己照片库中已有的照片，因此无法存储外部 URL。设为
    -- false 隐藏该选项。
    CustomImages = true,

    -- Garage waypoint coordinates - used as a FALLBACK. The app first auto-reads
    -- a garage's coords from the running system's own export, so these systems
    -- need NO setup: qs-advancedgarages, qbx_garages, qb-garages,
    -- jg-advancedgarages, cd_garage, op-garages. ATY and mt_garages publish no
    -- export, so their garages are discovered instead - aty_garage from its own
    -- config file, aty_garage_v2 and mt_garages from the table their in-game
    -- creator writes - and they usually need no setup either; run `garagediag`
    -- to see whether it resolved. Only systems without a usable
    -- export (esx, codem, okok, nc, lunar) need entries here, plus any garage a
    -- player built themselves in qs-advancedgarages (those live in
    -- `player_garages`, not the config): key by the exact Location TEXT a
    -- stored OR impounded vehicle shows (open one and copy it - e.g. a garage name, or
    -- 'Impound' to mark the impound lot) and map it to a vec2(x, y). Locations
    -- left out (and vehicles out on the street) simply don't get a button.
    -- 车库路点坐标 - 作为回退使用。应用会先从运行系统自己的导出自动读取车库
    -- 坐标，因此这些系统无需设置：qs-advancedgarages、qbx_garages、
    -- qb-garages、jg-advancedgarages、cd_garage、op-garages。ATY 和
    -- mt_garages 不提供导出，它们的车库改为被发现 - aty_garage 来自它自己的
    -- 配置文件，aty_garage_v2 和 mt_garages 来自游戏内创建器写入的数据表 -
    -- 通常也无需设置；运行 `garagediag` 可查看是否解析成功。只有没有可用
    -- 导出的系统（esx、codem、okok、nc、lunar）需要在此填写，此外还包括玩家
    -- 在 qs-advancedgarages 中自建的车库（那些在 `player_garages` 而非配置
    -- 中）：键用存放中或被扣车辆显示的确切位置文本（打开一辆车复制 - 例如
    -- 车库名，或用 'Impound' 标记扣押场），映射到 vec2(x, y)。未列出的位置
    -- （以及街上的车辆）只是没有导航按钮而已。
    Locations = {
        -- ['Legion Square Garage'] = vec2(215.8, -810.0),
        -- ['Mirror Park Garage']   = vec2(1135.0, -776.0),
        -- ['Impound']              = vec2(409.0, -1623.0),
    },

    -- Mileage is shown ONLY when `jg-vehiclemileage` is running - it's sourced
    -- from that resource's exports (getMileageByPlate) in its own configured
    -- unit. Without it, the mileage row is hidden entirely.
    -- 里程仅在运行 `jg-vehiclemileage` 时显示 - 数据来自该资源的导出
    -- （getMileageByPlate），使用其配置的单位。没有它时里程行完全隐藏。

    -- Valet: have a stored vehicle delivered to you from the app. This is the
    -- only feature that takes a car OUT of its garage, so it's off by default.
    -- The vehicle is spawned first and only marked out of the garage once it
    -- exists, so a failed delivery always leaves the car safely stored and
    -- refunds the fee. Impounded vehicles are never eligible (pay the impound),
    -- and neither are boats or aircraft.
    -- 代客泊车：从应用中让存放的车辆送到你面前。这是唯一把车取出车库的功能，
    -- 因此默认关闭。车辆会先生成，确认存在后才标记为出库，因此配送失败时车
    -- 始终安全存放并退还费用。被扣押的车辆不可用（请先付扣押费），船只和
    -- 飞行器也不可用。
    Valet = {
        Enabled = false,

        -- Charged on delivery, refunded if it fails. Account is 'bank' or 'cash'.
        -- 送达时扣费，失败退款。Account 为 'bank' 银行 或 'cash' 现金。
        Price   = 100,
        Account = 'bank',

        -- Seconds a player must wait between valets. 0 disables the cooldown.
        -- 玩家两次代客泊车之间必须等待的秒数。0 禁用冷却。
        Cooldown = 60,

        -- true  - a valet ped drives the car to you from DriveFrom metres away.
        -- false - the car simply appears at the nearest road spot to you.
        -- true  - 代客泊车 NPC 从 DriveFrom 米外把车开过来。
        -- false - 车直接出现在你最近的路边。
        Drive     = true,
        Ped       = 'S_M_Y_XMech_01',  -- 代客泊车 NPC 模型
        DriveFrom = 75,               -- 开过来的距离（米）

        -- Refuse while the player is already in a vehicle.
        -- 玩家已在载具中时拒绝。
        BlockInVehicle = true,

        -- Refuse for this many seconds after the player last took damage, so
        -- valet isn't a getaway button mid-chase. 0 disables it. NOTE: this one
        -- is reported by the player's own client and cannot be verified server
        -- side, so treat it as a courtesy guard, not as anti-cheat.
        -- 玩家上次受伤后多少秒内拒绝，避免代客泊车成为追逐中的逃脱按钮。
        -- 0 禁用。注意：这一项由玩家自己的客户端上报，服务端无法验证，因此
        -- 把它当作礼貌性防护，而不是反作弊。
        CombatBlock = 15,

        -- Areas where valet is refused, as { coords, radius, label }. The label
        -- is shown to the player when they're turned down.
        -- 拒绝代客泊车的区域，格式为 { 坐标, 半径, 标签 }。被拒绝时标签会
        -- 显示给玩家。
        BlockedZones = {
            -- { vec3(1690.0, 2560.0, 45.0), 200.0, 'Bolingbroke' },  博林布鲁克监狱
            -- { vec3(-1035.0, -2735.0, 20.0), 250.0, 'Airport' },    机场
        },
    },
}
