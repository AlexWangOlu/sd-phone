-- Ryde app settings. The destination list shown in "Where to?" (pickup is
-- always the rider's live position), plus the fare/payout rules.
-- Ryde（打车）应用设置。“去哪里？”中显示的目的地列表（上车点始终是乘客的
-- 实时位置），以及车费/支付规则。
return {
    -- Saved destinations offered in the Ryde "Where to?" picker. Riders can
    -- also drop a custom pin on the map; these are just the quick-pick shortcuts.
    -- `x`/`y` are GTA world coords (same projection the Maps app uses).
    -- Ryde“去哪里？”选择器中提供的预设目的地。乘客也可以在地图上放自定义
    -- 图钉；这些只是快捷选项。`x`/`y` 是 GTA 世界坐标（与地图应用使用相同
    -- 投影）。name/sub 为界面显示文本，已汉化。
    Locations = {
        { name = '军团广场',       sub = '洛圣都市中心',   x = 195.0,   y = -930.0 },
        { name = '洛圣都国际机场', sub = '洛圣都机场 T1',  x = -1037.0, y = -2738.0 },
        { name = '德尔佩罗码头',   sub = '德尔佩罗海滩',   x = -1850.0, y = -1240.0 },
        { name = '花园银行竞技场', sub = '拉普埃尔塔',     x = -250.0,  y = -2030.0 },
        { name = '好麦坞标志',     sub = '好麦坞山',       x = 720.0,   y = 1200.0 },
        { name = '维斯普奇海滩',   sub = '维斯普奇',       x = -1230.0, y = -1490.0 },
        { name = '沙滩海岸',       sub = '布雷恩郡',       x = 1960.0,  y = 3740.0 },
        { name = '佩立托湾',       sub = '北布雷恩郡',     x = -160.0,  y = 6360.0 },
        { name = '镜花公园',       sub = '东洛圣都',       x = 1140.0,  y = -645.0 },
        { name = '钻石赌场',       sub = '东好麦坞',       x = 925.0,   y = 46.0 },
    },

    -- Fraction of the agreed fare the driver actually receives on drop-off.
    -- 1.0 = the driver keeps the whole fare; 0.9 would skim a 10% platform cut.
    -- 送达后司机实际获得约定车费的比例。1.0 = 司机拿全部车费；0.9 表示平台
    -- 抽取 10%。
    DriverCut = 0.8,

    -- Guard rails on the fare a driver may quote (whole dollars).
    -- 司机可报价车费的护栏范围（整数美元）。
    MinFare = 1,
    MaxFare = 100000,

    -- Leaderboard ranking. Drivers are ranked by a confidence-weighted rating, so a
    -- driver with one lucky 5-star can't outrank a high-volume driver with a strong
    -- average. The score is:
    --     (avg_rating * trips + PriorRating * Weight) / (trips + Weight)
    -- Few trips -> the score sits near PriorRating; many trips -> it converges on the
    -- driver's true average. Higher Weight = more trips needed before a driver's own
    -- average outweighs the prior. (Defaults reproduce the original behaviour.)
    -- 排行榜排名。司机按置信度加权评分排名，因此一个只有一次幸运五星的司机
    -- 无法超过单量大、平均分高的司机。分数为：
    --     (平均评分 * 订单数 + PriorRating * Weight) / (订单数 + Weight)
    -- 订单少 -> 分数接近 PriorRating；订单多 -> 收敛到司机的真实平均分。
    -- Weight 越高，司机自身平均分超过先验值所需的订单数越多。（默认值复现
    -- 原始行为。）
    LeaderboardPriorRating = 4.5,
    LeaderboardWeight      = 10,
}
