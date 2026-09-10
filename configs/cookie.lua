-- Cookie app (clicker mini-game) - per-character progress (cookies, upgrades,
-- achievements, rain toggle) persists server-side. The leaderboard ranks REAL
-- players by total cookies baked, shown by character name (or a custom alias).
-- Cookie 应用（点击小游戏）- 每个角色的进度（饼干数、升级、成就、下雨开关）
-- 保存在服务端。排行榜按累计烘焙饼干数对真实玩家排名，显示角色名（或自定义别名）。
return {
    LeaderboardLimit  = 25,   -- 排行榜显示人数
    MaxValue          = 1e15,  -- clamp saved cookies/earned to keep the board sane 限制保存的饼干/收入上限，避免排行榜数值失控
    MaxNicknameLength = 20,   -- 别名最大长度

    -- Clients autosave every couple of seconds, but those only update an
    -- in-memory cache server-side. Progress is written to the DB on this
    -- interval (seconds) plus on disconnect / resource stop - so the DB sees
    -- one batched write per player per interval, not one every few seconds.
    -- 客户端每隔几秒自动保存，但那只会更新服务端的内存缓存。进度会按此间隔
    -- （秒）以及玩家断开/资源停止时批量写入数据库 - 因此数据库每名玩家每个
    -- 间隔只收到一次批量写入，而不是每隔几秒一次。
    SaveInterval      = 60,
}
