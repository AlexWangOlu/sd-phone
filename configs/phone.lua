-- Phone open / close behaviour.
-- 手机打开 / 关闭的行为设置。
return {
    -- Inventory items that open the phone when used. Each entry maps an item
    -- name to a frame colour; that colour drives both the on-screen rail and
    -- the prop model held in hand (PropPrefix .. colour). Add variants by
    -- shipping the matching `sd_phone_<colour>` prop and listing it here.
    -- Order matters: the keybind opens the first owned variant when the
    -- last-used one isn't held. Set to {} to disable item-based opening.
    -- 使用后能打开手机的背包物品。每个条目把物品名映射到一种机身颜色；该颜色
    -- 同时决定屏幕侧边光条和手持道具模型（PropPrefix .. 颜色）。要新增款式，
    -- 需放入对应的 `sd_phone_<颜色>` 道具模型并在这里列出。顺序有影响：当
    -- 上次使用的款式不在背包时，按键打开拥有的第一个款式。设为 {} 可禁用
    -- 基于物品的打开方式。
    Items = {
        { item = 'phone_black',  color = 'black'  },
        { item = 'phone_blue',   color = 'blue'   },
        { item = 'phone_green',  color = 'green'  },
        { item = 'phone_orange', color = 'orange' },
        { item = 'phone_pink',   color = 'pink'   },
        { item = 'phone_purple', color = 'purple' },
        { item = 'phone_red',    color = 'red'    },
        { item = 'phone_yellow', color = 'yellow' },
    },

    -- ESX only. ESX keeps its item catalogue in the `items` database table and
    -- nowhere else: an item missing from it can never be given or used, which
    -- is why a stock ESX install had the phone registered, givable in theory
    -- and impossible to open in practice. On boot, sd-phone adds any of the
    -- items above that the table doesn't already have, then refreshes ESX's
    -- in-memory catalogue so they work without a restart.
    -- 仅 ESX。ESX 的物品目录只保存在数据库 `items` 表中：表里没有的物品永远
    -- 无法发放或使用，这就是为什么原版 ESX 安装里手机虽然注册了、理论上能给
    -- 但实际上打不开。启动时 sd-phone 会把上表中 `items` 表缺少的物品补充
    -- 进去，然后刷新 ESX 内存目录，无需重启即可使用。
    --
    -- Runs only on ESX AND only when no dedicated inventory resource
    -- (ox_inventory, qs, tgiann, codem...) is started - those own their own
    -- item lists, where you add the items yourself. Nothing is ever
    -- overwritten: existing rows are left exactly as they are. Set false to
    -- manage the rows yourself (sql/esx_items.sql has them ready to import).
    -- 仅在 ESX 且没有启动专用背包资源（ox_inventory、qs、tgiann、codem
    -- 等）时运行 - 这些资源有自己的物品表，需要你自行添加物品。永远不会
    -- 覆盖任何内容：已有行保持原样。设为 false 可自行管理这些行
    -- （sql/esx_items.sql 已准备好可直接导入）。
    SeedEsxItems = true,

    -- Each Items entry may also carry `label` and `weight`, used only by the
    -- seeder above when it creates a row. Both default sensibly (the label
    -- from the colour, the weight to ESX's own default of 1), so set them only
    -- to override:
    -- 每个 Items 条目还可以带 `label` 和 `weight`，仅在上面的播种器创建行时
    -- 使用。两者都有合理默认值（label 由颜色生成，weight 用 ESX 默认的 1），
    -- 仅在需要覆盖时设置：
    --   { item = 'phone_black', color = 'black', label = 'iFruit', weight = 2 },

    -- Frame colour the phone opens with before any item has been used this
    -- session (the keybind fallback). Must be one of the frame colours.
    -- 本次会话还未使用任何手机物品时，按键打开手机所用的机身颜色（按键
    -- 兜底）。必须是上面的机身颜色之一。
    DefaultColor = 'black',

    -- Phone numbers: how long a new one is, and how numbers are displayed.
    -- Numbers are always STORED as bare digits, so this changes presentation and
    -- generation only - no database column, contact, message or call log is
    -- rewritten, and every lookup keeps matching on digits.
    -- 手机号码：新号码的长度以及号码的显示方式。号码始终以纯数字存储，因此
    -- 这里只改变显示和生成 - 不会重写任何数据库列、联系人、短信或通话记录，
    -- 所有查找仍按数字匹配。
    Number = {
        -- Digits in a NEWLY generated number. Changing it leaves every existing
        -- number exactly as it is, so a running server ends up with a mix of
        -- lengths, and both keep working everywhere.
        -- 新生成号码的位数。修改后已有号码完全不变，因此运行中的服务器会
        -- 出现长短不一的号码混合，且两者在所有地方都正常工作。
        Length = 10,

        -- Area code for new numbers, blank by default. It is part of Length
        -- rather than added to it: '555' with Length 10 gives 555 plus 7 random
        -- digits, so 5551234567. Formats below are unaffected.
        -- 新号码的区号，默认为空。它包含在 Length 之内而不是额外追加：
        -- Length 为 10 时填 '555' 会得到 555 加 7 位随机数字，即
        -- 5551234567。不影响下面的显示格式。
        --
        -- It cannot start with 0 or 1 and must leave 4 digits random; break
        -- either rule and it is ignored, with the reason printed on boot.
        -- 区号不能以 0 或 1 开头，且必须留出 4 位随机数字；违反任一规则会
        -- 被忽略，并在启动时打印原因。
        Prefix = '',

        -- How a number is displayed, keyed by how many digits it has. Each X is
        -- replaced by the next digit and every other character is printed
        -- literally, so '+44 XXXX XXXXXX', 'XXX-XXXX' and '(XXX) XXX-XXXX' all
        -- work. A digit count with no entry is shown as bare digits.
        -- 号码的显示格式，按号码位数索引。每个 X 会被下一位数字替换，其他
        -- 字符原样显示，因此 '+44 XXXX XXXXXX'、'XXX-XXXX' 和
        -- '(XXX) XXX-XXXX' 都可以。没有对应条目的位数则显示纯数字。
        --
        -- The table is keyed by length precisely so a Length change is safe:
        -- add an entry for the new length and KEEP the old one, and numbers
        -- already in circulation still read properly next to the new ones.
        -- 该表按位数索引，正是为了让修改 Length 更安全：为新长度添加条目并
        -- 保留旧条目，已在流通的号码和新号码都能正确显示。
        Formats = {
            [10] = '(XXX) XXX-XXXX',

            -- An 11-digit entry sits alongside it quite happily, which is what
            -- keeps numbers readable either side of a Length change. This one
            -- renders 12075550123 as +1 (207) 555-0123.
            -- 11 位的条目可以和上面的和平共存，这样 Length 改动前后的号码
            -- 都可读。这个格式会把 12075550123 显示为 +1 (207) 555-0123。
            -- [11] = '+X (XXX) XXX-XXXX',
        },

        -- Custom numbers handed out by hand: phoneadmin's "Change phone number"
        -- and the setSimNumber export (the hook for a paid "vanity number"
        -- script). Those normally accept only Length and the Formats lengths
        -- above, which catches an admin typo. This range accepts every digit
        -- count inside it as well, so a premium player can be given a 2 or 3
        -- digit number while everyone else keeps getting Length digits.
        -- 手动发放的自定义号码：phoneadmin 的"更改手机号"和 setSimNumber
        -- 导出（付费"靓号"脚本的挂钩点）。它们通常只接受 Length 和上面
        -- Formats 中的位数，这能挡住管理员手滑。这个范围额外接受区间内的
        -- 任意位数，这样可以给付费玩家发 2 位或 3 位号码，而其他玩家仍然
        -- 拿到 Length 位号码。
        --
        -- Generated numbers never use it. It must sit inside 2 to 15, a custom
        -- number cannot start with 0, and a company or emergency line (911) is
        -- refused because the dialler resolves those ahead of player numbers.
        -- Set it to nil to accept only the lengths above.
        -- 生成的号码永远不会用到它。范围必须在 2 到 15 之间，自定义号码
        -- 不能以 0 开头，公司或紧急线路（911）会被拒绝，因为拨号器会先于
        -- 玩家号码解析它们。设为 nil 则只接受上面的位数。
        Custom = { MinLength = 2, MaxLength = 3 },
    },

    -- Default keybind to open / close the phone. Players can rebind
    -- via FiveM's keybinding menu (Settings → Key Bindings → FiveM).
    -- 打开 / 关闭手机的默认按键。玩家可在 FiveM 按键绑定菜单中自行改键
    -- （设置 → 键位绑定 → FiveM）。
    Keybind  = 'F1',

    -- Hide the phone while the player is dead, swimming, in water,
    -- or carrying a two-handed weapon. The phone is still openable
    -- otherwise - these are just safety blocks against use-on-floor
    -- exploits.
    -- 玩家死亡、游泳、在水中或手持双手武器时隐藏手机。其他情况下手机
    -- 仍可打开 - 这些只是防止"倒地还能用手机"漏洞的安全限制。
    BlockWhileDead     = true,
    BlockWhileSwimming = true,

    -- Take the phone away while the player is restrained or incapacitated. These read the
    -- FRAMEWORK's state rather than the ped's: someone bleeding out or in last stand is still a
    -- live ped, so BlockWhileDead above (an engine-level IsEntityDead check) misses the window
    -- they actually spend on the floor waiting for EMS.
    -- 玩家被束缚或失去行动能力时没收手机。这些读取的是框架状态而不是 ped
    -- 状态：正在流血或濒死的人仍然是活着的 ped，所以上面的 BlockWhileDead
    -- （引擎层 IsEntityDead 检查）覆盖不到他们实际倒地等待急救的那段时间。
    --
    -- Cuffs have no agreed source, so the check reads the common state bags, the framework
    -- metadata and the native, which covers cuff scripts that only write one of them.
    -- 手铐没有统一的数据来源，因此检查会读取常见的 state bag、框架元数据和
    -- 原生函数，覆盖只写其中之一的手铐脚本。
    --
    -- Both close a phone that is ALREADY open too, since gating only the open would be sidestepped
    -- by opening the phone first and being cuffed after.
    -- 两者也会关闭已经打开的手机，因为如果只限制打开操作，先开手机再被铐
    -- 就能绕过。
    BlockWhileCuffed   = true,
    BlockWhileDowned   = true,

    -- Whether an incoming call throws the whole phone onto the screen. Off, a
    -- ringing phone shows the same closed-shell banner an alarm does, naming
    -- the caller, and the player opens their phone when they want to answer.
    -- On, the call screen takes over the moment the phone rings, which is how
    -- this behaved before the banner existed.
    -- 来电时是否把整个手机界面弹到屏幕上。关闭时，响铃的手机显示和闹钟一样
    -- 的合盖横幅、显示来电者名字，玩家想接听时再打开手机。开启时，手机一响
    -- 通话界面就立刻接管屏幕（横幅出现前的旧行为）。
    OpenOnIncomingCall = false,

    -- The boot animation: your logo over a lit backdrop, played once when the
    -- resource starts and the player first opens their phone, never on ordinary
    -- opens after that. Off by default so an untouched install goes straight to
    -- the lockscreen; set true to turn it on. Players who pick No Motion in
    -- Accessibility never see it either way.
    -- 开机动画：资源启动后玩家第一次打开手机时，在点亮的背景上播放一次你的
    -- logo，之后普通打开不再播放。默认关闭，未修改的安装直接进入锁屏；设为
    -- true 开启。在辅助功能中选择"减弱动态效果"的玩家无论如何都看不到。
    BootScreen = false,

    -- Let the player walk around while the phone is open (the game keeps
    -- receiving input alongside the UI). Mouse-look, aiming, firing, melee and
    -- weapon switching are suppressed so the mouse only drives the on-screen
    -- cursor; focusing a text field briefly hands full control back to the UI so
    -- typing WASD in a search box doesn't move you. Set false to freeze the
    -- player while the phone is out (the classic behaviour).
    -- 手机打开时允许玩家走动（游戏继续接收输入）。鼠标视角、瞄准、射击、近战
    -- 和切换武器会被屏蔽，鼠标只驱动屏幕光标；聚焦文本框时会短暂把完全控制
    -- 交回 UI，这样在搜索框里打 WASD 不会让角色移动。设为 false 则手机拿出
    -- 时冻结玩家（经典行为）。
    AllowMovement = true,

    -- Keep that movement alive while the Camera app's viewfinder owns the
    -- screen. The mouse still drives the on-screen controls (shutter, zoom,
    -- mode strip), so aim the lens by holding LookKeybind, or by pressing Left
    -- Alt to hand the mouse over until you press it again. Set false to freeze
    -- the player while framing a shot. Needs AllowMovement.
    -- 相机应用的取景器占据屏幕时仍保留移动。鼠标仍驱动屏幕控件（快门、变焦、
    -- 模式条），因此按住 LookKeybind 来转动镜头，或按一下左 Alt 把鼠标交给
    -- 游戏视角（再按一下收回）。设为 false 则取景时冻结玩家。需要
    -- AllowMovement 开启。
    AllowMovementInCamera = true,

    -- The same, for a video call. The mouse keeps driving the call
    -- buttons, so hold LookKeybind to steer while you walk. Set false to freeze
    -- the player for the length of the video call. Needs AllowMovement.
    -- 视频通话时同理。鼠标继续驱动通话按钮，所以走动时按住 LookKeybind
    -- 转向。设为 false 则整个视频通话期间冻结玩家。需要 AllowMovement。
    AllowMovementInVideoCall = true,

    -- Video calls send the picture peer-to-peer over WebRTC; the call audio stays on your voice
    -- resource. Public STUN is always used, which is enough when both players share a network.
    -- A TURN relay is what carries the picture between players on different home connections.
    -- Without one they get a connected call with a black picture, while their own self-view
    -- still looks fine, because the self-view never leaves their machine.
    -- 视频通话画面通过 WebRTC 点对点传输；通话音频仍走你的语音资源。始终使用
    -- 公共 STUN，双方在同一网络内时足够。TURN 中继负责在不同家庭网络的玩家
    -- 之间转发画面。没有 TURN，通话能接通但画面是黑的，而自己的预览画面正常，
    -- 因为自拍画面从不离开本机。
    --
    -- TURN is only for video calls and nearby-voice capture, the two things that talk browser to
    -- browser. Live broadcasts and MDT bodycams do NOT need it: Live sends its picture through the
    -- game server, and a bodycam is drawn on the watching terminal itself.
    -- TURN 只用于视频通话和附近语音采集这两个浏览器对浏览器的场景。直播和
    -- MDT 随身摄像头不需要它：直播画面通过游戏服务器传输，而随身摄像头画面
    -- 在观看终端本地绘制。
    --
    -- Configure it once in configs/voice.lua; the free Cloudflare path is two convars:
    -- 在 configs/voice.lua 中配置一次即可；免费的 Cloudflare 方案只需两个 convar：
    --     set sd_cf_turn_token_id  "your-cloudflare-turn-token-id"
    --     set sd_cf_turn_api_token "your-cloudflare-turn-api-token"
    --
    -- A fixed relay of your own (coturn, Metered) can be added for calls on top of that:
    -- 在此之上还可以为通话添加你自己的固定中继（coturn、Metered）：
    --     set sd_phone_turn_url        "turn:turn.example.com:3478"
    --     set sd_phone_turn_username   "your-username"
    --     set sd_phone_turn_credential "your-password"
    --
    -- Set this false to silence the boot warning if you deliberately run STUN-only.
    -- 如果你刻意只用 STUN，把这个设为 false 可关闭启动警告。
    WarnAboutTurn = true,

    -- Hold this key/button (while the phone is open) to free the mouse for
    -- camera rotation without closing the phone. Releasing it returns to the
    -- on-screen cursor. Combat stays suppressed, so you can look around but not
    -- shoot. Defaults to the first mouse side button (thumb button), which is
    -- almost never taken; Left Alt and the middle button are avoided because
    -- target scripts and camera zoom already use them. No side button on your
    -- mouse? Rebind it in FiveM's Key Bindings. Only active when AllowMovement
    -- is on.
    -- （手机打开时）按住这个键/按钮可以把鼠标从手机界面解放出来转动视角，
    -- 且不会关闭手机。松开后恢复为屏幕光标。战斗仍被屏蔽，所以只能环顾四周
    -- 不能开枪。默认为鼠标第一个侧键（拇指键），几乎不会被占用；避免使用左
    -- Alt 和中键，因为目标脚本和相机变焦已经在用它们。鼠标没有侧键？可在
    -- FiveM 按键绑定中改键。仅在 AllowMovement 开启时生效。
    LookKeybind = 'MOUSE_EXTRABTN1',

    -- Press this in SELFIE mode to move the camera instead of yourself: the lens
    -- then swings around you rather than turning you with it, so you can frame
    -- yourself from the side instead of head-on every time. Press again to go
    -- back to turning your character. Walking works either way; only the body's
    -- rotation is held. Does nothing on the outward lens, which frames the world.
    -- Defaults to the down arrow: the viewfinder already owns that cluster (up
    -- flips the lens, left and right change mode), every keyboard has one, and
    -- nothing else binds it. X is deliberately avoided because it is the
    -- hands-up key on most servers. Rebind it in FiveM's Key Bindings.
    -- 自拍模式下按这个键移动的是相机而不是你自己：镜头绕着你转，而不是带着
    -- 你一起转，这样就能从侧面取景而不是每次都正对自己。再按一次恢复为转动
    -- 角色。走路不受影响；只有身体转向被固定。对外置镜头（拍摄世界）无效。
    -- 默认为方向键下：取景器已经占用了那组键（上键翻转镜头、左右键切换
    -- 模式），每个键盘都有，且没有其他功能绑定它。刻意避免 X 键，因为多数
    -- 服务器 X 是举手键。可在 FiveM 按键绑定中改键。
    CameraLockKeybind = 'DOWN',

    -- Press this in SELFIE mode to turn your character's head toward the lens,
    -- so an angled shot still has them looking at the camera instead of past it.
    -- Press again to let the head sit with the body. Defaults to right shift:
    -- every keyboard has one, left shift is sprint but right shift is almost
    -- never bound, and the viewfinder's arrow cluster is already spoken for.
    -- Rebind it in FiveM's Key Bindings.
    -- 自拍模式下按这个键让角色的头转向镜头，这样斜角拍摄时角色仍然看着相机
    -- 而不是看向别处。再按一次头部恢复跟随身体。默认为右 Shift：每个键盘都
    -- 有，左 Shift 是冲刺而右 Shift 几乎没被绑定，取景器的方向键组也已被
    -- 占用。可在 FiveM 按键绑定中改键。
    CameraFaceKeybind = 'RSHIFT',

    -- The keybind hints drawn over the game while the viewfinder is up.
    -- 取景器打开时绘制在游戏画面上的按键提示。
    CameraHints = {
        -- Show them at all. False hides the list entirely; the keys still work.
        -- 是否显示提示。false 完全隐藏提示列表；按键仍然有效。
        Enabled = true,

        -- Which screen corner they sit in: 'top-right', 'top-left',
        -- 'bottom-right' or 'bottom-left'. Anything else falls back to
        -- top-right. They align and slide in from whichever edge you pick.
        -- 提示位于屏幕哪个角：'top-right'（右上）、'top-left'（左上）、
        -- 'bottom-right'（右下）或 'bottom-left'（左下）。其他值回退到
        -- 右上角。提示会从所选边缘对齐滑入。
        Corner = 'top-right',

        -- 1 or 2 columns. Two fills the column nearest your chosen edge first
        -- and puts the overflow inboard of it, so the list reads outward-in.
        -- 1 列或 2 列。2 列时先填满靠近所选边缘的那一列，溢出部分放在靠内
        -- 一侧，因此列表从外向内阅读。
        Columns = 2,
    },

    -- Third-person "holding a phone" pose + prop, shown to other players while
    -- the phone is out. Looping upper-body anim so the player can still walk.
    -- The prop model is PropPrefix .. <frame colour> (e.g. sd_phone_red), so
    -- the phone in hand matches the variant you opened. These models are
    -- streamed by the sd-phone-props resource - ensure it's started, or no
    -- prop will attach (the phone itself still works).
    -- 手机拿出时向其他玩家展示的第三人称"手持手机"姿势和道具。使用循环上
    -- 半身动画，玩家仍可走动。道具模型为 PropPrefix .. <机身颜色>（如
    -- sd_phone_red），因此手里的手机与你打开的款式一致。这些模型由
    -- sd-phone-props 资源流式加载 - 请确保它已启动，否则不会附加道具
    -- （手机本身仍可正常使用）。
    HoldAnimation = true,
    AnimDict      = 'cellphone@',
    AnimName      = 'cellphone_text_read_base',

    -- Held for the whole of a call, in place of the reading anim above, so the ped puts the phone
    -- to their ear. Kept up after the phone is stowed: the call is still running, so the arm stays
    -- there rather than dropping the moment the UI closes.
    -- 整个通话期间保持，替代上面的看手机动画，让 ped 把手机举到耳边。手机
    -- 收起后动画仍保持：通话还在继续，所以手臂不会在 UI 关闭的瞬间放下。
    CallAnimDict  = 'cellphone@',
    CallAnimName  = 'cellphone_call_listen_base',
    PropPrefix    = 'sd_phone_',
    PropBone      = 28422,   -- SKEL_R_Hand 右手骨骼

    -- Fine-tune where the prop sits in the hand. The cellphone@ anim is
    -- authored so a phone welded to SKEL_R_Hand at zero offset/rotation lands
    -- in the texting grip (this is what npwd ships), so leave these at 0 unless
    -- a custom sd_phone_<colour> model has its origin off the grip point.
    -- 微调道具在手中的位置。cellphone@ 动画的设计使得以零偏移/零旋转焊接到
    -- SKEL_R_Hand 的手机正好落在发短信的握持位置（npwd 即如此），因此保持
    -- 为 0 即可，除非自定义 sd_phone_<颜色> 模型的原点偏离握持点。
    PropOffset = vec3(0.0, 0.0, 0.0),
    PropRot    = vec3(0.0, 0.0, 0.0),

    -- Where the prop sits while the Camera app is in LANDSCAPE mode. Landscape
    -- plays its own clip, which turns the wrist so the phone already lies on its
    -- side, so these match the portrait transform above: rolling the prop as well
    -- would turn it twice. Nudge them only if a custom model sits off the grip in
    -- that pose.
    -- 相机应用处于横屏模式时道具的位置。横屏播放自己的动画片段，会转动手腕
    -- 让手机已经侧躺，因此这些值与上面的竖屏变换一致：如果再旋转道具就等于
    -- 转了两次。仅当自定义模型在该姿势下偏离握持位置时才微调。
    PropLandscapeOffset = vec3(0.0, 0.0, 0.0),
    PropLandscapeRot    = vec3(0.0, 0.0, 0.0),

    -- Let other players see the phone in your hand. When true, your ped broadcasts a replicated
    -- statebag while the phone is out and every nearby client spawns its own LOCAL welded copy of
    -- the prop on your ped (the hold animation already replicates on its own). The prop is
    -- deliberately NOT a networked object, because a networked prop's ownership can migrate to
    -- another client whose sync then freezes it mid-hold. Set false to go back to local-only
    -- (only you see your own prop).
    -- 让其他玩家看到你手中的手机。开启后，手机拿出时你的 ped 会广播一个复制
    -- state bag，附近每个客户端在你 ped 上生成自己本地的焊接道具副本（持机
    -- 动画本身已自行复制）。该道具刻意不使用网络对象，因为网络道具的所有权
    -- 可能迁移到另一个客户端，其同步会让道具在握持中冻结。设为 false 恢复为
    -- 仅本地可见（只有你自己看得到道具）。
    PropVisibleToOthers = true,

    -- Let nearby players HEAR your phone ring. Your ringtone is played by each nearby player's own
    -- phone UI at a volume set by how far away they are, so no audio is streamed and no extra
    -- resource is needed: every client already has the bundled ringtones in its build.
    -- 让附近玩家听到你的手机铃声。铃声由附近每个玩家自己的手机 UI 播放，音量
    -- 取决于距离，因此不串流音频、不需要额外资源：每个客户端的构建中已内置
    -- 这些铃声。
    --
    -- Only the eight bundled ringtones can be heard this way. A custom (YouTube) ringtone falls
    -- back to the default tone for bystanders, because those play through a shared player that the
    -- listener's own ringtone is already using.
    -- 只有内置的八个铃声能这样被听到。自定义（YouTube）铃声在旁人听来会回退
    -- 到默认铃声，因为自定义铃声通过共享播放器播放，而听者自己的铃声已经在
    -- 用那个播放器。
    AudibleRing = {
        Enabled = true,

        -- Metres at which the ring becomes inaudible. Falloff is squared, so it fades fast.
        -- 铃声变得听不见的距离（米）。衰减是平方级的，所以消失得很快。
        Range = 15.0,

        -- Loudest a nearby ring can get (0-1), reached only right next to the ringing player.
        -- 附近铃声的最大音量（0-1），只有紧挨响铃玩家时才达到。
        Volume = 0.5,

        -- Multiplier applied when there's no line of sight to the ringing player, so a phone
        -- through a wall is muffled rather than as loud as one in the open. 1.0 disables it.
        -- 与响铃玩家之间没有视线时应用的倍率，这样隔墙的手机声会被闷住而不是
        -- 和露天一样响。1.0 为禁用。
        Occlusion = 0.35,

        -- Don't broadcast a ring from a phone whose owner has Do Not Disturb on. Their own phone
        -- stays silent for them, so it stays silent for the street too.
        -- 机主开启了"勿扰模式"的手机不广播铃声。他们自己听不到，街上也一样
        -- 听不到。
        RespectDnd = true,
    },

    -- Flashlight beam emitted forward from the phone (lockscreen torch button).
    -- A spotlight cast from the player's hand in the direction they're looking.
    -- 手机向前发出的手电筒光束（锁屏的手电按钮）。从玩家手中朝视线方向投射
    -- 的聚光灯。
    Flashlight = {
        Color      = { 255, 244, 224 },   -- warm white 暖白色
        Distance   = 30.0,
        Brightness = 1.4,
        Radius     = 12.0,
    },
}
