-- Lockscreen appearance.
-- 锁定屏幕外观。
return {
    -- Wallpaper name. Resolved by the React app's wallpaper registry
    -- (`web/src/shell/wallpapers.ts`) into a bundled JPG. Override by
    -- dropping a new file into `web/src/assets/wallpapers/`,
    -- registering it in `wallpapers.ts`, and putting the new key
    -- here.
    -- 壁纸文件名。由 React 端的壁纸注册表（`web/src/shell/wallpapers.ts`）
    -- 解析为打包进资源的 JPG。如需替换：把新文件放入
    -- `web/src/assets/wallpapers/`，在 `wallpapers.ts` 中注册，并把新的
    -- 键名填到这里。
    Wallpaper = 'homescreen.jpg',

    -- Show the date row above the time. Mirrors iOS - disabling
    -- gives the clock the full top half of the screen.
    -- 在时间上方显示日期行。与 iOS 一致 - 关闭后时钟将占据上半屏。
    ShowDate  = true,

    -- 24-hour or 12-hour clock. iOS default is the device locale;
    -- here we let the server author pick once.
    -- 24 小时制或 12 小时制。iOS 默认跟随设备地区设置；这里由服务器
    -- 作者统一选择。
    Use24Hour = false,
}
