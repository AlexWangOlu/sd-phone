-- Weazel News app - the in-world Los Santos broadcast network. Articles and the
-- red "Breaking" ticker are stored in the database (both start empty) and edited
-- in-app by news staff. Everyone can read; only staff can publish.
-- Weazel News 应用 - 游戏内的洛圣都广播网络。文章和红色“突发新闻”滚动条
-- 存储在数据库中（初始均为空），由新闻工作人员在应用内编辑。所有人都能
-- 阅读，只有工作人员可以发布。
return {
    -- Framework job name(s) whose players staff Weazel News: the cogwheel
    -- dashboard, post/edit/delete, and the breaking-headline editor.
    -- 任职 Weazel News 的框架工作名称：可使用齿轮仪表盘、发布/编辑/删除
    -- 以及突发头条编辑器。
    Jobs           = { 'reporter' },

    -- When true, only a boss of a listed job manages (QBCore/QBox `isboss` flag;
    -- ESX uses BossGrade below), optionally widened by ManageMinGrade. When false,
    -- ANYONE on a listed job can manage at any grade - use this when the job has
    -- no boss flag (e.g. a `reporter` job whose top grade isn't flagged `isboss`).
    -- 为 true 时，只有所列工作的老板能管理（QBCore/QBox 的 `isboss` 标记；
    -- ESX 使用下面的 BossGrade），可用 ManageMinGrade 放宽。为 false 时，
    -- 所列工作中的任何人、任何职级都能管理 - 当工作没有老板标记时使用
    -- （例如最高职级未标记 `isboss` 的 `reporter` 工作）。
    CheckIsBoss    = false,

    -- ESX-only boss threshold (ESX has no `isboss` flag): grade >= this on a
    -- listed job counts as boss.
    -- 仅 ESX 的老板门槛（ESX 没有 `isboss` 标记）：所列工作中职级 >= 此值
    -- 即视为老板。
    BossGrade      = 0,

    -- Optional grade threshold, only used when CheckIsBoss = true. When set, a
    -- player on a listed job at grade >= this can manage even without the boss
    -- flag - e.g. 3 lets grade-3 "editor" ranks publish. Leave nil for boss only.
    -- 可选职级门槛，仅在 CheckIsBoss = true 时使用。设置后，所列工作中职级
    -- >= 此值的玩家即使没有老板标记也能管理 - 例如设为 3 可让 3 级“编辑”
    -- 职级发布内容。留空 nil 表示仅限老板。
    ManageMinGrade = nil,

    -- Hard caps for staff-authored content.
    -- 工作人员创作内容的硬上限。
    MaxHeadlineLength = 140,  -- 标题最大长度
    MaxDekLength      = 240,  -- 副标题最大长度
    MaxBodyLength     = 8000,   -- whole article body (all paragraphs) 整篇文章正文（所有段落）
    MaxImageUrlLength = 512,   -- 图片链接最大长度
    MaxBreakingLines  = 8,      -- ticker headlines kept, in order 滚动条保留的头条数（按顺序）
    MaxBreakingLength = 200,    -- per ticker line 每条滚动条文字长度

    -- Most-recent articles returned to the app.
    -- 返回给应用的最近文章数。
    ArticlesPerFeed   = 60,

    -- Allowed article categories. Must match the web `Category` union in
    -- web/src/apps/weazelnews/data.ts.
    -- 允许的文章分类。必须与 web/src/apps/weazelnews/data.ts 中的
    -- `Category` 联合类型一致（值请勿翻译，前端按英文值匹配）。
    Categories = { 'Local', 'Crime', 'Politics', 'Business', 'Sports', 'Entertainment', 'Tech', 'Weather' },
}
