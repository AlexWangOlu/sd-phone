-- App accounts engine. Governs how many accounts one character may create in each app that
-- signs in through it (Photogram, Cherry, Vibez, Ryde, Squawk), and nothing else - Mail keeps
-- its own limit in configs/mail.lua.
-- 应用账户引擎。控制一个角色在通过该引擎登录的每个应用（Photogram、Cherry、
-- Vibez、Ryde、Squawk）中可创建的账户数量，仅此而已 - 邮件的限额在
-- configs/mail.lua 中单独设置。
return {
    -- Accounts one character may create per app. Their usernames must still differ, but the
    -- accounts may share a recovery email and phone number, so one person can run several
    -- handles from a single contact. 0 = unlimited.
    -- 一个角色在每个应用中可创建的账户数。用户名仍必须不同，但账户可以共用
    -- 恢复邮箱和电话号码，因此一个人可以用同一联系方式运营多个账号。0 = 不限。
    MaxPerApp = 3,

    -- Per-app overrides, keyed by app id. Anything left out uses MaxPerApp above.
    -- 按应用 ID 单独覆盖。未列出的应用使用上面的 MaxPerApp。
    PerApp = {
        -- photogram = 5,
        -- ryde      = 1,
        -- birdy     = 3,
    },
}
