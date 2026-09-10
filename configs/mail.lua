-- Mail app - iOS-style email between players. Accounts are globally
-- addressable (one row per email) with a password gate, so any player who
-- knows the credentials can log into the account on their own phone. Sessions
-- persist by citizenid so reconnecting doesn't sign you out.
-- 邮件应用 - 玩家之间的 iOS 风格电子邮件。账户全局可寻址（每个邮箱一行数据）
-- 并有密码保护，因此任何知道凭据的玩家都能在自己手机上登录该账户。会话按
-- citizenid 持久化，重连不会退出登录。
return {
    -- The one email domain players register under. Sign-up asks for the
    -- username only and the domain is appended server-side; full addresses
    -- on any other domain are rejected.
    -- 玩家注册时使用的唯一邮箱域名。注册只要求输入用户名，域名由服务端
    -- 追加；使用其他域名的完整地址会被拒绝。
    Domain = 'lifeinvader.com',

    -- Per-player cap on simultaneously logged-in accounts. How many a character may CREATE is
    -- configs/accounts.lua (Accounts.PerApp.mail, else MaxPerApp), shared with every other app;
    -- keep this at or above that or a player cannot hold all the mailboxes they are allowed.
    -- 每名玩家同时登录账户的上限。一个角色可以创建多少个账户由
    -- configs/accounts.lua 决定（Accounts.PerApp.mail，否则用 MaxPerApp），
    -- 该限制与其他所有应用共享；请把此值设为不低于那个值，否则玩家无法持有
    -- 其被允许拥有的全部邮箱。
    MaxAccountsPerPlayer = 3,

    -- Hard cap on stored messages per account. Once exceeded, the oldest
    -- messages are pruned. Tunes the JSON row size.
    -- 每个账户存储邮件的硬上限。超出后删除最旧的邮件。用于控制 JSON 数据行
    -- 大小。
    MaxMessagesPerAccount = 200,

    -- Email format constraints. Min/max apply to the full "local@domain"
    -- string. The regex is intentionally permissive - anything with a `@`
    -- separator and non-empty local + host parts passes.
    -- 邮箱格式限制。最小/最大长度作用于完整的“用户名@域名”字符串。正则
    -- 有意保持宽松 - 只要有 `@` 分隔符且用户名和主机部分非空即可通过。
    MinEmailLength = 5,
    MaxEmailLength = 64,

    -- Password length constraints. Hashing is done server-side before
    -- storage; the plaintext never persists.
    -- 密码长度限制。哈希在服务端存储前完成；明文永不持久化。
    MinPasswordLength = 6,
    MaxPasswordLength = 64,

    -- Display-name constraints (the "Personal" / "Work" label).
    -- 显示名称限制（“个人”/“工作”标签）。
    MinNameLength = 1,
    MaxNameLength = 40,

    -- Max saved compose addresses kept per character.
    -- 每个角色保存的收件人地址上限。
    MaxSavedEmails = 100,
}
