-- Groups app - persistent player-formed groups (crews, posses, squads).
-- Backed by three oxmysql tables (see `server/groups/store.lua`). Online-only
-- invites in v0.1 - the target must be connected when invited (the invite row
-- itself survives until accepted/declined).
-- 群组应用 - 玩家组建的持久化群组（小队、团队）。由三张 oxmysql 数据表
-- 支持（见 `server/groups/store.lua`）。v0.1 中邀请仅限在线 - 邀请时
-- 对方必须在线（邀请记录本身会保留到被接受/拒绝）。
return {
    -- Per-leader cap on simultaneously-led groups. Prevents one player
    -- spamming dozens of dead groups.
    -- 每名队长同时拥有群组数的上限，防止单个玩家刷出大量空壳群组。
    MaxOwnedPerPlayer = 5,

    -- Hard cap on members per group, including the leader. iOS Messages caps
    -- groups at 32; we go a touch tighter.
    -- 每个群组含队长在内的成员硬上限。iOS 信息群组上限为 32 人，我们略紧一些。
    MaxMembersPerGroup = 16,

    -- Outgoing-invite cap, per group. Resets as invites are accepted/declined.
    -- 每个群组的待处理邀请上限，邀请被接受/拒绝后重置。
    MaxPendingInvitesPerGroup = 20,

    -- Group name validation. Min keeps lists readable; max matches the React
    -- `<input maxLength={40} />`.
    -- 群名称校验。最短长度保证列表可读；最长与 React 端
    -- `<input maxLength={40} />` 一致。
    MinNameLength = 2,
    MaxNameLength = 40,
}
