-- Find Friends settings - the live location-sharing app (Find My style).
-- “查找朋友”设置 - 实时位置共享应用（类似“查找”）。
return {
    -- Maximum friends a player can add.
    -- 一名玩家最多可添加的好友数量。
    MaxFriends = 50,

    -- How often (ms) live friend positions are pushed to a player who has the
    -- Find Friends app open. Coordinates are read server-side, so this is the
    -- only thing that controls the on-screen refresh rate. 3s is smooth without
    -- being chatty; raise it if you have a very high player count.
    -- 打开“查找朋友”应用时，好友实时位置推送给玩家的间隔（毫秒）。
    -- 坐标在服务端读取，所以这是控制屏幕刷新率的唯一参数。3 秒既流畅又不会
    -- 产生过多通信；如果服务器玩家数量很多，可以调大此值。
    UpdateInterval = 3000,
}
