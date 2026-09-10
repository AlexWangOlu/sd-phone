-- Stocks app - a shared, server-simulated market the whole server sees the same
-- prices on. Players move money from their bank into a separate brokerage wallet,
-- then buy/sell. Holdings, wallet cash, and prices persist in the DB.
-- 股票应用 - 全服务器共享、由服务端模拟的市场，所有人看到相同价格。玩家把钱从
-- 银行转入独立的券商钱包，然后买入/卖出。持仓、钱包现金和价格都持久化到数据库。
--
-- 注意：`symbol`（代码）是交易和存储用的键，绝不能改；`name` 是纯显示名称
-- （前端 StockRow/AssetDetail 直接渲染），这里保留 GTA 戏仿品牌英文原名，服主
-- 可按需自行翻译为中文（如 Maze Bank = 花园银行、Ammu-Nation = 武装国度）。

return {
    TickSeconds   = 5,      -- how often every price moves 每个价格多久变动一次
    HistoryPoints = 48,     -- price points kept per asset (drives the sparkline + % change) 每个资产保留的价格点数（决定迷你走势图和涨跌幅）
    SaveSeconds   = 30,     -- batched DB write of prices + wallets 价格与钱包的批量写库间隔
    Commission    = 0.005,  -- trade fee as a fraction, charged on buys AND sells (0.005 = 0.5%) 交易手续费比例，买入和卖出都收（0.005 = 0.5%）
    StartingCash  = 0,      -- brokerage wallet starts empty; players deposit from their bank 券商钱包初始为空；玩家从银行存入
    MinTrade      = 1,      -- smallest dollar value of a buy/sell/deposit/withdraw 买入/卖出/存入/取出的最小金额
    MaxTrade      = 1e9,    -- safety clamp on a single order's dollar value 单笔订单金额的安全上限

    -- Global magnitude knobs. A move happens every TickSeconds, so the per-asset
    -- numbers below are scaled DOWN by these before each tick - that's what keeps
    -- the market drifting realistically (a percent or two over many minutes)
    -- instead of swinging double digits in a couple of minutes. Raise these to
    -- make the whole market livelier, lower them to calm it further.
    -- 全局幅度调节。每个 TickSeconds 都会发生一次变动，因此下面每个资产的数值
    -- 在每次 tick 前会先乘以这些系数缩小 - 这样市场才会像现实一样缓慢漂移
    -- （许多分钟才波动一两个百分点），而不是几分钟内就涨跌两位数。调高让整个
    -- 市场更活跃，调低让它更平稳。
    VolatilityScale = 0.06,   -- multiplies every asset's `volatility` 乘以每个资产的 `volatility`（波动）
    DriftScale      = 0.012,  -- multiplies every asset's `trend` 乘以每个资产的 `trend`（趋势）

    -- Market impact - big trades move the SHARED price. Buying pumps it, selling
    -- dumps it:  move% = ImpactScale * orderValue / liquidity  (capped at
    -- MaxImpact), applied on every buy/sell. Lower liquidity = easier to move.
    -- Any asset may override the depth with its own `liquidity = <dollars>`.
    -- 市场冲击 - 大额交易推动共享价格。买入会拉抬，卖出会打压：
    -- 变动% = ImpactScale * 订单金额 / liquidity（上限为 MaxImpact），每次
    -- 买/卖都会应用。流动性越低越容易推动价格。任何资产都可以用自己的
    -- `liquidity = <金额>` 覆盖市场深度。
    ImpactScale = 0.5,        -- 0.5 ⇒ a $1M order at the default depth moves price ~25% 0.5 ⇒ 默认深度下 100 万美元订单推动价格约 25%
    Liquidity   = 2000000,    -- default market depth (dollars) per asset 每个资产的默认市场深度（美元）
    MaxImpact   = 0.5,        -- hard cap on one order's price move (fraction) 单笔订单价格变动的硬上限（比例）

    -- Ownership / shares outstanding. Each asset has a fixed total supply of
    -- shares = MarketCap / basePrice, almost all of it held by "the market" (the
    -- institutional float). A player's stake is units / total supply, so buying a
    -- little shows as a tiny %, not 100%. A holder's % of supply ≈ their dollars
    -- invested / MarketCap. Bigger MarketCap = harder to corner; an asset may
    -- override with its own `marketCap = <dollars>`.
    -- 所有权 / 流通股。每个资产的固定总股数 = MarketCap / basePrice，其中绝大
    -- 部分由"市场"（机构流通盘）持有。玩家的持股比例 = 持股数 / 总股数，所以
    -- 买一点只会显示极小的百分比，而不是 100%。持有者占比 ≈ 其投入金额 /
    -- MarketCap。MarketCap 越大越难坐庄；资产可用自己的 `marketCap = <金额>`
    -- 覆盖。
    MarketCap      = 50000000,  -- default valuation (sets the share count) 默认估值（决定股数）
    WhaleThreshold = 0.1,       -- flag a holder as a "whale" at this share of supply 持股占比达到此值时标记为"巨鲸"

    -- Each tick every asset moves by:
    -- 每个 tick 每个资产的变动公式：
    --   movePct = trend*DriftScale + volatility*VolatilityScale * gaussian()
    -- then the new price is clamped to [min, max]. Per asset you tune the
    -- RELATIVE aggressiveness; the *Scale values above set the overall magnitude:
    -- 然后新价格被夹在 [min, max] 区间。每个资产调整的是相对激进程度；上面的
    -- *Scale 值决定整体幅度：
    --   trend       directional bias  (+ = upward, - = downward, 0 = flat) 方向偏向（+ = 上涨，- = 下跌，0 = 横盘）
    --   volatility  jumpiness - relative std-dev of the move (crypto > stocks) 跳动幅度 - 变动的相对标准差（加密货币 > 股票）
    --   min / max   hard price floor & ceiling 价格硬性下限与上限
    --   basePrice   seed price on first ever boot (after that the live price persists) 首次启动的种子价格（之后实时价格持久化）
    --   kind        'stock' or 'crypto' - routes the asset to the matching tab 'stock'（股票）或 'crypto'（加密货币）- 决定资产进入哪个标签页
    --   color       brand colour for the round token + sparkline accent 圆形图标和走势图强调色所用的品牌颜色
    Assets = {
        -- Stocks (GTA brands) 股票（GTA 品牌）
        { symbol = 'MZB', name = 'Maze Bank',      kind = 'stock', color = '#C0392B', basePrice = 215.40, volatility = 0.012, trend =  0.0008, min = 40,  max = 600,  marketCap = 250000000 },
        { symbol = 'TNK', name = 'Tinkle',         kind = 'stock', color = '#00B7EB', basePrice =  88.10, volatility = 0.018, trend =  0.0015, min = 10,  max = 400  },
        { symbol = 'VAP', name = 'Vapid',          kind = 'stock', color = '#2C3E50', basePrice = 142.75, volatility = 0.014, trend =  0.0004, min = 30,  max = 400  },
        { symbol = 'ECL', name = 'eCola',          kind = 'stock', color = '#E2231A', basePrice =  53.20, volatility = 0.013, trend = -0.0006, min = 10,  max = 200  },
        { symbol = 'SPK', name = 'Sprunk',         kind = 'stock', color = '#2ECC71', basePrice =  31.65, volatility = 0.020, trend =  0.0010, min = 5,   max = 150  },
        { symbol = 'CLK', name = "Cluckin' Bell",  kind = 'stock', color = '#F4C20D', basePrice =  24.90, volatility = 0.017, trend = -0.0012, min = 4,   max = 120  },
        { symbol = 'BSH', name = 'Burger Shot',    kind = 'stock', color = '#E4002B', basePrice =  19.30, volatility = 0.019, trend =  0.0006, min = 3,   max = 100  },
        { symbol = 'LFI', name = 'Lifeinvader',    kind = 'stock', color = '#2D6CDF', basePrice =  96.55, volatility = 0.025, trend = -0.0020, min = 8,   max = 400  },
        { symbol = 'MAI', name = 'Maibatsu',       kind = 'stock', color = '#8E8E93', basePrice =  64.20, volatility = 0.015, trend =  0.0009, min = 12,  max = 250  },
        { symbol = 'FLY', name = 'FlyUS',          kind = 'stock', color = '#1E66D0', basePrice =  12.45, volatility = 0.022, trend = -0.0008, min = 2,   max = 80   },
        { symbol = 'AMU', name = 'Ammu-Nation',    kind = 'stock', color = '#6B8E23', basePrice = 178.00, volatility = 0.016, trend =  0.0014, min = 40,  max = 500  },
        { symbol = 'RWD', name = 'Redwood',        kind = 'stock', color = '#8B0000', basePrice =  41.10, volatility = 0.012, trend = -0.0015, min = 8,   max = 150  },
        { symbol = 'RON', name = 'RON Oil',        kind = 'stock', color = '#ED1C24', basePrice = 134.60, volatility = 0.018, trend =  0.0010, min = 25,  max = 500  },
        { symbol = 'GPO', name = 'GoPostal',       kind = 'stock', color = '#1B5E20', basePrice =  47.80, volatility = 0.012, trend =  0.0003, min = 8,   max = 200  },
        { symbol = 'BIL', name = 'Bilkinton',      kind = 'stock', color = '#16A085', basePrice = 162.30, volatility = 0.020, trend =  0.0018, min = 30,  max = 500  },
        { symbol = 'FRT', name = 'Fruit',          kind = 'stock', color = '#9AA0A6', basePrice = 305.10, volatility = 0.016, trend =  0.0020, min = 60,  max = 900  },
        { symbol = 'VAN', name = 'Vangelico',      kind = 'stock', color = '#D4AF37', basePrice =  71.40, volatility = 0.014, trend =  0.0005, min = 15,  max = 250  },
        { symbol = 'WIZ', name = 'Whiz Wireless',  kind = 'stock', color = '#7B2FF7', basePrice =  58.90, volatility = 0.020, trend =  0.0012, min = 12,  max = 250  },
        { symbol = 'DY8', name = 'Dynasty 8',      kind = 'stock', color = '#B8860B', basePrice = 210.75, volatility = 0.015, trend =  0.0016, min = 40,  max = 600  },
        { symbol = 'PIS', name = 'Pisswasser',     kind = 'stock', color = '#C9A227', basePrice =  27.85, volatility = 0.018, trend = -0.0004, min = 5,   max = 120  },

        -- Crypto (GTA-flavoured) 加密货币（GTA 风味）
        { symbol = 'SDC', name = 'SD Coin',        kind = 'crypto', color = '#2A7DE1', basePrice =   88.00, volatility = 0.040, trend =  0.0030, min = 5,    max = 5000,   marketCap = 35000000 },
        { symbol = 'BTL', name = 'BitLos',         kind = 'crypto', color = '#F7931A', basePrice = 38250.0, volatility = 0.030, trend =  0.0020, min = 5000, max = 150000 },
        { symbol = 'ETD', name = 'Etheriad',       kind = 'crypto', color = '#627EEA', basePrice = 2410.0,  volatility = 0.035, trend =  0.0025, min = 300,  max = 12000  },
        { symbol = 'SPC', name = 'SprunkCoin',     kind = 'crypto', color = '#FF7A00', basePrice =    4.82, volatility = 0.060, trend =  0.0010, min = 0.2,  max = 60,     marketCap = 6000000 },
        { symbol = 'MZC', name = 'MazeCoin',       kind = 'crypto', color = '#9B59B6', basePrice =   67.40, volatility = 0.050, trend = -0.0020, min = 5,    max = 500    },
        { symbol = 'FLC', name = 'FleecaCoin',     kind = 'crypto', color = '#00B894', basePrice =    9.42, volatility = 0.050, trend =  0.0020, min = 1,    max = 200    },
        { symbol = 'WZC', name = 'WeazelCoin',     kind = 'crypto', color = '#C8102E', basePrice =    0.85, volatility = 0.070, trend =  0.0010, min = 0.05, max = 25,     marketCap = 4000000 },
        { symbol = 'POG', name = 'PogoCoin',       kind = 'crypto', color = '#F1C40F', basePrice =    2.36, volatility = 0.065, trend = -0.0010, min = 0.1,  max = 40     },
        { symbol = 'VWC', name = 'VinewoodCoin',   kind = 'crypto', color = '#8E44AD', basePrice =  410.00, volatility = 0.040, trend =  0.0030, min = 40,   max = 8000   },
        { symbol = 'KIF', name = 'Kifflom Coin',   kind = 'crypto', color = '#1ABC9C', basePrice =   33.00, volatility = 0.055, trend =  0.0025, min = 3,    max = 800    },
    },
}
