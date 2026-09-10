-- Streaks app - one fresh camera photo per real-world day builds a consecutive-day
-- streak. Hitting a milestone pays out cash. Everyone's daily photos land in a
-- shared gallery (with likes) and a leaderboard ranks current streaks.
-- 连续打卡应用 - 每个现实日拍一张新的相机照片即可累积连续打卡天数。达到
-- 里程碑会发现金奖励。所有人的每日照片进入共享相册（可点赞），排行榜按
-- 当前连续天数排名。
return {
    -- Map of streak-day threshold -> cash reward. Re-earnable each run: because a
    -- streak only grows by 1 per day, each threshold is hit (and paid) exactly once
    -- per run, then again after a reset.
    -- 连续天数门槛 -> 现金奖励的映射。每轮都可重新赚取：因为连续天数每天
    -- 只增长 1，每个门槛每轮只会达成（并兑付）一次，重置后可再次达成。
    Milestones    = {
        [1]  = 100,   [3]  = 250,   [5]  = 500,   [8]  = 900,
        [12] = 1500,  [16] = 2200,  [21] = 3200,  [27] = 4500,
        [34] = 6500,  [42] = 9500,  [50] = 15000,
    },
    RewardAccount = 'bank',   -- where milestone cash is paid: 'bank' or 'cash' 里程碑奖金发放到哪里：'bank' 银行 或 'cash' 现金

    MaxCaptionLength = 120,   -- hard cap on the optional photo caption 可选照片说明的硬上限
    GalleryPageSize  = 30,    -- posts returned per gallery page (newest first) 相册每页返回的帖子数（最新优先）
    LeaderboardSize  = 25,    -- number of top current streaks shown 显示的当前连续打卡榜前列人数
}
