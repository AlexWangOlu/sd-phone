-- Health. The client samples steps, on-foot distance and a simulated heart rate every
-- 250ms (client/apps/health.lua) and flushes the DELTAS to the server, which banks them
-- into one row per player per day in `phone_health_daily`. That table is what the 7-day
-- chart and the daily steps leaderboard both read.
-- 健康。客户端每 250ms 采样一次步数、步行距离和模拟心率
-- （client/apps/health.lua），并把增量提交给服务端；服务端将其按
-- “每玩家每天一行”存入 `phone_health_daily`。7 天图表和每日步数
-- 排行榜读取的都是这张表。
--
-- Steps are counted on the client, so the server treats every flush as a claim rather
-- than a fact: anything above what the elapsed time could physically produce is capped
-- to that ceiling. A cheat becomes an unremarkable number instead of a banned player.
-- 步数在客户端统计，因此服务端把每次提交都视为“申报”而非事实：任何超过
-- 经过时间在物理上可能产生的数值都会被压到上限。作弊只会得到一个不起眼的
-- 数字，而不是导致玩家被封禁。
return {
    -- Steps the summary ring fills to. Purely cosmetic; nothing gates on it.
    -- 摘要圆环填满所需的步数。纯装饰，没有任何功能以此为门槛。
    StepGoal = 10000,

    -- Days of daily rows kept per player. Older rows are pruned once on boot. The chart
    -- shows 7; the rest is headroom for anyone who wants to query further back.
    -- 每名玩家保留的每日数据天数。旧数据在启动时清理一次。图表显示 7 天；
    -- 多保留的部分留给想查询更早数据的人。
    RetentionDays = 30,

    Leaderboard = {
        -- Whether the Leaderboard tab appears at all. Off leaves Summary on its own.
        -- 是否显示排行榜标签页。关闭后只保留摘要页。
        Enabled = true,

        -- Players listed. The caller's own row is always returned alongside these, even
        -- when they rank below the cut.
        -- 列出的玩家数量。调用者自己的记录总会一并返回，即使排名在 cutoff 之后。
        Size = 20,
    },

    -- Ceilings the server applies per flush, per second of elapsed time. Both match the
    -- fastest the sampler could legitimately report: SPRINT cadence, and a sprint speed
    -- with headroom. Raise them only if a legitimate movement mode outruns them.
    -- 服务端按每次提交、按每秒经过时间施加的上限。两者都对应采样器合法上报
    -- 的最快情况：冲刺步频和留有余量的冲刺速度。只有当某种合法移动方式超过
    -- 它们时才调大。
    Limits = {
        StepsPerSecond    = 3.4,   -- 每秒步数上限
        MetresPerSecond   = 7.5,   -- 每秒米数上限

        -- Seconds of a single flush that count toward those ceilings. A player who was
        -- away far longer than the flush interval cannot bank the whole gap.
        -- 单次提交中计入这些上限的秒数。离开时间远长于提交间隔的玩家无法
        -- 把整段空档都计入。
        MaxElapsedSeconds = 120,
    },
}
