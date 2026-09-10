-- Dark Chat app - anonymous, cross-player chat rooms. Public rooms are
-- server-wide and always browsable; private rooms are created at runtime and
-- gated by a code. Messages, private rooms, memberships and nicknames persist.
-- 暗聊应用 - 匿名的跨玩家聊天室。公共房间全服务器可见且始终可浏览；私密
-- 房间在运行时创建并通过房间码进入。消息、私密房间、成员资格和昵称都会
-- 持久保存。
return {
    -- Public rooms everyone can see and chat in. `id` must stay stable -
    -- messages are keyed by it. Add / remove / rename freely.
    -- 所有人可见并可发言的公共房间。`id` 必须保持稳定 - 消息以它为键。
    -- 可自由添加/删除/改名（name/topic 为应用内显示内容，已汉化为中文）。
    PublicRooms = {
        { id = 'general', name = '城市大厅',   topic = '什么都可以聊 - 注意文明用语。' },
        { id = 'market',  name = '黑市',       topic = '买卖交易，概不过问。' },
        { id = 'grid',    name = '脱离网格',   topic = '给不想被找到的人。' },
        { id = 'night',   name = '夜班',       topic = '仅限夜猫子。' },
        { id = 'rumor',   name = '谣言工厂',   topic = '你听到什么风声了？' },
    },

    HistoryLimit             = 60,   -- messages loaded when a room is opened 打开房间时加载的消息数
    MaxMessageLength         = 300,  -- 单条消息最大长度
    MaxPrivateRoomsPerPlayer = 20,   -- 每名玩家最多私密房间数
    MinRoomNameLength        = 1,    -- 房间名最短长度
    MaxRoomNameLength        = 30,   -- 房间名最长长度
    MinNicknameLength        = 1,    -- 昵称最短长度
    MaxNicknameLength        = 20,   -- 昵称最长长度
    CodeLength               = 6,    -- generated private-room code length 生成的私密房间码长度
    -- How long a room creator must wait between "generate new code" uses (seconds), so the
    -- code can't be spam-cycled.
    -- 房间创建者两次“生成新房间码”之间必须等待的时间（秒），防止刷码。
    CodeRegenCooldownSeconds = 300,
}
