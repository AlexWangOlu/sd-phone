-- Street payphones. ox_target on the phone-box props opens a standalone dial UI (no phone
-- needed, works for players without one). Each payphone location mints a persistent number on
-- first use, so the same booth always calls out from the same number. Other scripts can open
-- the UI anywhere via exports['sd-phone']:openPayphone().
-- 街头公用电话。对电话亭模型使用 ox_target 可打开独立的拨号界面（不需要手机，
-- 没有手机的玩家也能用）。每个公用电话位置在首次使用时生成一个持久号码，因此
-- 同一座电话亭总是用同一号码打出。其他脚本可通过
-- exports['sd-phone']:openPayphone() 在任意位置打开该界面。
return {
    -- Master switch: false removes the targets, callbacks and exports do nothing.
    -- 总开关：false 移除交互目标，回调和导出均不执行任何操作。
    Enabled = true,

    -- Console prints through the booth interaction/prop-swap path, for debugging.
    -- 控制台打印电话亭交互/模型替换流程的信息，用于调试。
    Debug = true,

    -- When true the callee sees a withheld caller ("Payphone") instead of the booth's number.
    -- 为 true 时，接听方看到隐藏来电者（“公用电话”）而不是电话亭号码。
    Anonymous = false,

    -- Caller name shown on the callee's incoming-call screen (their saved contacts still win).
    -- 接听方来电屏幕上显示的来电者名称（对方已保存的联系人仍优先）。
    CallerLabel = '公用电话',

    -- Prop models that get the ox_target interaction.
    -- 添加 ox_target 交互的模型。
    Models = {
        'prop_phonebox_01a',
        'prop_phonebox_01b',
        'prop_phonebox_01c',
        'prop_phonebox_02',
        'prop_phonebox_03',
        'prop_phonebox_04',
        'p_phonebox_01b_s',
    },

    -- ox_target interaction distance.
    -- ox_target 交互距离。
    TargetDistance = 1.5,

    -- Use ox_lib context menus + input dialog instead of the payphone UI page.
    -- 使用 ox_lib 上下文菜单 + 输入对话框代替公用电话 UI 页面。
    UseOxLibMenu = false,

    -- Coin-operated calling. When enabled, outbound calls demand a coin first:
    -- the LCD reads INSERT COIN, clicking the coin slot charges Cost from the
    -- player's Account and plays the coin-drop, then the keypad unlocks. The
    -- credit is consumed when a dial goes through; a failed dial (bad number,
    -- busy line) keeps it for another try, and answering an inbound ring is
    -- always free. The ox_lib menu flow charges automatically on dial instead.
    -- 投币通话。启用后，外拨电话需要先投币：液晶屏显示“请投币”，点击投币口
    -- 从玩家的 Account 扣除 Cost 并播放投币音效，随后键盘解锁。通话接通时
    -- 扣费；拨号失败（号码错误、占线）会保留余额供重试，接听来电始终免费。
    -- 使用 ox_lib 菜单流程时改为拨号时自动扣费。
    Coin = {
        Enabled = true,
        Cost = 1,         -- charged per coin 每枚硬币扣费金额
        Account = 'cash', -- framework account debited ('cash' or 'bank') 扣款的框架账户（'cash' 现金 或 'bank' 银行）
    },

    -- Show the player's favourite contacts on the payphone's notepad (needs their phone's
    -- contact list, so it's empty for players without a phone).
    -- 在公用电话的便签板上显示玩家收藏的联系人（需要其手机的联系人列表，因此
    -- 没有手机的玩家看到的是空的）。
    ShowFavorites = true,

    -- Area code the minted payphone numbers start with.
    -- 生成的公用电话号码开头的区号。
    NumberPrefix = '444',

    -- On-the-phone animation against the booth (Contract-DLC payphone scripted anims). Tweak
    -- the clips here if your game build names them differently.
    -- 对着电话亭打电话的动画（合约 DLC 的公用电话脚本动画）。如果你的游戏版本
    -- 对动画片段命名不同，可在此调整。
    Scene = {
        Enabled = true,
        Dict  = 'anim@scripted@payphone_hits@male@',
        Enter = 'fxfr_phl_1_intro_male',
        Idle  = 'fxfr_ptj_1_male',
        Exit  = 'exit_left_male',
        EnterProp = 'fxfr_pcn_1_intro_phone',
        -- Booth model -> animatable variant spawned in its place while the handset is lifted.
        -- The variant should look like the booth it replaces. The scripted clips are authored
        -- against these variants, so a model with NO entry here plays no scene at all: it still
        -- targets and dials normally, just without the animation. Add an entry to give a model
        -- the scene.
        -- 电话亭模型 -> 拿起听筒时在其位置生成的可动画变体。变体应当看起来像它
        -- 替换的电话亭。脚本动画片段是针对这些变体制作的，因此没有在此列出的
        -- 模型完全不会播放动画场景：仍可正常交互和拨号，只是没有动画。添加条目
        -- 即可为模型启用动画。
        -- Only map a booth to a variant that LOOKS like it. sf_prop_sf_phonebox_01b_s is the
        -- Contract-DLC animatable booth built on the 01b shell, so only the 01b family swaps
        -- cleanly; pointing 01a or 01c at it visibly changes the booth mid-call.
        -- 只能把电话亭映射到“看起来像它”的变体。sf_prop_sf_phonebox_01b_s 是基于
        -- 01b 外壳制作的合约 DLC 可动画电话亭，因此只有 01b 系列能干净替换；把
        -- 01a 或 01c 指向它会在通话中明显改变电话亭外观。
        AnimProps = {
            prop_phonebox_01b = 'sf_prop_sf_phonebox_01b_s',
            p_phonebox_01b_s  = 'sf_prop_sf_phonebox_01b_s',
        },
    },

    -- Inbound calls: dialing a booth's number rings the physical booth. Anyone nearby can pick
    -- up via the target's "Answer Phone".
    -- 来电：拨打某座电话亭的号码会让实体电话亭响铃。附近任何人都可通过交互目标
    -- 的“接听电话”接起。
    Inbound = {
        Enabled = true,
        -- How long the booth rings before the caller hears "no answer" (ms).
        -- 呼叫方听到“无人接听”前电话亭响铃的时长（毫秒）。
        RingTimeout = 30000,
        -- Sound played from the booth object while it rings. Remote_Ring is the
        -- dial-side ringback tone - use a Ringtone_* sound for an incoming ring.
        -- 响铃时从电话亭对象播放的音效。Remote_Ring 是呼叫方听到的回铃音 -
        -- 来电响铃请使用 Ringtone_* 音效。
        SoundName = 'Ringtone_Michael',
        SoundSet  = 'Phone_SoundSet_Michael',
    },
}
