-- Casino app (Blackjack, Baccarat, Crash, Roulette, Slots, Texas Hold'em). Table limits and
-- cadence only: the reel strips, the paytable, the roulette odds, the baccarat commission and the
-- crash curve are fixed in server/games/casino/* because they set the house edge (slots 4.65%,
-- roulette 2.70%, baccarat 1.06% on Banker, crash a flat 3.00%, hold'em rake-free) and a wrong
-- value there is invisible until it is expensive. Blackjack keeps its own limits in
-- server/games/blackjack.lua.
-- 赌场应用（21点、百家乐、崩盘、轮盘、老虎机、德州扑克）。这里只有桌台限额和
-- 节奏参数：转轮条带、赔付表、轮盘赔率、百家乐佣金和崩盘曲线固定在
-- server/games/casino/* 中，因为它们决定庄家优势（老虎机 4.65%、轮盘 2.70%、
-- 百家乐庄位 1.06%、崩盘固定 3.00%、德州扑克无抽成），那里的错误值在造成
-- 巨大损失前都无迹可寻。21点在 server/games/blackjack.lua 中保留自己的限额。
return {
    -- Which games the Casino app offers. A game switched off here is hidden from the lobby and
    -- its server callbacks refuse, so it cannot be reached by a tampered page either. Omitting a
    -- game from this table leaves it on, so an older config keeps every game.
    -- 赌场应用提供哪些游戏。在此关闭的游戏会从大厅隐藏，且其服务端回调会
    -- 拒绝请求，因此被篡改的页面也无法进入。从此表中省略某个游戏会保持其
    -- 开启，因此旧配置会保留所有游戏。
    Games = {
        blackjack = true,  -- 21点
        holdem    = true,  -- 德州扑克
        crash     = true,  -- 崩盘
        baccarat  = true,  -- 百家乐
        roulette  = true,  -- 轮盘
        slots     = true,  -- 老虎机
    },

    Slots = {
        MinLineBet   = 5,      -- 单线最小下注
        MaxLineBet   = 5000,   -- x5 lines, so 25,000 chips is the biggest slots stake x5 条线，最大总下注 25,000 筹码
        SpinCooldown = 700,    -- ms between spins, per character 每个角色两次转动之间的冷却（毫秒）
    },
    Roulette = {
        MinChip       = 5,      -- 最小筹码
        MaxTotalStake = 25000, -- summed across every bet on one spin 一次转动所有下注的总和上限
        MaxBets       = 20,    -- distinct bet entries per spin 每次转动可下的不同注单项数
        SpinCooldown  = 1200,  -- 转动冷却（毫秒）
    },
    Baccarat = {
        MinBet       = 25,      -- 最小下注
        MaxBet       = 100000, -- per main spot (Player / Banker / Tie) 每个主位（闲/庄/和）
        MaxSideBet   = 10000,  -- per pair spot 每个对子位
        MaxTotal     = 200000, -- summed across every spot on one hand 一手牌所有位置的总和上限
        DealCooldown = 800,    -- 发牌冷却（毫秒）
    },
    Crash = {
        MinBet        = 25,     -- 最小下注
        MaxBet        = 50000,  -- 最大下注
        BettingMs     = 12000,  -- 下注阶段时长（毫秒）
        BustHoldMs    = 5000,   -- 崩盘后停留时长（毫秒）
        MaxMultiplier = 100,   -- 100.00x ceiling; the round busts here at the latest 100.00 倍上限；回合最迟到此必崩
        HistorySize   = 20,     -- 历史记录条数
    },
    Holdem = {
        ActionSeconds     = 20,   -- 行动限时（秒）
        ShowHandStrength  = true,  -- name the hand you currently hold above your action buttons 在行动按钮上方显示当前手牌牌型名称
        Tables = {
            { id = 'low',  name = 'Sandy Shores', sb = 25,  bb = 50,   minBuyIn = 2000,  maxBuyIn = 10000 },
            { id = 'mid',  name = 'Vinewood',     sb = 100, bb = 200,  minBuyIn = 8000,  maxBuyIn = 40000 },
            { id = 'high', name = 'Diamond',      sb = 500, bb = 1000, minBuyIn = 40000, maxBuyIn = 200000 },
        },
        -- Tables players open themselves, alongside the house rooms above. Every value a player
        -- sends is clamped into these bounds server-side, so widening a bound here is the only way
        -- to widen what a table can be set to.
        -- 玩家自行开设的牌桌，与上面的官方房间并列。玩家发送的每个值都会在
        -- 服务端被夹取到这些范围内，因此只有在这里放宽范围，才能放宽牌桌
        -- 可设置的数值。
        PlayerTables = {
            Enabled      = true,
            MaxPerPlayer = 1,     -- tables one character may have open at a time 一个角色同时可开的牌桌数
            MaxTotal     = 8,     -- player tables on the floor at once, house rooms not counted 场上同时存在的玩家牌桌总数（不含官方房间）
            MinBlind     = 5,     -- smallest small blind that can be picked 可选的最小小盲注
            MaxBlind     = 2500,  -- largest small blind that can be picked 可选的最大小盲注
            MinBuyInBB   = 20,    -- floor on the min buy in, counted in big blinds 最小买入下限（以大盲注计）
            MaxBuyInBB   = 400,   -- ceiling on the max buy in, counted in big blinds 最大买入上限（以大盲注计）
            NameMax      = 24,    -- characters kept from the name the creator typed 创建者输入的桌名保留字符数
            EmptyMinutes = 5,     -- an empty player table is closed after this long 空桌在多少分钟后关闭
        },
    },
}
