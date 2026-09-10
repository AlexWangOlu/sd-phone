-- Messages - the SMS / iMessage backend. Conversations are per-character
-- mailboxes stored in phone_messages; group threads live in the
-- phone_message_groups / phone_message_group_members tables. All three are
-- created on resource start.
-- 信息 - 短信 / iMessage 后端。会话是按角色保存的信箱，存储在 phone_messages
-- 表；群聊会话存储在 phone_message_groups / phone_message_group_members 表。
-- 三张表都在资源启动时创建。
return {
    -- Max characters in a single message body. Longer bodies are truncated.
    -- 单条消息正文的最大字符数，超出部分会被截断。
    MaxBodyLength = 1000,

    -- Hard cap on stored messages per conversation (per character). Older
    -- messages are pruned past this so a thread can't grow unbounded.
    -- 每个会话（按角色）存储消息的硬上限。超出后较旧的消息会被清除，
    -- 防止会话无限增长。
    MessagesPerThread = 200,

    -- Group thread limits.
    -- 群聊限制。
    MaxGroupNameLength = 40,  -- 群名称最大长度
    MaxGroupMembers    = 16,   -- including the creator 成员上限（含创建者）
}
