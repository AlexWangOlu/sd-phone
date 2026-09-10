-- Weather app - pulls live in-game weather + world time from whichever
-- weathersync is running, so the Los Santos forecast reflects the real server
-- state and the day/night background follows the GTA clock. Supported syncs are
-- auto-detected; weather + time still work (off game natives) even with none.
-- 天气应用 - 从正在运行的天气同步资源获取游戏内实时天气和世界时间，因此
-- 洛圣都天气预报反映服务器真实状态，昼夜背景跟随 GTA 时钟。受支持的同步
-- 资源会自动检测；即使一个都没有，天气和时间仍可基于游戏原生功能工作。
--
-- Note: neither supported sync models a real temperature / humidity / UV /
-- multi-day forecast - GTA has no such concept - so those stay derived in the
-- app from the live weather + each city's climate profile.
-- 注意：受支持的同步资源都不提供真实温度/湿度/紫外线/多日预报 - GTA 没有
-- 这些概念 - 因此这些数据仍由应用根据实时天气和每个城市的气候档案推算。
return {
    Enabled = true,  -- 是否启用天气应用

    -- 'auto' picks the first started resource from the list below. Set an exact
    -- name to force one. The native fallback means weather/time work regardless.
    -- 'auto' 会从下面列表中选择第一个已启动的资源。填写确切名称可强制指定。
    -- 原生兜底保证天气/时间无论如何都能工作。
    System = 'auto',

    -- Checked in order when System = 'auto'. Add a custom/renamed sync here.
    -- System = 'auto' 时按此顺序检查，可在此添加自定义或改名的同步资源。
    Resources = { 'Renewed-Weathersync', 'qb-weathersync' },
}
