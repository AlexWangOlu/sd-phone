-- Framework-specific settings.
-- 框架相关设置。
--
-- ox_core, not yet wired: employee and owner NAMES come back blank in the Services roster, the
-- MDT people search and Homes offline lookups, and jail features stay off. Identity, cash and
-- bank money, jobs, gangs and society balances are all wired.
-- ox_core 尚未接通的部分：服务（Services）员工名单、MDT 人员搜索和住房离线
-- 查询中，员工和业主的姓名会返回空白；监狱功能保持关闭。身份、现金和银行
-- 存款、工作、帮派以及社团余额均已接通。
--
-- Only ox_core needs anything here: QBCore, QBox, ESX and ND all name
-- their concepts the same way on every install, so the bridge reads them without asking.
-- 只有 ox_core 需要在这里配置：QBCore、QBox、ESX 和 ND 在每次安装中对这些
-- 概念的命名方式都相同，桥接层可直接读取。
--
-- ND in particular needs NOTHING configured. Its `nd_groups` table carries an `isJob` flag per
-- group, so the phone reads which groups are jobs and which are gangs straight from ND, and
-- `nd_group_ranks.isBoss` gives it a real boss grade rather than the guess ox_core needs below.
-- Not wired on ND, because ND_Core has no such concept: company balances (the Services app keeps
-- its roster, hiring and boss actions, but shows no shared account), on-duty state, and jail.
-- ND 尤其不需要任何配置。它的 `nd_groups` 表为每个组带有 `isJob` 标记，
-- 因此手机直接从 ND 读取哪些组是工作、哪些是帮派；`nd_group_ranks.isBoss`
-- 还提供了真实的老板职级，而不是像下面 ox_core 那样需要猜测。
-- ND 上未接通的功能（因 ND_Core 没有对应概念）：公司余额（服务应用保留
-- 名单、招聘和老板操作，但不显示共享账户）、在岗状态和监狱。
--
-- ox_core has no jobs or gangs. It has GROUPS, and a group's `type` is a free-form string the
-- server owner picks when creating it (types/index.ts declares it `type?: string`, with no
-- enforced vocabulary and no default). So the phone cannot guess which of your groups are jobs
-- and which are gangs the way it can on the other three - you tell it here.
-- ox_core 没有工作或帮派概念。它只有“组（GROUPS）”，而组的 `type` 是服主
-- 创建组时自选的自由字符串（types/index.ts 中声明为 `type?: string`，没有
-- 强制词表也没有默认值）。因此手机无法像在另外三个框架上那样猜出哪些组是
-- 工作、哪些是帮派 - 需要在这里告诉它。
return {
    OxCore = {
        -- Group types the phone treats as JOBS. Matched in order, first hit wins, so put your
        -- primary type first. A group whose type is not listed in either table is ignored by the
        -- phone entirely: it will not show as a job, a gang, or in the Services app.
        -- 手机视为“工作”的组类型。按顺序匹配，先命中为准，因此请把主要类型
        -- 放在最前。类型未列在任一张表中的组会被手机完全忽略：不会显示为工作、
        -- 帮派，也不会出现在服务应用中。
        JobTypes = { 'job' },

        -- Group types the phone treats as GANGS. Kept separate from JobTypes because the phone
        -- gates apps on them independently (a gang-only app must not unlock for a police group).
        -- 手机视为“帮派”的组类型。与 JobTypes 分开保存，因为手机按它们独立
        -- 控制应用开放（仅限帮派的应用绝不能对警察组解锁）。
        GangTypes = { 'gang' },

        -- Treat the top grade of a group as its boss grade. ox_core has per-grade permissions
        -- rather than a boss flag, so there is nothing to read; the phone falls back to "highest
        -- grade in the group is the boss", which is how QBCore's isboss behaves in practice.
        -- Set false to refuse every boss action instead, leaving the Services app read-only.
        -- 把组的最高职级视为老板职级。ox_core 按职级设置权限而没有老板标记，
        -- 因此没有可读取的内容；手机回退为“组内最高职级即老板”，这与
        -- QBCore 的 isboss 在实际中的行为一致。设为 false 则拒绝所有老板操作，
        -- 服务应用变为只读。
        TopGradeIsBoss = true,
    },
}
