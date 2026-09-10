-- Racing app - the tablet's race board. Tracks are drawn in-game with the gate
-- creator, ranked events are generated on a timer, and every finish is timed and
-- scored SERVER-side: a client only ever reports which checkpoint it passed and
-- which car it was in. Nothing below runs while Enabled is false.
-- 赛车应用 - 平板上的赛事板。赛道用游戏内的门架创建器绘制，排位赛按定时器
-- 自动生成，每次完赛都在服务端计时和计分：客户端只报告自己通过了哪个检查点、
-- 坐的是哪辆车。Enabled 为 false 时下面的内容一概不运行。
return {
    -- Whether this server runs Racing at all. Off is genuinely inert: no tables are
    -- built, the generator never ticks, no commands are registered and every
    -- callback refuses immediately. Turn it off if you run the phone alone - the
    -- app is laid out for a tablet, which is also why configs/apps.lua ships it
    -- with enabled = false on phones. To put it on the phone anyway, flip that
    -- flag as well; this one only decides whether the backend exists.
    -- 本服务器是否启用赛车。关闭时是真正的完全停用：不建表、生成器不运转、
    -- 不注册命令、所有回调立即拒绝。只运行手机端时请关闭 - 该应用为平板布局，
    -- 这也是 configs/apps.lua 中它在手机上默认 enabled = false 的原因。如果
    -- 一定要装到手机上，那个开关也要打开；本开关只决定后端是否存在。
    Enabled = true,

    -- Account entry fees are taken from and prizes paid into: 'cash', 'bank' or
    -- 'crypto'. If the balance there will not cover a buy-in the charge falls back
    -- to the other of cash/bank, and a refund always returns to whichever account
    -- actually paid.
    -- 报名费从哪个账户扣除、奖金发到哪个账户：'cash'（现金）、'bank'（银行）
    -- 或 'crypto'（加密货币）。该账户余额不足以支付报名费时，会回退到现金/
    -- 银行中的另一个；退款总是原路退回实际付款的账户。
    Currency = 'bank',

    -- Race classes, keyed by letter. A race carries a class CEILING rather than a
    -- fixed class: anyone whose vehicle resolves to that class or below may join,
    -- so an S race is open to everything and a D race is open to D cars only. The
    -- class is always resolved server-side from the model the joiner is sitting in
    -- (see Vehicles), never sent by the client.
    -- 赛车阶级，按字母索引。一场赛事携带的是阶级"上限"而不是固定阶级：车辆
    -- 判定为该阶级或更低的玩家都可以参加，所以 S 级赛对所有车开放，而 D 级赛
    -- 只有 D 级车能进。阶级始终由服务端根据加入者所坐车型判定（见 Vehicles），
    -- 绝不接受客户端发送的结果。
    --   level - shown beside the class name in the app. Nothing gates on it: entry
    --           is decided by the car, not by the driver.
    --   level - 应用中显示在阶级名旁边的等级数字。没有任何东西以它为准入条件：
    --           参赛由车决定，不是由车手决定。
    --   label - display name in the UI.
    --   label - 界面中显示的名称（已汉化，前端建赛界面会直接显示服务器下发值）。
    --   color - hex accent for the class pill. Mirrored by CLASS_COLOR in
    --           web/src/apps/racing/racingTheme.ts, so change both or the app and
    --           this file will disagree.
    --   color - 阶级徽章的十六进制强调色。web/src/apps/racing/racingTheme.ts 中
    --           的 CLASS_COLOR 有一份镜像，要改就两边一起改，否则应用和本文件
    --           会不一致。
    Classes = {
        D = { level = 1,  label = '新手',  color = '#9ca3af' },
        C = { level = 1,  label = '业余',  color = '#4ade80' },
        B = { level = 5,  label = '职业',  color = '#60a5fa' },
        A = { level = 15, label = '精英',  color = '#c084fc' },
        S = { level = 25, label = '传奇',  color = '#fbbf24' },
    },

    -- How a vehicle becomes a race class. Resolved from the model hash in this
    -- order: Models, then FromNativeClass, then Default. Editing these tables is
    -- the only way to change what a car counts as, both for joining a race and for
    -- the class recorded against a finish.
    -- 车辆如何判定为赛车阶级。按模型哈希依此顺序解析：Models，然后
    -- FromNativeClass，最后 Default。编辑这些表是改变车辆阶级的唯一方式，
    -- 对参赛资格和成绩记录的阶级都生效。
    Vehicles = {
        -- Per-model overrides. Key is the spawn name in lowercase, value is the
        -- class letter. Anything not listed falls through to the native class
        -- below, so this table is for add-ons and for cars whose native class
        -- lies about their real pace.
        -- 按车型单独覆盖。键是小写的生成名，值是阶级字母。未列出的车型落到
        -- 下面的原生类别，因此这张表用于附加模组车，以及原生类别与真实速度
        -- 不符的车。
        Models = {
            ['adder']    = 'S',
            ['zentorno'] = 'S',
            ['emerus']   = 'S',
            ['vacca']    = 'S',
            ['t20']      = 'S',
            ['comet2']   = 'A',
            ['italirsx'] = 'A',
            ['ninef']    = 'A',
            ['banshee']  = 'A',
            ['sultanrs'] = 'B',
            ['feltzer2'] = 'B',
            ['elegy']    = 'B',
            ['zr380']    = 'B',
            ['kuruma']   = 'C',
            ['jester3']  = 'C',
            ['tampa2']   = 'C',
            ['futo']     = 'D',
            ['sultan3']  = 'D',
        },

        -- Fallback keyed by the native GTA vehicle class index the game reports
        -- for a model. An index left out of this table drops to Default, which is
        -- how boats, aircraft and industrial vehicles land in the bottom class
        -- instead of being refused outright. The full index list is:
        -- 兜底表，按游戏为模型报告的 GTA 原生车辆类别索引匹配。不在本表中的
        -- 索引落到 Default，这样船、飞机和工业车辆会进入最低阶级而不是被直接
        -- 拒绝。完整索引列表：
        --   0 Compacts 紧凑型   1 Sedans 轿车      2 SUVs 越野车     3 Coupes 轿跑     4 Muscle 肌肉车
        --   5 Sports Classics 经典跑车             6 Sports 跑车      7 Super 超跑       8 Motorcycles 摩托车
        --   9 Off-road 越野  10 Industrial 工业  11 Utility 通用   12 Vans 厢型车    13 Cycles 自行车
        --  14 Boats 船      15 Helicopters 直升机 16 Planes 飞机   17 Service 服务   18 Emergency 紧急
        --  19 Military 军用 20 Commercial 商用   21 Trains 火车    22 Open Wheel 开轮式
        FromNativeClass = {
            [7]  = 'S', -- Super 超跑
            [22] = 'S', -- Open Wheel 开轮式
            [6]  = 'A', -- Sports 跑车
            [4]  = 'B', -- Muscle 肌肉车
            [5]  = 'B', -- Sports Classics 经典跑车
            [1]  = 'C', -- Sedans 轿车
            [3]  = 'C', -- Coupes 轿跑
            [8]  = 'C', -- Motorcycles 摩托车
            [9]  = 'C', -- Off-road 越野
            [0]  = 'D', -- Compacts 紧凑型
            [2]  = 'D', -- SUVs 越野车
            [12] = 'D', -- Vans 厢型车
        },

        -- Last resort when neither table matches, including a racer on foot.
        -- 两张表都不匹配时的最后兜底，包括步行参赛的车手。
        Default = 'D',
    },

    -- Rating (MMR). One number per racer in phone_racing_profiles, shown on the
    -- rankings board and on a driver card.
    -- 评分（MMR）。每位车手在 phone_racing_profiles 中有一个数字，显示在
    -- 排行榜和车手卡片上。
    MMR = {
        -- What a racer starts on the first time they appear.
        -- 车手第一次出现时的初始评分。
        Base = 1000,

        -- How a finish moves the rating.
        -- 完赛如何改变评分。
        --   mode 'linear' - position only. First gains +K, last loses -K, linear
        --                   in between. Opponents' ratings are ignored entirely.
        --   mode 'linear' - 只看名次。第一 +K，垫底 -K，中间线性插值。完全
        --                   不考虑对手评分。
        --   mode 'elo'    - every opponent is a head-to-head duel weighted by the
        --                   rating gap, snapshotted at the green light. Beating a
        --                   higher-rated racer pays more and losing to a
        --                   lower-rated one costs more. In an evenly matched field
        --                   the winner takes roughly K/2; a real upset approaches
        --                   the full K.
        --   mode 'elo'    - 每个对手都是一场按评分差距加权的一对一对决，在绿灯
        --                   亮起时快照。赢高评分车手收益更高，输给低评分车手
        --                   损失更大。实力均势的场次赢家大约拿到 K/2；真正的
        --                   爆冷则接近全额 K。
        Gain = {
            mode        = 'elo',
            K           = 25,    -- biggest rating swing a single race can cause 单场比赛能造成的最大评分波动
            spread      = 400,   -- elo only: rating gap at which the favourite is ~10x more likely to win 仅 elo：热门方胜率约 10 倍时的评分差距
            minPlayers  = 2,     -- fields below this award nothing, so nobody farms rating solo 参赛人数低于此值不给评分，防止单刷
            -- Player-hosted races are unranked by default: only generated events
            -- move ratings and reach the MMR chart. Set true and custom races count
            -- too, which also means two friends in a private lobby can trade rating
            -- between themselves as fast as they can restart.
            -- 玩家自建赛默认不计评分：只有生成的排位赛改变评分并进入 MMR 图表。
            -- 设为 true 后自定义赛也计分，这也意味着两个朋友在私人房里可以靠
            -- 无限重开互相刷分。
            customRaces = false,
        },
    },

    -- Did not finish. Once enough racers have crossed the line, everyone still
    -- driving gets a countdown; failing to beat it scores as a loss (the rating
    -- moves as though they finished last and no time is recorded). Disconnecting
    -- mid-race takes the loss on every run the player was part of.
    -- 未完赛（DNF）。足够多的车手冲线后，仍在跑的人会收到倒计时；没能在
    -- 倒计时内完赛按失利计分（评分按垫底变动，且不记录成绩）。比赛中断线
    -- 会在该玩家参与的每一轮中都算失利。
    DNF = {
        Enabled = true,

        -- What arms the countdown.
        -- 倒计时由什么触发。
        --   mode 'count'   - value is a number of finishers, so 1 arms it the
        --                    moment the winner crosses.
        --   mode 'count'   - value 是完赛人数，1 表示冠军冲线瞬间即触发。
        --   mode 'percent' - value is a percentage of the field, rounded up.
        --   mode 'percent' - value 是参赛人数的百分比，向上取整。
        Trigger = { mode = 'count', value = 1 },

        -- Seconds the stragglers get once it is armed. The server floors this at
        -- 10 so a tiny value here cannot make the countdown unwinnable.
        -- 触发后给落后者的秒数。服务端以 10 秒为下限，因此这里填很小的值也
        -- 不会让倒计时不可能完成。
        Seconds = 120,
    },

    -- Generated events: how they are driven, and how the pot is divided.
    -- 生成赛事：驾驶规则和奖金分配。
    Ranked = {
        -- Phasing (ghosting): racers in the same event fade out and cannot collide
        -- with each other.
        -- 相位（幽灵化）：同一赛事中的赛车变透明且互相不能碰撞。
        --   mode 'off'   - never phased, contact racing
        --   mode 'off'   - 从不相位，接触式赛车
        --   mode 'full'  - phased for the whole race
        --   mode 'full'  - 整场比赛相位
        --   mode 'timed' - phased for `seconds` after the green light, then
        --                  collisions come back for the rest of the race
        --   mode 'timed' - 绿灯后 `seconds` 秒内相位，之后比赛恢复碰撞
        Phasing = {
            mode    = 'full',
            seconds = 30,
        },

        -- Camera forced for the duration of a generated event.
        -- 生成赛事期间强制使用的视角。
        --   'none'  - the racer picks, cinematic cam included
        --   'none'  - 车手自选，包括电影视角
        --   'first' - forced first person, cinematic cam blocked
        --   'first' - 强制第一人称，禁止电影视角
        --   'third' - forced third person, zoom levels still allowed
        --   'third' - 强制第三人称，仍允许缩放距离
        Camera = 'none',

        -- Prize split by finishing position, ranked events ONLY. Index 1 is first
        -- across the line and each value is a fraction of the pool. A position with
        -- no entry wins nothing, and a share nobody finishes into is simply not
        -- paid. Player-hosted races ignore this and pay winner-takes-all of the
        -- buy-ins actually collected. Examples:
        -- 按完赛名次分配奖金，仅限排位赛。索引 1 是第一名，每个值是奖池的
        -- 比例。没有条目的名次没有奖金，没人跑到的名次份额直接不发。玩家
        -- 自建赛忽略此表，实际收取的报名费赢家通吃。示例：
        --   { [1] = 1.0 }                                     winner takes all 赢家通吃
        --   { [1] = 0.75, [2] = 0.15, [3] = 0.10 }            podium 领奖台
        --   { [1] = 0.5, [2] = 0.25, [3] = 0.15, [4] = 0.10 } top four paid 前四有奖
        PrizeSplit = { [1] = 0.75, [2] = 0.15, [3] = 0.10 },
    },

    -- Automatic race generation. Every interval the server builds a fresh batch of
    -- events on unique tracks and puts them on the board as "starting in X", which
    -- is what makes the app worth opening on an empty server.
    -- 自动赛事生成。每隔一段时间，服务端在不重复的赛道上生成一批新赛事，以
    -- "X 分钟后开赛"挂上赛事板，这正是空服时这个应用也值得打开的原因。
    RaceGen = {
        -- Master switch. Off leaves the board to player-hosted races only.
        -- 总开关。关闭后赛事板上只有玩家自建赛。
        Enabled = true,

        -- Minutes between batches.
        -- 每批赛事之间的间隔分钟数。
        IntervalMinutes = 20,

        -- Races per batch. Each one takes a UNIQUE track, so the real count is
        -- capped by how many eligible tracks exist: ten here on a server with four
        -- verified tracks produces four races.
        -- 每批赛事数量。每场占用一条不重复赛道，因此实际数量受可用赛道数
        -- 上限约束：这里填十，但服务器只有四条已验证赛道时只会生成四场。
        RacesPerBatch = 10,

        -- Only generate on VERIFIED tracks, the admin-curated flag. Set false to
        -- let any published track host a ranked event, which also means anything a
        -- player saves in the creator can start paying out.
        -- 只在"已验证"赛道（管理员审核标记）上生成。设为 false 则任何已发布
        -- 赛道都能举办排位赛，这也意味着玩家用创建器保存的任何赛道都可能
        -- 开始发奖。
        VerifiedOnly = true,

        -- Each generated race starts this many minutes in the future, picked at
        -- random between the two. Widen the gap for a board that stretches further
        -- ahead; narrow it for one that turns over quickly.
        -- 每场生成赛事在多少分钟后开赛，在两个值之间随机。拉开差距让赛事板
        -- 排得更远；收窄则轮换更快。
        StartsInMinMinutes = 10,
        StartsInMaxMinutes = 75,

        -- Minutes before the green light that the start-point board appears in the
        -- world, letting players walk up and join without the tablet.
        -- 绿灯前多少分钟，起点公告板出现在世界中，让玩家可以不走平板直接
        -- 走过去参赛。
        BoardLeadMinutes = 5,

        -- Circuit lap counts scale with track size: laps are TargetCheckpoints
        -- divided by the track's gate count, rounded, then clamped to min/max. A
        -- short loop therefore runs several laps and a monster track stays at one,
        -- so every generated event lands near the same length. Sprints, which end
        -- somewhere other than where they started, are always a single run.
        -- 环道圈数随赛道大小缩放：圈数 = TargetCheckpoints 除以赛道门架数，
        -- 四舍五入后夹在 min/max 之间。因此短环线跑好几圈、超长赛道保持一圈，
        -- 每场生成赛事的长度都差不多。冲刺赛（终点不同于起点）始终只跑一次。
        Laps = {
            min = 1,
            max = 4,
            TargetCheckpoints = 80,
        },

        -- Buy-in charged to join a generated race, picked at random in this range.
        -- 参加生成赛事的报名费，在此范围内随机。
        EntryFee = { min = 250, max = 2500 },

        -- Ranked pools scale with race length and class:
        -- 排位赛奖池随赛道长度和阶级缩放：
        --   pool = (Base + PerCheckpoint * gates * laps) * ClassMultiplier[class]
        -- then plus or minus Jitter, then rounded to the nearest $50. A class
        -- missing from the multiplier table counts as 1.0. Raise PerCheckpoint to
        -- pay long races better; raise the S multiplier to make the top class worth
        -- the risk.
        -- 然后加减 Jitter 抖动，再四舍五入到最近的 50 美元。乘数表中缺少的
        -- 阶级按 1.0 计。调高 PerCheckpoint 让长赛道奖金更高；调高 S 的乘数
        -- 让顶级阶级值得冒险。
        PrizePool = {
            Base = 1000,
            PerCheckpoint = 60,
            ClassMultiplier = { D = 0.8, C = 1.0, B = 1.3, A = 1.7, S = 2.2 },
            Jitter = 0.15,
        },

        -- Grid size, picked at random per race. BaseRegistered pads the registered
        -- counter with racers who do not exist, so a new board does not read 0/16 on
        -- every row. Off by default: the count players read is the count that joined.
        -- Raising it only dresses the number, never the grid, so the seats stay open.
        -- 发车格数量，每场随机。BaseRegistered 用不存在的车手填充报名计数，
        -- 这样新赛事板上不会每行都显示 0/16。默认关闭：玩家看到的数字就是
        -- 实际参赛人数。调高只会粉饰数字，不会占用车位，席位仍然开放。
        MaxRacers      = { min = 6, max = 16 },
        BaseRegistered = { min = 0, max = 0  },

        -- Event names are built as "<Prefix> <Suffix>". Add your own for local
        -- flavour; the two lists are combined freely, so a handful of each already
        -- gives hundreds of names.
        -- 赛事名按"<前缀> <后缀>"组合生成。可自行添加本地风味的词；两个列表
        -- 自由组合，每个列表放几个词就能产生几百个名字（已汉化为中文）。
        NamePrefixes = {
            '午夜', '霓虹', '极速', '绯红', '铬银', '顶点', '红线',
            '氮气', '幻影', '涡轮', '日食', '漩涡', '烈焰', '静电',
            '黄金', '狂野', '电流', '邪魅', '游侠', '暗影',
        },
        NameSuffixes = {
            '狂潮', '冲刺', '环道', '疾行', '奔袭', '回旋', '乱斗', '追缉',
            '奖杯赛', '大奖赛', '对决', '英里赛', '风暴', '闪电', '狂怒', '漂移',
        },
    },

    -- The in-game gate creator: drive the route, drop a gate at each corner, save
    -- it as a track. Everything it produces lands unverified, so a fresh track
    -- cannot be picked up as a ranked event until an admin verifies it.
    -- 游戏内门架创建器：沿路线驾驶，在每个弯角放一个门架，保存为赛道。它
    -- 产出的一切都是未验证状态，因此新赛道在管理员验证前不会被选为排位赛。
    Creator = {
        -- Off means the command is never registered AND the save callback refuses,
        -- so tracks can then only arrive through the database.
        -- 关闭意味着命令不注册，且保存回调也拒绝，赛道只能通过数据库进入。
        Enabled      = true,

        -- Chat command that toggles the creator (without the /). The standalone
        -- sd-racing resource registers a command of the same name, so while both
        -- resources run whichever starts last owns it. Stop sd-racing, or rename
        -- this, to be sure which creator you are driving.
        -- 切换创建器的聊天命令（不带 /）。独立版 sd-racing 资源注册了同名
        -- 命令，两个资源同时运行时，后启动的那个占用该命令。停掉 sd-racing
        -- 或把这里改名，才能确定你用的是哪个创建器。
        Command      = 'createtrack',

        -- Ace the command is restricted to, re-checked server-side when the track
        -- is saved. Grant it with `add_ace group.admin command.createtrack allow`
        -- in server.cfg.
        -- 命令所需的 ace 权限，保存赛道时服务端会重新检查。在 server.cfg 中用
        -- `add_ace group.admin command.createtrack allow` 授予。
        Ace          = 'command.createtrack',

        -- Gates a saved track must have. The floor is what makes a route a route,
        -- a start and a finish; the ceiling bounds both the JSON blob one row
        -- carries and the number of props a client spawns when the race begins.
        -- 保存赛道要求的门架数量。下限保证一条路线起码有起点和终点；上限
        -- 约束单行存储的 JSON 大小，以及比赛开始时客户端生成的道具数量。
        MinGates     = 2,
        MaxGates     = 512,

        -- Gate width in metres, the distance between the two posts. Min/Max bound
        -- what the arrow keys can reach, DefaultWidth is where a fresh gate starts,
        -- and WidthStep is the metres added per frame while an arrow key is held,
        -- so raise it for coarser, faster adjustment. Width shapes the posts that
        -- get drawn during the race but NOT whether a checkpoint counts: that is
        -- purely Race.CheckpointRadius below.
        -- 门架宽度（米），即两根立柱之间的距离。Min/Max 限定方向键能调到的
        -- 范围，DefaultWidth 是新门架的初始宽度，WidthStep 是按住方向键时每帧
        -- 增加的米数，调大可以更粗更快地调整。宽度只影响比赛中绘制的立柱，
        -- 不影响检查点是否判定通过：那完全由下面的 Race.CheckpointRadius 决定。
        MinWidth     = 2.0,
        MaxWidth     = 50.0,
        DefaultWidth = 12.0,
        WidthStep    = 0.15,

        -- Prop stood at each post while editing. Any small, tall prop works, and it
        -- is spawned translucent and collisionless so it never blocks the builder.
        -- Same candidates as Race.GateProp below.
        -- 编辑时立在每根柱子处的道具。任何细小高长的道具都行，它以半透明、
        -- 无碰撞方式生成，绝不会挡住建赛道的人。候选与下面的 Race.GateProp
        -- 相同。
        FlagModel    = 'prop_beachflag_01',

        -- Metres beyond which already-placed gates stop being drawn. Lower it if a
        -- long track costs you frames in the editor.
        -- 超过这个距离（米）后，已放置的门架不再绘制。长赛道在编辑器里掉帧
        -- 时调低它。
        DrawRadius   = 300.0,

        -- Who may open the track creator (the /createtrack command and the phone's
        -- "+" button both read this):
        -- 谁可以打开赛道创建器（/createtrack 命令和手机上的"+"按钮都读这个）：
        --   'everyone' - any player may create a track. Admins, and anyone holding
        --                the Ace above, are trusted: their track publishes the
        --                moment they save it. Everyone else's is queued as pending
        --                until an admin approves or rejects it from the phone's
        --                admin panel.
        --   'everyone' - 任何玩家都可以创建赛道。管理员和持有上面 Ace 的人受
        --                信任：他们的赛道保存即发布。其他人的赛道进入待审队列，
        --                直到管理员在手机管理面板中批准或驳回。
        --   'ace'      - only players holding the Ace above may create at all, and
        --                their tracks publish immediately. Nothing is ever queued,
        --                which is how the creator behaved before approval existed.
        --   'ace'      - 只有持有上面 Ace 的玩家才能创建，且赛道立即发布。
        --                没有任何待审队列，这是审批功能出现前创建器的行为。
        Access = 'everyone',
    },

    -- The live race: what the client draws, and what counts as passing a gate.
    -- 正式比赛：客户端绘制什么，以及怎样算通过门架。
    Race = {
        -- Horizontal metres from a checkpoint's centre that count as reached. This
        -- is the ONLY hit test: gate width, heading and direction of travel are all
        -- ignored, so a narrow gate on a wide road is still a 14 metre circle.
        -- Shrink it for tighter racing and expect more missed gates at speed.
        -- 距离检查点中心多少水平米数算到达。这是唯一的命中判定：门架宽度、
        -- 朝向和行驶方向全部忽略，所以宽路上的窄门架仍然是一个 14 米的圆。
        -- 调小比赛更紧凑，但高速时漏门会更多。
        CheckpointRadius   = 14.0,

        -- Numbers counted down on the line before the field is released.
        -- 发车前在线上倒数的数字个数。
        CountdownSeconds   = 3,

        -- Gates carrying a map pin and a GPS line at once: the one being driven to
        -- and the two after it. The set slides forward as each gate is taken rather
        -- than standing as a finished picture of the track, so the minimap stays
        -- readable and the racing line is something you read off the road. Raise it
        -- to show more of what is coming; 1 shows only the gate you are chasing.
        -- 同时带有地图标记和 GPS 路线的门架数：正在驶向的那个和它后面的两个。
        -- 每通过一个门架，这组标记就向前滑动，而不是把整条赛道一次画完，这样
        -- 小地图保持可读、赛车线要靠路面判断。调大可看到更多前方路线；1 只
        -- 显示你正在追的那个门架。
        GatesAhead         = 3,

        -- Prop spawned at both posts of every gate for the duration of a race.
        -- Frozen, collisionless and flagged as a mission entity, so a racer drives
        -- straight through it and it cannot be shoved or culled. Local to each
        -- client. Flares read better than flags on a night track:
        -- 比赛期间每个门架两根柱子上生成的道具。冻结、无碰撞并标记为任务
        -- 实体，赛车可以直接穿过，它不会被推走也不会被剔除。每个客户端本地
        -- 生成。夜赛赛道上信号灯比旗子更醒目：
        --   prop_beachflag_01  the default, a tall marker visible from distance 默认，远处可见的高标记
        --   prop_flare_01a     a lit road flare, low and bright 点亮的路面信号火，矮而亮
        --   prop_air_conelight a lit cone, brighter still 发光路锥，更亮
        GateProp           = 'prop_beachflag_01',

        -- The lineup check a joined racer has to satisfy at the start line.
        -- 已参赛车手在起点线必须满足的列队检查。
        --   LineupRadius      metres from the line they must be inside
        --   LineupRadius      必须在线的多少米以内
        --   LineupFaceDegrees biggest heading error allowed, so 90 accepts the
        --                     whole front 180 degree arc
        --   LineupFaceDegrees 允许的最大朝向误差，90 表示接受整个前方 180 度弧
        --   LineupLineMetres  metres past the line still counted as behind it
        --   LineupLineMetres  冲过线多少米仍算作在线后
        LineupRadius       = 40.0,
        LineupFaceDegrees  = 90.0,
        LineupLineMetres   = 3.5,

        -- The floating checkpoint billboard climbs as the racer falls further back
        -- so it stays visible over buildings and hills. Height ramps from Min at
        -- MarkerNear metres to Max at MarkerFar metres, and holds flat past each
        -- end. Raise MarkerHeightMax for tracks that run behind tall geometry.
        -- 浮动的检查点广告牌会随着车手落后而升高，使其在建筑物和山丘上方保持
        -- 可见。高度从 MarkerNear 米处的 Min 渐变到 MarkerFar 米处的 Max，两端
        -- 之外保持平坦。赛道穿过高大建筑后方时调高 MarkerHeightMax。
        MarkerHeightMin    = 12.0,
        MarkerHeightMax    = 45.0,
        MarkerNear         = 20.0,
        MarkerFar          = 250.0,

        -- Seconds before an abandoned run is swept out of memory. It bounds how
        -- long a run nobody ever finished, a crashed lobby or a field that all
        -- quit, keeps holding its race id.
        -- 一场被放弃的比赛在多少秒后从内存中清除。它限制了一场没人完赛的
        -- 比赛、崩溃的房间或全员退出的比赛占用其赛事 id 的时长。
        RunMaxAgeSeconds   = 3600,
    },

    -- Who reaches the Admin tab: verify, feature, unpublish and delete tracks.
    -- Every one of those handlers re-checks this server-side, so the UI hiding the
    -- tab is presentation only.
    -- 谁能进入管理标签页：验证、推荐、下架和删除赛道。每个处理程序都会在
    -- 服务端重新检查，所以界面隐藏标签页只是表现层。
    Admin = {
        -- Ace that grants it. Add `add_ace group.admin command.racingadmin allow`
        -- to server.cfg, or point this at an ace you already grant your staff.
        -- 授权用的 ace。在 server.cfg 中添加
        -- `add_ace group.admin command.racingadmin allow`，或指向你已经授予
        -- 管理团队的某个 ace。
        Ace = 'command.racingadmin',

        -- Extra identifiers that count as admin whatever the aces say. Any FiveM
        -- identifier type works: 'fivem:787003', 'license:0123456789abcdef...',
        -- 'steam:110000100000000', 'discord:123456789012345678'. Leave it empty to
        -- rely on the ace alone.
        -- 无论 ace 如何都算作管理员的额外标识符。任何 FiveM 标识符类型都行：
        -- 'fivem:787003'、'license:0123456789abcdef...'、
        -- 'steam:110000100000000'、'discord:123456789012345678'。留空则只
        -- 依赖 ace。
        Identifiers = {},
    },

    -- Hard bounds the server enforces on anything a client sends. The app clamps
    -- the same numbers so the forms look tidy, but these are what actually decide.
    -- 服务端对客户端发送的任何内容强制的硬边界。应用会夹紧同样的数字让表单
    -- 看起来整齐，但真正说了算的是这里。
    Limits = {
        -- Text caps in characters. Each matches its database column, so raising one
        -- without widening the column truncates the value silently.
        -- 文本字符上限。每个都对应数据库列，只调这里不扩列会导致值被静默截断。
        TrackNameMax  = 60,   -- phone_racing_tracks.name
        AliasMax      = 24,   -- phone_racing_profiles.alias
        AvatarUrlMax  = 500,  -- phone_racing_profiles.avatar, https:// only 仅允许 https://

        -- Bounds on a player-hosted race. Delay is the seconds between hosting and
        -- the green light, so DelayMin is how long the field gets to reach the
        -- start line. PhaseSec bounds 'timed' phasing.
        -- 玩家自建赛的边界。Delay 是从开房到绿灯的秒数，所以 DelayMin 是车手
        -- 赶到起点线的时间。PhaseSec 限定 'timed' 相位的秒数。
        DelayMin      = 10,
        DelayMax      = 600,
        LapsMin       = 1,
        LapsMax       = 20,
        BuyInMin      = 0,
        BuyInMax      = 100000,
        PhaseSecMin   = 5,
        PhaseSecMax   = 300,

        -- Rows per page in the tracks list and the rankings table. These must match
        -- TRACKS_PER_PAGE and RANKS_PER_PAGE in web/src/apps/racing/data.ts, or the
        -- pager will offer pages the server never fills.
        -- 赛道列表和排行榜每页行数。必须与 web/src/apps/racing/data.ts 中的
        -- TRACKS_PER_PAGE 和 RANKS_PER_PAGE 一致，否则分页器会给出服务端永远
        -- 填不满的页数。
        TracksPerPage = 20,
        RanksPerPage  = 25,

        -- How deep the leaderboard is cached and served. A racer further down still
        -- sees their own true rank on their card, it just is not browsable.
        -- 排行榜缓存和提供的最大深度。更靠后的车手仍能在自己的卡片上看到真实
        -- 名次，只是无法翻页浏览到。
        LeaderboardMax = 500,
    },

    -- Per-character rate limits. `window` is milliseconds and `max` is how many
    -- calls are allowed inside it. Keyed on citizenid rather than on the session,
    -- so dropping and reconnecting does not clear a limit.
    -- 按角色的频率限制。`window` 是毫秒数，`max` 是该窗口内允许的调用次数。
    -- 按 citizenid 而不是会话索引，因此掉线重连不会清空限制。
    RateLimits = {
        Join     = { window = 60000,  max = 10 }, -- joining a lobby 加入房间
        Leave    = { window = 60000,  max = 10 }, -- leaving one 离开房间
        Host     = { window = 300000, max = 3  }, -- hosting a custom race 开房自建赛
        Create   = { window = 600000, max = 5  }, -- saving a track from the creator 从创建器保存赛道
        Identity = { window = 300000, max = 5  }, -- alias, avatar and HUD writes 昵称、头像和 HUD 写入
        Admin    = { window = 60000,  max = 30 }, -- verify, feature, delete 验证、推荐、删除
    },
}
