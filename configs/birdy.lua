-- Birdy app - the in-game microblog (posts, likes, follows, DMs, alerts).
-- Content is per-character, stored in the phone_birdy_* tables created on
-- resource start.
-- Birdy（Squawk）应用 - 游戏内微博（帖子、点赞、关注、私信、提醒）。
-- 内容按角色保存，存储在资源启动时创建的 phone_birdy_* 数据表中。
return {
    -- New profiles start unverified. Flip to true to hand everyone the blue
    -- check, or set a badge per-account with /birdyverify <handle> <type>.
    -- 新资料默认未认证。改为 true 可让所有人都有蓝勾，或用
    -- /birdyverify <账号名> <类型> 按账户单独设置徽章。
    DefaultVerified = false,

    -- Buying the blue check from inside the app (Profile > Edit profile).
    -- Only blue is ever purchasable: the gold business and grey government
    -- badges assert who someone is, so they stay staff-granted through the
    -- admin panel or /birdyverify. Set Enabled = false to hide the row.
    -- 在应用内购买蓝勾（资料 > 编辑资料）。只有蓝勾可以购买：金色商业徽章
    -- 和灰色政府徽章代表身份认证，因此只能由工作人员通过管理面板或
    -- /birdyverify 授予。设 Enabled = false 隐藏该入口。
    Verification = {
        Enabled = true,
        Price   = 25000,     -- 蓝勾价格
        Account = 'bank',    -- 扣款账户：bank 银行 / cash 现金
    },

    -- Max length of a post / reply body. Mirrors the React composer's
    -- maxLength so client and server agree.
    -- 帖子/回复正文的最大长度，与 React 编辑器的 maxLength 保持一致。
    MaxPostLength = 280,

    -- Max length of a direct message.
    -- 私信最大长度。
    MaxDmLength = 500,

    -- Polls. A post carries either a poll or media, never both, and the post
    -- body is the question. Options are 2 to MaxPollOptions choices.
    -- 投票。一个帖子只能带投票或媒体之一，帖子正文就是问题。选项数为
    -- 2 到 MaxPollOptions 个。
    MaxPollOptions      = 4,
    MaxPollOptionLength = 40,  -- 单个选项最大长度

    -- Durations the composer offers, in seconds. The server accepts only
    -- these exact values, so add a duration here and to the React composer
    -- together (web/src/apps/birdy/data.ts).
    -- 编辑器提供的投票时长（秒）。服务端只接受这些确切值，因此添加时长时
    -- 需同时改这里和 React 编辑器（web/src/apps/birdy/data.ts）。
    PollDurations = { 3600, 86400, 259200, 604800 },

    -- Posts returned per feed load (newest first).
    -- 每次加载信息流返回的帖子数（最新优先）。
    FeedLimit = 50,

    -- Days of post history the Search tab's trending-hashtag counts look at.
    -- 搜索标签页热门话题标签统计所看的帖子历史天数。
    TrendingWindowDays = 7,

    -- Notifications returned per alerts-tab load.
    -- 每次加载提醒标签页返回的通知数。
    NotificationLimit = 50,

    -- Who a new post notifies.
    --   'followers' - each of the author's followers, the way a real feed app does
    --   'everyone'  - every Squawk account on the server, so nobody misses a post
    --   false       - nobody; posts land silently and only likes, replies, reposts and follows
    --                 still notify
    -- (`true` is still read as 'followers'.)
    -- 新帖子通知谁。
    --   'followers' - 作者的每个粉丝，和真实社交应用一样
    --   'everyone'  - 服务器上每个 Squawk 账户，没人会错过帖子
    --   false       - 不通知任何人；帖子静默发布，只有点赞、回复、转发和关注
    --                 仍会通知
    -- （`true` 仍按 'followers' 处理。）
    --
    -- 'everyone' writes one notification row per account per post, so it scales as posts times
    -- players: fine for a small or news-driven server, heavy on a busy one where a prolific poster
    -- alerts the whole map every time they type.
    -- 'everyone' 会为每个帖子的每个账户写一条通知，规模随“帖子数 × 玩家数”
    -- 增长：小型或以新闻为主的服务器没问题，热闹服务器上高产用户每次发帖都
    -- 会惊动全图，负担较重。
    --
    -- A PROTECTED account always notifies its followers only, whatever this is set to. The alert
    -- carries a preview of the post body, so sending it server-wide would publish the very posts
    -- that account chose to keep to its followers.
    -- 受保护账户始终只通知粉丝，与本设置无关。通知会带帖子正文预览，全服
    -- 发送等于公开该账户选择只给粉丝看的帖子。
    PostNotifications = 'followers',

    -- Account field bounds, mirrored by the React register/login forms.
    -- 账户字段限制，与 React 注册/登录表单保持一致。
    MaxNameLength     = 32,   -- 昵称最大长度
    MinHandleLength   = 2,    -- 账号名最短长度
    MaxHandleLength   = 15,   -- 账号名最长长度
    MinPasswordLength = 4,    -- 密码最短长度
    MaxPasswordLength = 64,   -- 密码最长长度
    MaxBioLength      = 160,  -- 简介最大长度
}
