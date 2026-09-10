-- MDT app - the Mobile Police Terminal. It runs on the phone and on sd-tablet, in
-- a layout suited to each. Every threshold the server enforces is declared here and
-- nowhere else: the UI only ever hides controls, it never grants them.
-- MDT 应用 - 移动警务终端。可在手机和 sd-tablet 平板上运行，各自使用适配布局。
-- 服务端强制执行的每个阈值都只在这里声明：界面永远只是隐藏控件，绝不会授予
-- 权限。
return {
    -- Whether this server runs an MDT at all. OFF by default, because turning it on
    -- builds a dozen tables, seeds the penal code and ticks a dispatch sweep, and a
    -- server already running its own police terminal should not be handed a second
    -- schema it never reads.
    -- 本服务器是否启用 MDT。默认关闭，因为开启后会建立十几张表、播种刑法典
    -- 并运行调度清扫任务；已经在运行其他警务终端的服务器，不应被塞给一个它
    -- 永远不会读的第二套数据结构。
    --
    -- Turn it ON when you want the terminals. Which players then see an icon is a
    -- separate question, answered per player by their job through server/appgate.lua,
    -- so this switch is about the backend existing at all. The app catalog cannot
    -- decide it either: a companion device carries its own catalog and this server
    -- never reads it.
    -- 想要终端时再开启。哪些玩家能看到图标是另一个问题，由 server/appgate.lua
    -- 按玩家的 job 逐一判断，因此本开关只决定后端是否存在。应用目录也无法决定
    -- 它：配套设备自带目录，而本服务器从不读取它。
    --
    -- To run a terminal on the phone itself, set `mdt` to `enabled = true` in
    -- configs/apps.lua as well.
    -- 要在手机本身上运行终端，还需在 configs/apps.lua 中把 `mdt` 设为
    -- `enabled = true`。
    -- Yes技术团队整合：已启用手机终端，与 YES_MDT 调度系统对接
    -- （YES_MDT 警情通过 exports['sd-phone']:mdtCreateCall 同步到本 CAD）。
    Enabled = true,

    -- Departments whose members reach the MDT. A player's ACTIVE framework job
    -- must appear here or every callback refuses, including the reads.
    -- 成员可以访问 MDT 的部门。玩家当前生效的框架 job 必须出现在这里，否则
    -- 所有回调都拒绝，包括读取。
    --   job       framework job name 框架 job 名
    --   type      'leo' | 'ems' | 'doj' - drives terminology on the frontend 决定前端术语
    --   label     full department name shown in the header strip 顶部条显示的部门全称（已汉化）
    --   short     abbreviation used on the seal 徽章上的缩写（保留英文）
    --   seal      DepartmentSeal artwork id ('lspd', 'bcso', 'sasp', 'doj', 'ems') 徽章图案 id
    --   accent    department colour, hex 部门颜色（十六进制）
    --   callsign  prefix for auto-generated callsigns ('LS' -> LS-104) 自动生成呼号的前缀
    --   bossGrade ESX-only boss threshold (ESX has no isboss flag) 仅 ESX：老板等级阈值（ESX 没有 isboss 标记）
    Departments = {
        {
            job       = 'police',
            type      = 'leo',
            label     = '洛圣都警察局',
            short     = 'LSPD',
            seal      = 'lspd',
            accent    = '#1D4ED8',
            callsign  = 'LS',
            bossGrade = 4,
        },
        {
            job       = 'sheriff',
            type      = 'leo',
            label     = '布雷恩郡警长办公室',
            short     = 'BCSO',
            seal      = 'bcso',
            accent    = '#166534',
            callsign  = 'BC',
            bossGrade = 4,
        },
        {
            job       = 'sasp',
            type      = 'leo',
            label     = '圣安地列斯州警',
            short     = 'SASP',
            seal      = 'sasp',
            accent    = '#7C2D12',
            callsign  = 'SA',
            bossGrade = 4,
        },

        -- An `ems` department gets the MEDICAL terminal instead of the police
        -- one: Patients rather than Profiles, Protocols rather than the penal
        -- code, and no Vehicles, Warrants or Jail. Its paperwork lives in its
        -- own domain, which the server enforces - a medic cannot read a police
        -- report and an officer cannot read a medical one.
        -- `ems` 部门得到的是医疗终端而不是警察终端：病人档案而不是人物档案、
        -- 医疗规程而不是刑法典，没有车辆、通缉令或监狱。其文书在独立域内，
        -- 服务端强制隔离 - 医护读不了警方报告，警员也读不了医疗报告。
        --
        -- Fire, air ambulance or a second hospital are just more `ems`
        -- departments; they each get their own roster, chat and call board.
        -- 消防、空中救护或第二家医院只需再加更多 `ems` 部门；它们各自有
        -- 独立的花名册、聊天和呼叫板。
        {
            job       = 'ambulance',
            type      = 'ems',
            label     = '圣安地列斯医疗服务',
            short     = 'SAMS',
            seal      = 'ems',
            accent    = '#E11D48',
            callsign  = 'M',
            bossGrade = 4,
        },

        -- A `doj` department gets the COURT terminal: a docket, expungement
        -- petitions and a read-only view of the police paperwork a case is
        -- built on. It has no dispatch board, no jail and no seized handsets,
        -- because a court does not police - it rules on what policing produced.
        -- `doj` 部门得到的是法院终端：案件排期、消档申请，以及对立案所依据
        -- 的警方文书的只读视图。它没有调度板、没有监狱、没有被扣手机，因为
        -- 法院不执法 - 它对执法的结果作出裁决。
        --
        -- `bench = true` marks the department that WEARS THE ROBE. Only a bench
        -- department reaches the ruling keys (court.rule, expunge.rule,
        -- warrants.void); an attorney department files and argues. Both read the
        -- same docket, which is what makes a hearing a conversation rather than
        -- two disconnected screens.
        -- `bench = true` 标记穿法袍的部门。只有 bench 部门能使用裁决键
        -- （court.rule、expunge.rule、warrants.void）；律师部门负责提交和
        -- 辩论。双方读同一个排期表，这样听证会才是一场对话，而不是两块互不
        -- 相连的屏幕。
        {
            job       = 'judge',
            type      = 'doj',
            bench     = true,
            label     = '圣安地列斯高等法院',
            short     = 'SASC',
            seal      = 'doj',
            accent    = '#6D28D9',
            callsign  = 'HON',
            bossGrade = 3,
        },
        {
            job       = 'lawyer',
            type      = 'doj',
            label     = '圣安地列斯律师协会',
            short     = 'SABA',
            seal      = 'doj',
            accent    = '#7C3AED',
            callsign  = 'ATT',
            bossGrade = 3,
        },
    },

    -- When true a boss of their department (QBCore/QBox `isboss` flag, ESX
    -- grade >= bossGrade) holds every permission below. The chain-of-command
    -- guard on roster.grade / roster.dismiss still applies to a boss: nobody
    -- re-grades a peer, a superior, or themselves.
    -- 为 true 时，本部门的老板（QBCore/QBox 的 `isboss` 标记，ESX 为等级 >=
    -- bossGrade）自动拥有下面所有权限。roster.grade / roster.dismiss 的指挥链
    -- 保护对老板仍然生效：谁都不能给同级、上级或自己重新定级。
    -- Yes技术团队整合 - 文书主权划分：正式文书（报告／案件／人员档案／车辆／通缉令）
    -- 的主权在 YES_MDT（桌面终端，数据库持久化 + 完整审核链）；手机 MDT 定位为
    -- "移动 CAD"：呼叫板／部门聊天／SOP／公告／医疗规程／法院／内务域保留，
    -- 文书类权限收走置 99（无人可用），呼号编辑收走（以 YES_MDT 人员管理为准）。
    -- BossBypass 必须为 false，否则部门老板会绕过下面的收权。
    BossBypass = false,

    -- Permission key -> MINIMUM job grade. A key that is not listed here is
    -- DENIED, not permitted, so a fresh install behaves predictably. Grades are
    -- the framework's own ladder, so grade 4 on a three-rank job simply means
    -- "nobody but a boss".
    -- 权限键 -> 最低 job 等级。未列在这里的键是拒绝而不是允许，这样全新安装
    -- 的行为可预期。等级就是框架自己的职级，因此三级职业填上等级 4 就等于
    -- "除老板外没人可用"。
    Permissions = {
        ['home.view']        = 0,

        -- ===== 文书主权在 YES_MDT：以下权限收走（99 = 无人可用）=====
        -- 正式报告、案件、人员／车辆档案、通缉令一律在 YES_MDT 桌面终端办理；
        -- 手机端保留的板块见下方未收走的键（CAD／聊天／SOP／公告／医疗／法院／内务）。
        ['persons.view']     = 99,
        ['persons.edit']     = 99,
        ['profiles.view']    = 99,
        ['vehicles.view']    = 99,
        ['vehicles.edit']    = 99,
        ['reports.view']     = 99,
        ['reports.create']   = 99,
        ['reports.edit.own'] = 99,
        ['reports.edit.any'] = 99,
        ['reports.delete']   = 99,
        ['cases.view']       = 99,
        ['cases.create']     = 99,
        ['cases.edit']       = 99,
        ['cases.delete']     = 99,
        ['warrants.view']    = 99,
        ['warrants.issue']   = 99,
        ['warrants.close']   = 99,
        ['warrants.void']    = 99,
        ['offences.view']    = 0,

        -- 调度板（移动 CAD 核心）。
        ['dispatch.view']    = 0,
        ['dispatch.attach']  = 0,
        ['dispatch.status']  = 0,

        -- 部门聊天与公告（公告为手机侧自有板块，与 YES_MDT 公告并行）。
        ['chat.view']        = 0,
        ['chat.send']        = 0,
        ['bulletins.view']   = 0,
        ['bulletins.manage'] = 3,

        -- SOP 标准作业程序（手机独有，configs/sops.lua 为唯一作者）。
        ['sops.view']        = 0,
        ['me.update']        = 0,

        -- 花名册：保留查看／无线电频道；呼号编辑收走（以 YES_MDT 人员管理为准）。
        ['roster.view']      = 0,
        ['employees.view']   = 0,
        ['roster.radio']     = 3,
        ['roster.callsign']  = 99,

        -- Standing orders. Every sworn member reads their own department's SOPs;
        -- there is no manage key because configs/sops.lua is the only author.
        -- 标准作业程序（SOP）。每个宣誓成员都能读本部门的 SOP；没有管理键，
        -- 因为 configs/sops.lua 是唯一的作者。
        ['sops.view']        = 0,
        ['me.update']        = 0,

        -- Medical terminal. `patients.view` is the EMS counterpart of
        -- persons.view and `protocols.view` of offences.view; a department of
        -- type 'leo' never sees either section, so listing them here costs a
        -- police server nothing.
        -- 医疗终端。`patients.view` 是 persons.view 的 EMS 对应项，
        -- `protocols.view` 是 offences.view 的对应项；'leo' 类型部门永远看
        -- 不到这两个板块，所以对纯警察服务器来说列在这里毫无代价。
        ['patients.view']    = 0,
        ['protocols.view']   = 0,

        -- Court terminal. A `doj` department never sees a police-only key and a
        -- police department never sees one of these, so listing them costs a
        -- server that runs no court nothing. The ruling keys are additionally
        -- reserved for a department marked `bench`, whatever the grade.
        -- 法院终端。`doj` 部门看不到警察专属键，警察部门也看不到这些键，
        -- 所以对不运行法院的服务器毫无代价。裁决键还额外保留给标记了
        -- `bench` 的部门，无论等级多少。
        ['court.view']       = 0,
        ['court.file']       = 0,
        ['expunge.view']     = 0,
        ['expunge.file']     = 0,
        ['court.manage']     = 1,
        ['court.rule']       = 1,
        ['expunge.rule']     = 1,

        -- Internal Affairs. Filing a complaint is deliberately open to every
        -- sworn grade: a probationer who witnesses misconduct must be able to
        -- report it. Reading and investigating the file is not.
        -- 内务 Affairs。提交投诉刻意对所有宣誓等级开放：见习警员目睹了不
        -- 当行为也必须能举报。但读取和调查档案不是。
        ['affairs.file']     = 0,

        -- Reading a seized handset. Set above 0 to keep it off patrol grades, and every
        -- lookup writes an audit row naming the officer and whose phone they opened.
        -- 读取被扣手机。设为 0 以上可让巡逻等级无权使用；每次查询都会写一条
        -- 审计记录，记下是哪个警员打开了谁的手机。
        ['phone.view']       = 1,

        -- 与上方收走键重复的定义已删除（Lua 同表重复赋值取最后值，会覆盖收权）。
        ['patients.edit']    = 1,
        ['jail.view']        = 1,

        ['jail.book']        = 2,

        ['bulletins.manage'] = 3,
        ['roster.radio']     = 3,

        ['affairs.view']       = 3,
        ['affairs.investigate'] = 3,

        ['protocols.manage'] = 4,
        ['roster.grade']     = 4,
        ['roster.dismiss']   = 4,
        ['logs.view']        = 4,
        ['affairs.close']    = 4,
    },

    -- Booking and sentencing. Months and fine are always derived server-side
    -- from the report's charge rows; these only bound what an officer may take
    -- OFF that figure.
    -- 收押和量刑。刑期月数和罚款始终由服务端根据报告的指控行计算；这些值
    -- 只限制警员可以在该数字上减免多少。
    Jail = {
        MaxFine            = 25000, -- hard ceiling on a single citation 单张罚单的硬性罚款上限
        MaxReductionMonths = 12,    -- most an officer may cut from a sentence 警员最多可减免的刑期月数
        MaxFineReduction   = 2500,  -- most an officer may cut from a citation 警员最多可减免的罚款额
        MaxMonths          = 240,   -- hard ceiling on a single sentence 单句判决的硬性刑期上限
        -- Prison system. 'auto' probes, in order: qbx_prison, qb-prison, xt-prison,
        -- pickle_prisons, tk_jail, esx_tk_jail, qb-policejob, ps-policejob, esx_jail,
        -- esx-qalle-jail, rcore_prison.
        -- 监狱系统。'auto' 按顺序探测：qbx_prison、qb-prison、xt-prison、
        -- pickle_prisons、tk_jail、esx_tk_jail、qb-policejob、ps-policejob、
        -- esx_jail、esx-qalle-jail、rcore_prison。
        Resource           = 'auto',
        -- What the prison counts a sentence in. 'auto' trusts the adapter, which is right for
        -- every script above. Override only if yours was reconfigured: getting this wrong is the
        -- difference between a six month sentence and a six second one.
        -- 监狱以什么单位计算刑期。'auto' 信任适配器，对上面所有脚本都是正确的。
        -- 只有你的脚本被重新配置过时才覆盖：搞错这个，六个月的刑期会变成六秒。
        TimeUnit           = 'auto', -- 'auto' | 'months' 月 | 'minutes' 分钟 | 'seconds' 秒
        -- Real seconds one MDT month is worth, used only for prisons that count in seconds or
        -- minutes. Ignored by month-based prisons, which take the sentence as-is.
        -- MDT 一个月刑期对应的真实秒数，仅用于按秒或分钟计算的监狱。按月计算
        -- 的监狱忽略此项，刑期原样传入。
        SecondsPerMonth    = 60,
        JailAccount        = 'bank', -- account a citation is debited from 罚单扣款账户
    },

    -- Warrants. Closing a warrant expires it rather than deleting it, so the
    -- record survives for the audit trail.
    -- 通缉令。撤销通缉令是让它过期而不是删除，记录保留下来供审计追踪。
    Warrants = {
        DefaultExpiryDays = 7,  -- 默认有效期天数
        MaxExpiryDays     = 90, -- 最大有效期天数
        MaxBond           = 500000, -- 保释金上限
    },

    -- Dispatch is entirely in memory. TTL is how long a call stays on the board
    -- with nobody attached before it expires.
    -- 调度完全在内存中。TTL 是一个呼叫在无人接警的情况下留在板上多少秒后
    -- 过期。
    Dispatch = {
        CallTTL        = 900,      -- seconds 秒
        MaxCalls       = 60,       -- 板上最大呼叫数
        CallsignFormat = '%s-%03d', -- prefix, sequence 前缀、序号
        SweepSeconds   = 15,       -- 清扫间隔秒数

        -- Whether police and medical share one call board. Off by default: a
        -- medic's board carries medical calls and medical units only, and an
        -- officer's carries neither. Turn it on for a server that wants both
        -- services looking at one CAD, in which case every unit and every call
        -- is visible to both and the seal on a row says which service it is.
        -- 警察和医疗是否共用一块呼叫板。默认关闭：医护的板上只有医疗呼叫和
        -- 医疗单位，警员的板上两者都没有。希望两个部门看同一个 CAD 的服务
        -- 器可以开启，开启后所有单位和呼叫对双方可见，每行的徽章标明它属于
        -- 哪个部门。
        Shared         = false,

        -- How often, in milliseconds, unit positions are refreshed for the CAD map. Coarse on
        -- purpose: the map wants to know roughly where a unit is, and a tighter tick pushes the
        -- whole board to every terminal that much more often. Skipped entirely with nobody on air.
        -- CAD 地图上单位位置的刷新频率（毫秒）。刻意较粗：地图只想知道单位的
        -- 大致位置，而更密的 tick 会把整块板更频繁地推给每个终端。没人在线时
        -- 完全跳过。
        PositionMs     = 4000,

        -- Mirroring a third-party dispatch resource onto this board. When a supported system
        -- raises an alert, the same call appears on the CAD, addressed to the police or the
        -- medical board. It is one-way: the MDT never answers, acknowledges or attaches back, so
        -- both boards keep working side by side.
        -- 把第三方调度资源镜像到本板。受支持的系统发出警报时，同一个呼叫会
        -- 出现在 CAD 上，发往警察板或医疗板。这是单向的：MDT 从不回应、确认
        -- 或回接，因此两块板可以并排工作。
        --
        -- Every event a dispatch resource raises an alert on is a NET event, which means a
        -- modified client can fire it with whatever it likes. That is true of those resources with
        -- or without sd-phone, and nothing here can fix their end of it. What is guaranteed is
        -- this end: a mirrored call is quarantined, so it can never cost a call your own officers
        -- or the mdtCreateCall export raised anything. Mirrored calls hold a share of the board of
        -- their own and are the first thing evicted from it, and they can never be filed at
        -- priority 1 however urgent the alert claims to be. A forged alert therefore chooses only
        -- which board it appears on, and cannot evict, outrank or displace a call of yours there.
        -- 调度资源发警报用的每个事件都是网络事件，意味着改过的客户端可以随便
        -- 触发它。无论有没有 sd-phone，那些资源都是如此，这里无法修复它们那
        -- 一端。能保证的是本端：镜像呼叫被隔离，绝不会挤掉你自己的警员或
        -- mdtCreateCall 导出发起的呼叫。镜像呼叫占用板上自己的一份配额，并且
        -- 是最先被清退的；无论警报自称多紧急，都永远不能以 1 级优先级立案。
        -- 因此伪造警报只能选择它出现在哪块板上，不能清退、压过或顶替你的
        -- 呼叫。
        --
        -- Nothing has to be installed for this to be safe. A handler is registered for every
        -- supported system that publishes a SERVER event, and one that is not running simply
        -- never fires. The one system that publishes to clients instead (aty_dispatchv2) needs a
        -- relay across a client, and that relay is registered only while that resource is actually
        -- running: on a server without it, no such entry point exists at all.
        -- 不需要安装任何东西也是安全的。每个发布服务器事件的受支持系统都注册
        -- 了处理器，没在运行的系统根本不会触发。唯一发布给客户端的系统
        -- （aty_dispatchv2）需要一个跨客户端中继，该中继只在那个资源实际运行
        -- 时注册：没有它的服务器上，这个入口根本不存在。
        --
        -- Three systems cannot be mirrored automatically, because they publish alerts through an
        -- export rather than an event and an export call cannot be observed from outside the
        -- resource that made it: tk_dispatch, codem-dispatch and fd_dispatch. Forward those from
        -- your own resource, wherever you already raise the alert, by calling
        -- exports['sd-phone']:mdtMirrorCall(alert), which is quarantined, rate limited and
        -- de-duplicated exactly like the events above. That export answers to the switches here
        -- too, under the key 'export': Enabled = false turns it off with everything else, and
        -- adding ['export'] = false to Systems below turns off only it.
        -- 三个系统无法自动镜像，因为它们通过导出而不是事件发布警报，而导出调用
        -- 无法从资源外部观测：tk_dispatch、codem-dispatch 和 fd_dispatch。请在
        -- 你自己的资源里（你已经发出警报的地方）调用
        -- exports['sd-phone']:mdtMirrorCall(alert) 转发，它与上面的事件一样被
        -- 隔离、限频和去重。该导出也受这里的开关控制，键名是 'export'：
        -- Enabled = false 会连同其他系统一起关闭它，在下面的 Systems 中加
        -- ['export'] = false 则只关闭它。
        Ingest = {
            Enabled = true,

            -- Set one to false to stop mirroring it, which also closes its entry point rather
            -- than merely ignoring what arrives on it: aty_dispatchv2 set to false means the
            -- client relay is never registered at all. Anything not listed here is on, so a
            -- config written before a system was supported keeps working.
            -- 把某个设为 false 可停止镜像，这同时会关闭它的入口而不只是忽略
            -- 收到的内容：aty_dispatchv2 设为 false 意味着客户端中继根本不会
            -- 注册。未列在这里的系统默认开启，因此在某系统受支持之前写的配置
            -- 仍可工作。
            --   ps-dispatch       ps-dispatch:server:notify
            --   qb-dispatch       dispatch:server:notify (and its many forks 及其众多分支)
            --   cd_dispatch       cd_dispatch:AddNotification
            --   qs-dispatch       qs-dispatch:server:CreateDispatchCall
            --   rcore_dispatch    rcore_dispatch:server:sendAlert
            --   aty_dispatchv2    aty_dispatchv2:client:sendDispatch, relayed by the client half 由客户端中继
            Systems = {
                ['ps-dispatch']    = true,
                ['qb-dispatch']    = true,
                ['cd_dispatch']    = true,
                ['qs-dispatch']    = true,
                ['rcore_dispatch'] = true,
                ['aty_dispatchv2'] = true,
            },

            -- How long the same alert is swallowed for. Half of these systems re-fire one incident
            -- several times (a shootout is one call and six alerts), and the client-relayed one
            -- arrives once per player who received it. An alert repeats when its whole body - the
            -- code, the headline, the location, the suspect line and the priority - matches one
            -- already on the board from the same 25 metre cell. Capped at 5 minutes.
            -- 同一警报被吞掉（去重）的时长。这些系统中有一半会对同一事件重复
            -- 触发（一场枪战是一个呼叫、六条警报），客户端中继的那个则每个收到
            -- 的玩家都来一次。当警报的全部内容 - 代码、标题、位置、嫌疑人行和
            -- 优先级 - 与板上同一个 25 米网格内已有的警报匹配时，视为重复。
            -- 上限 5 分钟。
            DedupeSeconds = 45,

            -- Flood ceiling: at most RateMax alerts accepted from one source in any RateWindow
            -- milliseconds. Every one of these entry points is an event a modified client can
            -- trigger with whatever it likes, so this is what keeps a 60-call board from being
            -- buried by one script. A source is a CHARACTER for a client-sent alert and the firing
            -- RESOURCE for a server-sent one, so reconnecting does not reset a budget and two
            -- dispatch resources never spend each other's.
            -- 洪水上限：任意 RateWindow 毫秒内，同一来源最多接受 RateMax 条
            -- 警报。这些入口每一个都是改过的客户端可以随便触发的事件，所以
            -- 靠这个防止 60 个位置的呼叫板被一个脚本淹没。客户端发来的警报，
            -- 来源是角色；服务端发来的，来源是触发的资源，因此重连不会重置
            -- 配额，两个调度资源也不会互花对方的配额。
            --
            -- A source holds ONE budget covering every system at once, so firing five systems'
            -- events in rotation buys nothing beyond RateMax. Two dispatch resources are kept out
            -- of each other's budget by being separate sources, not by counting them separately.
            -- 一个来源只有一份配额、覆盖所有系统，所以轮流触发五个系统的事件
            -- 也超不过 RateMax。两个调度资源靠"是不同来源"而不是"分开计数"
            -- 来互不占用配额。
            --
            -- Note that RateMax alone cannot bound the board: over one CallTTL a single source may
            -- spend its budget many times over. Mirrored calls are therefore also held to half of
            -- MaxCalls at once, and past that share the OLDEST MIRRORED call is evicted to make
            -- room - never a call of yours, and never the new alert either, because refusing that
            -- one would black the mirror out for a whole CallTTL and take the genuine alerts down
            -- with it. Set RateMax above that share and the server warns at startup: at that point
            -- one window can cycle every slot mirroring is allowed, so nothing on it survives long
            -- enough to be read.
            -- 注意单靠 RateMax 无法限制呼叫板：在一个 CallTTL 内，单一来源可以
            -- 把配额花掉很多次。因此镜像呼叫还被限制为同时最多占 MaxCalls 的
            -- 一半，超过这份配额时会清退最老的镜像呼叫来腾位置 - 永远不会清退
            -- 你的呼叫，也不会清退新警报（因为拒绝新警报会让镜像在整个 CallTTL
            -- 内黑屏，连真警报一起被拖垮）。RateMax 高于该份额时服务端会在启动
            -- 时警告：此时一个窗口就能循环占满镜像允许的每个槽位，板上没有东西
            -- 能活到被人看到。
            RateWindow    = 10000,
            RateMax       = 12,

            -- Board an alert lands on when the jobs it names are not departments this server runs.
            -- Police, because that is what nearly every dispatch alert is.
            -- 当警报点名的 job 不是本服务器运行的部门时，警报落在哪块板。警察，
            -- 因为几乎所有调度警报都是发给警察的。
            --
            -- Every other alert is routed by the jobs its payload names, which is how all six of
            -- these systems address one and is what puts medical alerts on the medical terminal:
            -- they raise their alerts from the client that witnessed the incident, so refusing a
            -- client-sourced job list would route the whole of EMS onto the police board. A forged
            -- list can only pick which board a call appears on, and the quarantine above already
            -- guarantees it costs that board nothing.
            -- 其他所有警报按其载荷点名的 job 路由，这六个系统都是这样寻址的，
            -- 也是医疗警报上医疗终端的方式：它们从目睹事件的客户端发出警报，所以
            -- 拒绝客户端来源的 job 列表会把整个 EMS 都路由到警察板上。伪造的
            -- 列表只能选择呼叫出现在哪块板，而上面的隔离已经保证它对那块板毫无
            -- 影响。
            --
            -- This is ALSO the board the client RELAY always lands on, whatever its payload names.
            -- Only aty_dispatchv2 takes that path, and it is the one payload no dispatch resource
            -- ever raises on this server: a client rebuilds it field by field, so it is the one
            -- shape where the job list carries no information at all.
            -- 这也是客户端中继始终落脚的板，无论其载荷点名什么。只有
            -- aty_dispatchv2 走这条路，而它是本服务器上没有任何调度资源会发出的
            -- 载荷：客户端逐字段重建它，所以它是唯一一种 job 列表完全不携带信息
            -- 的形态。
            DefaultDomain = 'leo',
        },
    },

    -- Department radio channel. In-memory ring buffer, nothing persisted.
    -- 部门无线电频道。内存环形缓冲，不持久化任何内容。
    Chat = {
        MaxMessages = 50,    -- 最大消息条数
        MaxLength   = 300,   -- 单条最大长度
        RateWindow  = 60000, -- ms 毫秒
        RateMax     = 20,    -- messages per window 每个窗口的消息数
    },

    -- Row caps for the paginated master lists.
    -- 分页主列表的行数上限。
    Paging = {
        PageSize    = 25,  -- 每页行数
        MaxPageSize = 50,  -- 客户端可请求的最大每页行数
        MaxPage     = 400, -- 可翻到的最大页码
    },

    -- Report types offered in the editor. Must match the ReportType union in
    -- web/src/apps/mdt/data.ts.
    -- 编辑器中提供的报告类型。必须与 web/src/apps/mdt/data.ts 中的
    -- ReportType 联合类型一致（键名不可翻译）。
    ReportTypes = { 'Incident', 'Traffic', 'Arrest', 'Investigation', 'Warrant' },

    -- The medical terminal's own report types, offered instead of the list
    -- above when the author's department is type 'ems'. Must match the
    -- EmsReportType union in web/src/apps/mdt/data.ts.
    -- 医疗终端自己的报告类型，当作者部门为 'ems' 类型时替代上面的列表。
    -- 必须与 web/src/apps/mdt/data.ts 中的 EmsReportType 联合类型一致
    -- （键名不可翻译）。
    EmsReportTypes = { 'Patient Care', 'Trauma', 'Cardiac', 'Overdose', 'Transport', 'Death' },

    -- Roles a person can hold on a MEDICAL report, replacing the police
    -- suspect/victim/witness set. Must match EMS_INVOLVED_ROLES in
    -- web/src/apps/mdt/data.ts.
    -- 一个人在医疗报告中可以担任的角色，替代警方的嫌疑人/受害者/证人组。
    -- 必须与 web/src/apps/mdt/data.ts 中的 EMS_INVOLVED_ROLES 一致
    -- （键名不可翻译）。
    EmsInvolvedRoles = { 'patient', 'witness', 'responder', 'other' },

    -- Officer-set flags offered on a citizen record. Must match PERSON_FLAGS in
    -- web/src/apps/mdt/data.ts.
    -- 市民档案上可由警员设置的标记。必须与 web/src/apps/mdt/data.ts 中的
    -- PERSON_FLAGS 一致（键名不可翻译）。
    PersonFlags = { 'wanted', 'armed', 'gang', 'mental_health', 'flight_risk', 'informant' },

    -- Content caps for officer-authored text.
    -- 警员撰写文本的内容上限。
    Limits = {
        ReportTitle   = 160,   -- 报告标题
        ReportBody    = 12000, -- 报告正文
        CaseTitle     = 160,   -- 案件标题
        CaseSummary   = 4000,  -- 案件摘要
        CaseNote      = 1000,  -- 案件笔记
        PersonNotes   = 4000,  -- 人物备注
        VehicleNotes  = 2000,  -- 车辆备注
        BulletinTitle = 120,   -- 公告标题
        BulletinBody  = 4000,  -- 公告正文
        Callsign      = 12,    -- 呼号
        RadioChannel  = 12,    -- 无线电频道
        MediaUrl      = 512,   -- 媒体 URL
        Charges       = 40, -- charge lines per report 每份报告的指控行数
        Involved      = 24, -- involved persons per report 每份报告的相关人数

        -- Medical terminal. 医疗终端。
        MedicalNotes  = 4000,  -- 医疗备注
        Allergies     = 400,   -- 过敏史
        Conditions    = 400,   -- 既往疾病
        Medications   = 400,   -- 在用药物
        ProtocolTitle = 120,   -- 规程标题
        ProtocolBody  = 4000,  -- 规程正文
    },
}
