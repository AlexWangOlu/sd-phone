-- Phones, numbers and who owns what. Pick your setup:
-- 手机、号码以及归属关系。选择你的模式：
--
--   Stock phone (shared data, automatic numbers)        -> Enabled = false   (DEFAULT)
--   原版手机（数据共享，自动分配号码）                   -> Enabled = false   （默认）
--   Unique phones, SIM cards carry the number           -> Enabled = true, DataOwner = 'device'
--   唯一手机，SIM 卡携带号码                             -> Enabled = true, DataOwner = 'device'
--   Unique phones, no SIM items (built-in numbers)      -> Enabled = true, DataOwner = 'device', BuiltInNumbers = true
--   唯一手机，无 SIM 物品（内置号码）                    -> Enabled = true, DataOwner = 'device', BuiltInNumbers = true
--   Stock data, SIMs only change your number            -> Enabled = true, DataOwner = 'character'
--   原版数据，SIM 仅更改号码                             -> Enabled = true, DataOwner = 'character'
--   The SIM IS the phone (original unique phones)       -> Enabled = true, DataOwner = 'sim'
--   SIM 即手机（原始版唯一手机）                         -> Enabled = true, DataOwner = 'sim'
--
-- When enabled, numbers come from sim_card items - or, with BuiltInNumbers, from the phone
-- itself (no SIM items at all). Who owns the DATA is DataOwner:
-- 启用后，号码来自 sim_card 物品 - 或者在 BuiltInNumbers 下来自手机本身（完全
-- 没有 SIM 物品）。谁拥有“数据”由 DataOwner 决定：
--
--   * DataOwner = 'device' (DEFAULT) - the PHONE owns the data, the SIM only lends a number.
--     Each phone item carries a persistent identity minted on first use, and that identity keys
--     everything (messages, contacts, photos, notes, settings, installed apps, games). Popping
--     a SIM out just drops your number/service: the phone still opens and every non-number app
--     keeps working. Moving a SIM to another phone hands that phone your NUMBER, not your data.
--   * DataOwner = 'device'（默认）- 手机拥有数据，SIM 只提供号码。每个手机物品
--     携带首次使用时生成的持久身份，该身份作为一切数据的键（消息、联系人、照片、
--     备忘、设置、已装应用、游戏）。取出 SIM 只会失去号码/服务：手机仍能打开，
--     所有非号码应用继续工作。把 SIM 换到另一部手机，交给对方的是你的“号码”，
--     不是你的数据。
--
--   * DataOwner = 'sim' (LEGACY) - the SIM owns the data. Whichever SIM sits in a phone
--     decides WHOSE phone data you see; steal a phone with its SIM and you read the owner's
--     phone. Without a SIM the phone opens to a "No SIM" screen with no service and every
--     server action refused. This is the original unique-phones behaviour, byte-for-byte.
--   * DataOwner = 'sim'（旧版）- SIM 拥有数据。手机里插着哪张 SIM，决定你看到
--     谁的手机数据；偷走插着 SIM 的手机就能看到机主的手机。没有 SIM 时手机打开
--     是“无 SIM”屏幕，无服务且所有服务端操作被拒绝。这是原始版唯一手机行为，
--     逐字节一致。
--
--   * DataOwner = 'character' - the STOCK data model with SIM numbers on top. Every phone
--     opens the holder's own character profile (a stolen phone shows the thief's data, never
--     the owner's), and without a SIM the character keeps a vanilla auto-assigned number with
--     full service. Installing a SIM changes ONLY the number; ejecting falls back to a fresh
--     auto number. Enabling this on an existing stock server keeps everyone's data untouched.
--   * DataOwner = 'character' - 在原版数据模型之上叠加 SIM 号码。每部手机打开
--     持有者自己的角色资料（偷来的手机显示小偷的数据，绝不显示机主的），没有
--     SIM 时角色保留原版自动分配的号码且服务完整。装入 SIM 只更改号码；弹出后
--     回退为新的自动号码。在现有原版服务器上启用此项不会动任何人的数据。
--
-- With 'device'/'sim' the number follows the SIM, and the Cloud Backup section in Settings
-- lets a player carry their data to a new phone (the number stays behind on the old SIM).
-- 在 'device'/'sim' 模式下号码跟随 SIM，设置中的“云备份”可让玩家把数据带到
-- 新手机（号码留在旧 SIM 上）。
--
-- Backend support: reading/writing per-slot item metadata is required. Supported out of the box:
-- 后端支持：需要按槽位读写物品元数据。开箱支持：
--   * ox_inventory                        (metadata mode, or the physical SIM-tray mode below)
--   * ox_inventory                        （元数据模式，或下面的实体 SIM 卡槽模式）
--   * one_inventory                       (metadata mode 元数据模式)
--   * qb-inventory / ps / lj              (metadata mode via the QBCore item `info` table 通过 QBCore 物品 `info` 表的元数据模式)
--   * qs(-pro) / tgiann / codem / origen  (metadata mode 元数据模式)
--   * jaksam                              (metadata mode 元数据模式)
-- Plain ESX inventory has no item metadata and cannot support this feature.
-- 原版 ESX 背包没有物品元数据，无法支持此功能。
return {
    -- Master switch. Off = sd-phone behaves exactly as before (numbers auto-assigned per
    -- character, phone always has service).
    -- 总开关。关闭 = sd-phone 行为与以前完全一致（号码按角色自动分配，手机始终
    -- 有服务）。
    Enabled = false,

    -- Where the phone DATA lives: 'device' | 'sim' | 'character' (see the header above).
    -- Flipping an existing 'sim' server to 'device' is safe: on first use each phone ADOPTS the
    -- identity of the SIM currently in it (grandfathering, no data copied or lost), and only
    -- from then on does the number float free of the data. (The pre-DataOwner boolean
    -- `DeviceIdentity` is still honoured when this key is absent.)
    -- 手机数据存放位置：'device' | 'sim' | 'character'（见上面的说明）。
    -- 把现有 'sim' 服务器改为 'device' 是安全的：首次使用时每部手机会“继承”
    -- 当前所插 SIM 的身份（老数据过渡，不复制也不丢失数据），从那以后号码才与
    -- 数据分离。（没有此键时，DataOwner 之前的布尔项 `DeviceIdentity` 仍然
    -- 有效。）
    DataOwner = 'sim',

    -- Unique phones WITHOUT SIM cards ("eSIM"): every phone mints its own permanent number the
    -- first time it is used - no sim_card item, no install/eject, the number lives and dies
    -- with the phone. Pairs with DataOwner 'device' or 'character' ('sim' has no SIM identity
    -- to own data and coerces to 'device'); forces the metadata attach mode. SimItem, SimTray,
    -- AllowEject, ActivateBlankSims and /givesim become inert.
    -- 没有 SIM 卡的唯一手机（“eSIM”）：每部手机首次使用时生成自己的永久号码 -
    -- 没有 sim_card 物品，没有装入/弹出，号码与手机同生共死。与 DataOwner
    -- 'device' 或 'character' 搭配（'sim' 没有拥有数据的 SIM 身份，会被强制转为
    -- 'device'）；强制使用元数据附着模式。SimItem、SimTray、AllowEject、
    -- ActivateBlankSims 和 /givesim 会失效。
    BuiltInNumbers = false,

    -- Inventory item that carries a phone number in its metadata ({ number = '2075550123' }).
    -- Sell or spawn it anywhere like a normal item: a blank card self-activates on first use.
    -- Add the item definition to your inventory (see README - "Unique Phones & SIM Cards").
    -- 在元数据中携带电话号码的背包物品（{ number = '2075550123' }）。像普通物品
    -- 一样在任何地方出售或生成：空白卡首次使用时自动激活。请把物品定义添加到
    -- 你的背包（见 README - “唯一手机与 SIM 卡”）。
    SimItem = 'sim_card',

    -- Using a blank sim_card (no number metadata - what shops, loot tables and admin spawns
    -- produce) mints and registers a fresh number on the spot, so selling SIMs needs no script
    -- integration at all. Turn off to refuse blank cards, so only /givesim and the giveSimCard
    -- export (character-bound or hardcoded numbers) produce usable SIMs.
    -- 使用空白 sim_card（没有号码元数据 - 商店、掉落表和管理员生成的都是这种）
    -- 会当场生成并注册一个新号码，因此出售 SIM 完全不需要脚本集成。关闭则拒绝
    -- 空白卡，只有 /givesim 和 giveSimCard 导出（绑定角色或硬编码号码）能产生
    -- 可用 SIM。
    ActivateBlankSims = true,

    -- ox_inventory only: give every phone item a 1-slot "SIM tray" instead of writing the number
    -- onto the phone item. Using the phone opens the phone UI as normal; the tray is a separate
    -- right-click button players drag the SIM in and out of. That button has to be declared on
    -- the phone item in ox_inventory/data/items.lua (see README - "Unique Phones & SIM Cards"):
    -- 仅 ox_inventory：给每个手机物品一个 1 格的“SIM 卡槽”，而不是把号码写在
    -- 手机物品上。使用手机照常打开手机界面；卡槽是一个独立的右键按钮，玩家把
    -- SIM 拖进拖出。该按钮必须在 ox_inventory/data/items.lua 的手机物品上声明
    -- （见 README - “唯一手机与 SIM 卡”）：
    --
    --   buttons = {
    --       { label = 'SIM Tray', action = function(slot) exports['sd-phone']:openSimTray(slot) end },
    --   },
    --
    -- Leave false for the universal metadata mode, where the SIM is installed by using the
    -- sim_card item and no inventory edit is needed.
    -- 保持 false 使用通用元数据模式：通过使用 sim_card 物品装入 SIM，无需修改
    -- 背包。
    --
    -- Renamed from `UseContainers`, which is still read when this key is absent. The old name
    -- described the ox item-container this used to be built on; trays are ox stashes now, because
    -- ox opens a container item on USE and that made the phone itself keybind-only.
    -- 由 `UseContainers` 改名而来，没有此键时仍读取旧名。旧名描述的是它过去
    -- 基于的 ox 物品容器；卡槽现在是 ox 仓库（stash），因为 ox 在“使用”容器
    -- 物品时会打开容器，导致手机本身只能靠按键打开。
    SimTray = false,

    -- Metadata mode only: allow ejecting the installed SIM from Settings -> SIM & Backup. The
    -- player gets the sim_card item back (number intact) and the phone loses service. In tray
    -- mode ejecting is physical (drag it out of the tray) and this flag is ignored.
    -- 仅元数据模式：允许从 设置 -> SIM 与备份 弹出已装入的 SIM。玩家拿回
    -- sim_card 物品（号码保留），手机失去服务。卡槽模式下弹出是物理操作
    -- （从卡槽拖出），此标记被忽略。
    AllowEject = true,

    -- Metadata mode only: number keys ANOTHER phone resource wrote onto the phone item, read as
    -- a fallback when the item carries no `simNumber` of its own. This is what lets a phone
    -- imported from another resource keep working the moment it is used, with no rewrite of
    -- anyone's inventory: the number is read where it already sits, and normalised onto
    -- `simNumber` the first time anything writes this phone's SIM. Add keys here if you migrated
    -- from a phone this list does not cover; emptying it strands imported phones on blank
    -- profiles, so leave it alone unless you know no such item exists on your server.
    -- 仅元数据模式：其他手机资源写在手机物品上的号码键，当物品没有自己的
    -- `simNumber` 时作为回退读取。这让从其他资源导入的手机一使用就能继续工作，
    -- 无需重写任何人的背包：号码在它原本所在的位置被读取，并在第一次有东西
    -- 写入这部手机的 SIM 时规范化到 `simNumber`。如果你从本列表未覆盖的手机
    -- 迁移，可在此添加键；清空它会让导入的手机困在空白资料上，因此除非你确认
    -- 服务器上不存在这种物品，否则不要动它。
    LegacyNumberKeys = { 'lbPhoneNumber' },

    -- Cloud Backup (Settings -> SIM & Backup). The backup account is the CHARACTER, so a SIM
    -- thief can never restore someone else's backup. Enabling it remembers which phone profile
    -- belongs to the character; restoring on a new SIM copies that profile's data (messages,
    -- contacts, photos, notes, settings, app logins, ...) onto the new SIM's profile. The old
    -- SIM keeps the old number and the data that was on it.
    -- 云备份（设置 -> SIM 与备份）。备份账户是“角色”，因此偷 SIM 的人永远无法
    -- 恢复别人的备份。启用后会记住哪个手机资料属于该角色；在新 SIM 上恢复会把
    -- 该资料的数据（消息、联系人、照片、备忘、设置、应用登录……）复制到新 SIM
    -- 的资料上。旧 SIM 保留旧号码和它上面的数据。
    Backup = {
        Enabled = true,

        -- How many phones one character can back up at once (each holds a full cloud snapshot).
        -- Enabling backup on another phone past the cap asks the player to delete one first.
        -- 一个角色同时可备份的手机数（每部保存一份完整云快照）。超过上限后再在
        -- 另一部手机上启用备份，会要求玩家先删除一个。
        MaxProfiles = 3,
    },
}
