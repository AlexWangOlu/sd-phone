-- Wallet / Banking app. The phone reads the player's framework bank balance (through the
-- multi-banking adapter in bridge/server/banking.lua) and keeps its own transaction log
-- (phone_bank_transactions) as the source of truth for the list - most banking resources
-- don't expose a portable "list transactions" API, so the phone records its own entries
-- and exposes an export others can use.
-- 钱包 / 银行应用。手机读取玩家的框架银行余额（通过 bridge/server/banking.lua
-- 的多银行适配器），并维护自己的交易记录（phone_bank_transactions）作为列表
-- 的数据来源 - 大多数银行资源不提供可移植的“列出交易”API，因此手机自行记录
-- 账目，并提供导出供其他资源使用。
return {
    TransactionLimit = 50,          -- most-recent transactions returned to the app 返回给应用的最近交易条数
    MinSend          = 1,           -- smallest allowed transfer 允许的最小转账额
    MaxSend          = 100000000,   -- transfer cap 转账上限

    -- Allow sending to a character who is currently offline (best-effort credit via a
    -- direct framework DB write). Only honoured when the active banking resource keeps
    -- balances in the framework account; own-table resources (wasabi, okok, prism, tgg,
    -- fd) require the recipient to be online.
    -- 允许向当前离线的角色转账（通过直接写框架数据库尽力入账）。仅当所用银行
    -- 资源把余额保存在框架账户中时有效；使用独立数据表的资源（wasabi、okok、
    -- prism、tgg、fd）要求收款方在线。
    AllowOffline     = true,

    -- Let the sender tick "Send Anonymously". Hides them from the RECIPIENT only: that row,
    -- statement and banner read "Anonymous" with no counterparty to send back to. Server-side
    -- logging is never anonymised, so sd-phone:server:banking:transfer still carries the real
    -- sender, with an `anonymous` flag alongside it.
    -- 允许付款人勾选“匿名发送”。仅对收款方隐藏：该条记录、账单和横幅显示为
    -- “匿名”，没有可回转的对方。服务端日志绝不会匿名，因此
    -- sd-phone:server:banking:transfer 仍带有真实付款人，并附带 `anonymous`
    -- 标记。
    AllowAnonymous   = true,

    -- The card shown at the top of the Wallet, and the default for a character who has never
    -- customised theirs. Brand ids: fleeca, maze, lombank, pacific, blaine. Colour and Pattern
    -- are optional overrides; leave them nil to use the bank's authentic pair.
    --   Colours:  emerald, crimson, cobalt, navy, bronze, graphite, teal, violet, slate,
    --             amber, rose, midnight, mint, burgundy
    --   Patterns: wave, meander, pinstripe, guilloche, crosshatch, chevron, dots, grid,
    --             diamond, scales, topo, circuit, carbon, none
    -- Locked = true forces this on everyone and hides the customiser. Purely cosmetic: every
    -- card reads the same framework account.
    -- 钱包顶部显示的银行卡，以及从未自定义过卡片的角色的默认样式。品牌 id：
    -- fleeca、maze、lombank、pacific、blaine。Color 和 Pattern 是可选覆盖；
    -- 留空 nil 使用银行官方配色组合。
    --   颜色：emerald（祖母绿）、crimson（绯红）、cobalt（钴蓝）、navy（藏青）、
    --         bronze（青铜）、graphite（石墨）、teal（青）、violet（紫）、
    --         slate（板岩）、amber（琥珀）、rose（玫瑰）、midnight（午夜）、
    --         mint（薄荷）、burgundy（酒红）
    --   图案：wave（波浪）、meander（回纹）、pinstripe（细条纹）、
    --         guilloche（花纹）、crosshatch（交叉影线）、chevron（锯齿）、
    --         dots（圆点）、grid（网格）、diamond（菱形）、scales（鳞片）、
    --         topo（地形线）、circuit（电路）、carbon（碳纤）、none（无）
    -- Locked = true 会强制所有人使用此卡并隐藏自定义入口。纯装饰：每张卡读取
    -- 的都是同一个框架账户。
    Card = {
        Brand   = 'fleeca',
        Color   = nil,
        Pattern = nil,
        Locked  = false,
    },

    -- Repeating transfers the player schedules from the Wallet. A due order is put through the
    -- ordinary transfer path, so it obeys MinSend/MaxSend behaviour, writes both statement rows
    -- and fires sd-phone:server:banking:transfer exactly like a manual send. The payer must be
    -- connected for the money to move (no framework has an offline debit); an order belonging to
    -- someone offline simply stays due and runs on their next connection.
    -- 玩家在钱包中设置的定期转账。到期订单走普通转账流程，因此遵守
    -- MinSend/MaxSend 规则、写入双方账单记录，并像手动转账一样触发
    -- sd-phone:server:banking:transfer。付款人必须在线资金才会移动（没有任何
    -- 框架支持离线扣款）；属于离线玩家的订单会保持到期状态，在其下次上线时
    -- 执行。
    StandingOrders = {
        Enabled   = true,
        MaxActive = 10,        -- orders one character may have switched on at once 一个角色可同时启用的订单数
        MinAmount = 1,         -- smallest allowed per-run amount 每次执行允许的最小金额
        MaxAmount = 1000000,   -- largest allowed per-run amount 每次执行允许的最大金额
    },

    -- Person-to-person invoicing from the Wallet's Invoices tab (business invoicing is
    -- configured in configs/services.lua and unaffected by this block).
    -- 钱包“发票”标签页中的个人对个人发票（商业发票在 configs/services.lua
    -- 中配置，不受此块影响）。
    PersonalInvoices = {
        Enabled    = true,
        MinAmount  = 1,        -- smallest allowed invoice 允许的最小发票金额
        MaxAmount  = 1000000,  -- largest allowed invoice 允许的最大发票金额
        MaxPending = 10,       -- outstanding unpaid invoices one sender may have at once 一个发送方同时可有的未付发票数
    },
}
