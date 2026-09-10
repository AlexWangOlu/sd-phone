-- Maps app settings. Pin storage caps, the Set-GPS behaviour toggle, and
-- the live "you are here" location dot.
-- 地图应用设置。图钉存储上限、“设置 GPS”行为开关，以及实时“你在这里”
-- 定位点。
return {
    -- Maximum pins persisted per character. Extra pins in a save payload
    -- are dropped server-side (the array is kept in the UI's order, which
    -- is newest-first).
    -- 每个角色持久化的图钉上限。保存数据中多出的图钉由服务端丢弃（数组
    -- 按界面顺序保存，即最新的在前）。
    MaxMarkers = 50,

    -- Maximum characters kept from a pin label.
    -- 图钉标签保留的最大字符数。
    MaxLabel = 40,

    -- Close the phone when "Set GPS" is tapped, so the player immediately
    -- sees the route on the minimap. Set false to keep the phone open (the
    -- Maps app draws the same road-following route line itself).
    -- 点击“设置 GPS”时关闭手机，让玩家立即在小地图上看到路线。设为 false
    -- 则保持手机打开（地图应用会自行绘制同样的沿路路线）。
    CloseOnWaypoint = false,

    -- The People tab (live location sharing between players). false removes
    -- the tab from Maps entirely AND strips the live-share options from the
    -- chat location button, leaving only the one-time "share my current spot"
    -- confirm.
    -- “联系人”标签页（玩家之间实时位置共享）。false 会从地图中完全移除该
    -- 标签页，并从聊天位置按钮中去掉实时共享选项，只保留一次性的“分享我
    -- 当前位置”确认。
    People = true,

    -- Directions / ETA card (Apple-Maps style). Tapping a pin's navigate arrow
    -- shows distance + estimated time, then GO sets the minimap route.
    -- 路线/预计到达时间卡片（苹果地图风格）。点击图钉的导航箭头显示距离和
    -- 预计时间，点击“出发”设置小地图路线。
    Navigation = {
        -- Assumed average speeds (metres/second) used to estimate arrival time.
        -- These are steady cruising figures (not the player's instantaneous
        -- speed) so the ETA doesn't jump around at red lights. ~16 m/s ≈ 36 mph
        -- average city driving; 1.7 m/s is a brisk walk.
        -- 用于估算到达时间的平均速度（米/秒）。这些是稳定巡航数值（不是玩家
        -- 的瞬时速度），因此预计时间不会在红灯时乱跳。约 16 m/s ≈ 58 km/h
        -- 的城市平均车速；1.7 m/s 是快步走。
        DriveSpeed = 16.0,
        WalkSpeed  = 1.7,

        -- 'metric'  → metres / kilometres.
        -- 'imperial'→ feet / miles.
        -- 'metric'  → 米 / 公里。
        -- 'imperial'→ 英尺 / 英里。
        Units = 'metric',

        -- How often (ms) the open ETA card refreshes its distance/time while you
        -- move. The card polls the client for a fresh road-distance reading.
        -- 移动时，打开的预计时间卡片刷新距离/时间的间隔（毫秒）。卡片会向
        -- 客户端轮询最新的道路距离读数。
        RefreshInterval = 2500,
    },

    -- Live "you are here" dot (Apple-Maps style) shown on the Maps app.
    -- 地图应用中显示的实时“你在这里”定位点（苹果地图风格）。
    LiveLocation = {
        -- Master switch. false = no dot, and the client never starts the
        -- position-streaming thread.
        -- 总开关。false = 不显示定位点，客户端也永不启动位置推送线程。
        Enabled = true,

        -- Milliseconds between position pushes while the Maps app is open.
        -- 300ms is smooth without being chatty; the stream only runs while
        -- the Maps app is actually on screen.
        -- 地图应用打开时，位置推送的间隔（毫秒）。300ms 流畅又不过于频繁；
        -- 推送流只在地图应用真正显示时运行。
        Interval = 300,
    },
}
