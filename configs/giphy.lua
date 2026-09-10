-- GIFs (GIPHY). The Messages GIF picker pulls from GIPHY's API. (Tenor's API
-- stopped accepting new clients in Jan 2026 and shut down, so we use GIPHY.)
-- The API KEY is NOT here: this file, like every configs/*.lua, ships to connected
-- clients via fxmanifest files{}, so anything in it is readable by a determined
-- player. Put the key in configs/server/apikeys.lua (server-only, never shipped)
-- instead. Only the two display tunables below ship to clients.
-- GIF（GIPHY）。短信的 GIF 选择器从 GIPHY API 获取内容。（Tenor API 已于
-- 2026 年 1 月停止接受新客户并关闭，因此我们使用 GIPHY。）
-- API 密钥不在这里：本文件与所有 configs/*.lua 一样，会通过 fxmanifest 的
-- files{} 发送给已连接客户端，所以其中任何内容都可能被玩家读取。请把密钥
-- 放在 configs/server/apikeys.lua（仅服务端，绝不会下发）。下面只有两个
-- 显示参数会发给客户端。
return {
    Limit  = 24,          -- GIFs fetched per search / trending request 每次搜索/热门请求获取的 GIF 数量
    Rating = 'pg-13',     -- content rating filter: g, pg, pg-13, or r 内容分级过滤：g、pg、pg-13 或 r
}
