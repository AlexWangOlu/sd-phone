-- Calendar app - per-character events that live server-side, keyed by citizenid,
-- so they follow the character across sessions and devices. An event belongs to
-- the character who created it (the organizer); everyone else on it is an
-- invitee whose RSVP decides whether the event shows up in their own calendar.
-- 日历应用 - 事件保存在服务端、按角色（citizenid）存储，因此会跟随角色跨
-- 会话、跨设备保留。事件属于创建它的角色（组织者）；其他参与者都是受邀人，
-- 是否接受邀请决定了该事件是否显示在他们自己的日历中。
return {
    MaxEventsPerPlayer   = 300,  -- 每名玩家最多事件数
    MaxAttendeesPerEvent = 20,   -- guests on one event, the organizer aside 单个事件除组织者外的受邀人数上限
    MaxTitleLength       = 120,  -- characters 标题最大字符数
    MaxLocationLength    = 120,  -- characters 地点最大字符数
    MaxNotesLength       = 2000, -- characters 备注最大字符数
}
