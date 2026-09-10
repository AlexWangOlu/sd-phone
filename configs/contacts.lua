-- Contacts / Recents - the phone-book + call-log backend. Both are
-- per-character, stored in the phone_contacts / phone_calls tables created on
-- resource start.
-- 联系人 / 最近通话 - 通讯录 + 通话记录后端。两者均按角色保存，存储在资源
-- 启动时创建的 phone_contacts / phone_calls 数据表中。
return {
    -- Per-player cap on saved contacts. Blocks new inserts past this many
    -- (existing contacts are never auto-removed).
    -- 每名玩家可保存联系人的上限。超过后无法新增（已有联系人绝不会被自动删除）。
    MaxContactsPerPlayer = 500,

    -- Hard cap on call-log (Recents) rows per player. Once exceeded, the
    -- oldest calls are pruned so the log stays bounded.
    -- 每名玩家通话记录（最近通话）行数的硬上限。超出后最旧的记录会被清除，
    -- 使记录保持在限量内。
    MaxRecents = 100,

    -- Field length bounds, mirrored by the React add / edit forms.
    -- 字段长度限制，与 React 端新增/编辑表单保持一致。
    MaxNameLength    = 60,   -- 姓名最大长度
    MaxPhoneLength   = 32,   -- 电话号码最大长度
    MaxEmailLength   = 128,  -- 邮箱最大长度
    MaxAddressLength = 128,  -- 地址最大长度
}
