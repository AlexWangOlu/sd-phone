-- Services app. Maps framework JOBS to "companies" the phone surfaces: a public directory
-- (locate / call / message) plus boss management of the company's shared balance and employee
-- roster. Society money + employee reads route through bridge/server/society.lua (adapts
-- qb-banking / Renewed-Banking / qbx_management / qb-management / esx_addonaccount).
-- 服务应用。把框架“工作”映射为手机呈现的“公司”：公开名录（定位/呼叫/发消息），
-- 以及老板对公司共享余额和员工名单的管理。社团资金和员工读取通过
-- bridge/server/society.lua（适配 qb-banking / Renewed-Banking /
-- qbx_management / qb-management / esx_addonaccount）。
return {
    -- ESX-ONLY fallback. On QBCore/QBox boss status is read from the grade's
    -- `isboss` flag and this is ignored. On ESX (no isboss flag) it's the minimum
    -- grade treated as a boss when a company has no own `bossGrade`.
    -- 仅 ESX 的回退设置。QBCore/QBox 上老板身份从职级的 `isboss` 标记读取，
    -- 此项被忽略。ESX（没有 isboss 标记）上，当公司没有自己的 `bossGrade` 时，
    -- 把此职级及以上视为老板。
    DefaultBossGrade = 3,

    -- Job a fired employee is reset to (QBCore/QBox and ESX both use 'unemployed').
    -- 被解雇员工重置为的工作（QBCore/QBox 和 ESX 都用 'unemployed'）。
    UnemployedJob = 'unemployed',

    -- Cap on how many employees the roster returns.
    -- 员工名单返回人数的上限。
    EmployeeLimit = 100,

    -- Jobs tab (multi-job). Only active on QBCore/QBox; the tab is hidden on ESX.
    -- Max jobs a player can keep saved at once. Set to 0 to disable the cap
    -- (unlimited saved jobs) - this also hides the X/X capacity bar in the app.
    -- 工作标签页（多工作）。仅在 QBCore/QBox 上有效；ESX 上隐藏该标签页。
    -- 玩家同时可保存的工作数上限。设为 0 禁用上限（无限保存）- 这也会隐藏
    -- 应用中的 X/X 容量条。
    MaxSavedJobs = 5,
    -- Jobs never listed, switchable, or accept-able from the Jobs tab (resign to
    -- unemployed via the Actions tab's Quit instead).
    -- 不会在工作标签页中列出、切换或接受的工作（请改用操作标签页的“辞职”
    -- 辞为失业）。
    JobBlacklist = { 'unemployed' },
    -- Drop the player off duty when they switch active job (mirrors sd-multijob).
    -- 切换当前工作时让玩家下班（与 sd-multijob 行为一致）。
    SwitchOffDuty = true,

    -- Business invoicing. On-duty employees send a banking invoice from their
    -- business to another player; the target pays it from the Banking app and
    -- the sender is notified. Only active on QBCore/QBox (on-duty state must be
    -- resolvable); the section is hidden on ESX, like the Jobs tab.
    -- Payout: when a society bank is available the payment is credited to the
    -- business account; otherwise it falls back to the sending employee's own
    -- bank (see bridge/server/society.lua). A per-company `commission` (below)
    -- splits off a cut of the society-credited payment to the sending employee.
    -- 商业发票。在岗员工从其公司向其他玩家发送银行发票；对方在银行应用中支付，
    -- 发送方会收到通知。仅在 QBCore/QBox 上有效（必须能解析在岗状态）；ESX 上
    -- 该区块隐藏，与工作标签页一样。
    -- 款项去向：有社团银行时，款项记入公司账户；否则回退到发送员工自己的银行
    -- 账户（见 bridge/server/society.lua）。每个公司的 `commission`（见下）会
    -- 把记入社团的款项分一部分给发送员工。
    InvoicesEnabled = true,
    -- Smallest and largest amount a single invoice may be for.
    -- 单张发票允许的最小和最大金额。
    MinInvoiceAmount = 1,
    MaxInvoiceAmount = 1000000,

    -- One entry per company. `job` is the framework job name (the key everything
    -- keys off). `coords` powers the client-side "Locate" waypoint. Listing a job
    -- here adds it to the public directory and enables Job Calls / company
    -- messaging; jobs NOT listed here still get the rest of the Actions tab (duty,
    -- bank, employees, quit) - they just won't appear in the directory.
    -- `canCall` + `callNumber` give the company a phone line. It is dialable two
    -- ways: the Call button in the Services app, and typing the number into the
    -- Phone dialer, so 911 rings every on-duty officer exactly as the button does.
    -- Either way it rings all on-duty employees who have Job Calls switched on,
    -- and the first to answer takes it. Give any company a number to make it
    -- reachable; leave canCall false and it stays directory-only.
    -- `bossGrade` is an ESX-ONLY fallback (overrides DefaultBossGrade for this
    -- company); QBCore/QBox ignore it and use the grade's isboss flag.
    -- `commission` is an OPTIONAL fraction 0.0-1.0 of a paid business invoice
    -- that goes to the sending employee, with the remainder going to the society
    -- account (the two always sum to the invoice amount, so no money is minted).
    -- Absent or 0 means the whole amount goes to the society. Only applies when a
    -- society bank is available; the no-society fallback already pays the sending
    -- employee in full, so no commission is split there.
    -- 每家公司一个条目。`job` 是框架工作名称（所有内容以此为键）。`coords`
    -- 驱动客户端“定位”路点。把工作列在这里会将其加入公开名录并启用工作呼叫/
    -- 公司消息；未列在这里的工作仍有操作标签页的其他功能（上下班、银行、员工、
    -- 辞职）- 只是不会出现在名录中。
    -- `canCall` + `callNumber` 给公司一条电话线。可通过两种方式拨打：服务应用
    -- 中的呼叫按钮，以及在手机拨号器输入号码，因此拨 911 和按钮一样会让所有
    -- 在岗警员响铃。无论哪种方式，都会呼叫所有开启了工作呼叫的在岗员工，最先
    -- 接听者接通。给任何公司一个号码即可让其可被拨打；canCall 留 false 则只在
    -- 名录中显示。
    -- `bossGrade` 是仅 ESX 的回退设置（覆盖本公司的 DefaultBossGrade）；
    -- QBCore/QBox 忽略它并使用职级的 isboss 标记。
    -- `commission` 是可选的 0.0-1.0 比例：已支付商业发票中分给发送员工的部分，
    -- 其余进入社团账户（两者之和始终等于发票金额，因此不会凭空生钱）。不填或
    -- 为 0 表示全额进入社团。仅在有社团银行时适用；无社团的回退路径已把全款
    -- 付给发送员工，因此那里不分成。
    -- 注：label/location 为名录中直接显示的文本（不走语言包），已汉化为中文。
    Companies = {
        {
            job = 'police',
            label = '警察局',
            location = '米申罗',
            color = '#0A84FF',
            emoji = '🚓',
            canCall = true,
            callNumber = '911',
            bossGrade = 3,
            coords = { x = 425.1, y = -979.5, z = 30.7 },
        },
        {
            job = 'ambulance',
            label = '急救中心',
            location = '皮尔博克斯',
            color = '#C0392B',
            emoji = '🚑',
            canCall = true,
            callNumber = '912',
            bossGrade = 3,
            coords = { x = 307.7, y = -1433.4, z = 29.9 },
        },
        {
            job = 'mechanic',
            label = '改车行',
            location = '洛圣都改车王',
            color = '#3A3A3C',
            emoji = '⚙️',
            canCall = false,
            bossGrade = 2,
            commission = 0.1,
            coords = { x = -347.3, y = -133.8, z = 39.0 },
        },
        {
            job = 'taxi',
            label = '出租车公司',
            location = '出租车总部',
            color = '#27AE60',
            emoji = '🚕',
            canCall = false,
            bossGrade = 2,
            commission = 0.15,
            coords = { x = 895.7, y = -179.3, z = 74.7 },
        },
    },
}
