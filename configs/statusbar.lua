-- Status bar - cosmetic carrier text + signal/battery indicators. The phone
-- has no real connectivity model yet, so these are static for now.
-- 状态栏 - 装饰性运营商文字 + 信号/电池图标。手机目前没有真实的信号连接模型，
-- 因此这些数值暂时是静态的。
return {
    Carrier      = 'LifeInvader', -- 运营商名称
    SignalBars   = 4,        -- 0..4 信号格数
    ShowWifi     = true,     -- 是否显示 Wi-Fi 图标
    BatteryStart = 100,      -- 0..100, ticks down while phone is open 初始电量（手机打开时持续下降）
}
