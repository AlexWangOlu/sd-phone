-- Keyword watchlist. A sweep reads what players have posted across the phone's apps and files
-- anything matching a rule into the admin panel's Flags queue, so staff review a short list
-- instead of scrolling every app hoping to catch something.
-- 关键词监控列表。扫描任务会读取玩家在手机各应用中发布的内容，把匹配规则的
-- 内容归入管理面板的“标记（Flags）”队列，工作人员只需审阅一个短列表，而不用
-- 翻遍每个应用去碰运气。
--
-- Nothing here punishes anyone: a flag is a queue entry an admin still has to act on, and the
-- sweep only ever reads. The rules ship deliberately thin, because what counts as a breach is a
-- server's own decision - the examples below are the shapes that are near-universally unwanted
-- (out-of-character contact and real-money trading), not a moderation policy.
-- 这里的任何内容都不会惩罚玩家：标记只是队列条目，仍需管理员处理，且扫描任务
-- 只读不写。自带的规则有意保持精简，因为何为违规由服务器自己决定 - 下面的
-- 示例是几乎所有人都不想要的类型（角色外联系方式和现实金钱交易），而不是一套
-- 管理政策。
return {
    -- Whether the sweep runs at all. With this off the Flags tab still lists whatever was filed
    -- before, and "Scan now" still works: only the timer stops.
    -- 扫描任务是否运行。关闭后“标记”标签页仍会列出之前归入的内容，“立即扫描”
    -- 也仍然可用：只有定时任务停止。
    Enabled = true,

    -- Minutes between automatic sweeps. 0 leaves it to the panel's "Scan now" button.
    -- 自动扫描的间隔（分钟）。0 表示只用面板的“立即扫描”按钮手动触发。
    SweepMinutes = 30,

    -- How far back a sweep reads, in hours. A flag is filed once per rule per row, so a longer
    -- window costs reading, never duplicates.
    -- 扫描回溯的时长（小时）。每条规则对每行内容只归入一次标记，因此更长的
    -- 窗口只增加读取量，绝不会产生重复。
    LookbackHours = 24,

    -- Rows one sweep reads per app before it stops, whichever comes first with LookbackHours.
    -- 单次扫描每个应用读取的行数上限，与 LookbackHours 先到为准。
    MaxRowsPerApp = 400,

    -- Apps the sweep reads. Each name is a content adapter in server/admin/store.lua.
    -- 扫描读取的应用。每个名称对应 server/admin/store.lua 中的一个内容适配器。
    --
    -- Mail is deliberately absent: it keeps every message inside a JSON column on the mailbox
    -- rather than as rows, so a sweep would have to open each mailbox in turn. Search the Mail
    -- tab instead, where the filter does reach message bodies.
    -- 邮件（Mail）有意不在其中：它把所有消息存在邮箱的 JSON 列里而不是独立行，
    -- 扫描只能逐个打开邮箱。请改用邮件标签页的搜索，那里的过滤可以触及邮件
    -- 正文。
    Apps = {
        'birdy', 'messages', 'darkchat', 'photogram', 'vibez',
        'marketplace', 'pages', 'cherry', 'weazelnews', 'notes',
    },

    -- Rules, checked against the lowercased text of each row.
    -- 规则，按每行内容的小写文本匹配。
    --
    --   id        stable key; the flag is filed once per row per id, so renaming one re-files it
    --             稳定键名；每条规则对每行内容只归入一次标记，重命名 id 会重新归入
    --   label     what the queue shows
    --             队列中显示的名称（已汉化）
    --   patterns  Lua patterns, already lowercase. `%` escapes a magic character, so a literal
    --             dot is `%.` and a literal dash is `%-`.
    --             Lua 模式匹配，需已小写。`%` 用于转义魔法字符，因此字面句点
    --             写作 `%.`，字面连字符写作 `%-`。
    Rules = {
        {
            id    = 'ooc-contact',
            label = '角色外（OOC）联系方式',
            patterns = { 'discord%.gg/', 'discord%.com/invite', 'teamspeak', 'ts3server', 'steamcommunity%.com' },
        },
        {
            id    = 'real-money',
            label = '现实金钱交易',
            patterns = { 'paypal', 'cash ?app', 'venmo', 'real money', 'irl cash', 'irl money' },
        },
        -- Left empty on purpose. Fill it with the words your server actually bans; there is no
        -- list that is right for every community, and shipping someone else's is worse than
        -- shipping none.
        -- 有意留空。请填入你的服务器实际封禁的词汇；没有适合所有社区的词表，
        -- 附带别人的词表比不附更糟。
        {
            id    = 'slurs',
            label = '违禁词汇',
            patterns = {},
        },
    },
}
