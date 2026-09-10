-- SERVER-ONLY DISCORD WEBHOOKS. Like configs/server/apikeys.lua next to it, this file is
-- deliberately NOT listed in fxmanifest files{} (which uses `configs/*.lua`, so it never matches
-- this subfolder), meaning the URLs stay on the server and never ship to a connected client. Keep
-- configs/server/ out of files{}; a broad glob like `configs/**.lua` would hand every webhook here
-- to anyone who joins. config.lua merges this in server-side only, reachable as config.Webhooks.
-- 仅服务端使用的 Discord Webhook。与旁边的 configs/server/apikeys.lua 一样，本文件
-- 刻意不列入 fxmanifest 的 files{}（其中用的是 `configs/*.lua`，永远匹配不到这个
-- 子文件夹），因此 URL 只留在服务端，绝不会下发给已连接的客户端。请让
-- configs/server/ 保持在 files{} 之外；若使用 `configs/**.lua` 这类宽泛通配，
-- 任何加入服务器的人都能拿到这里的每个 webhook。config.lua 仅在服务端合并此文件，
-- 可通过 config.Webhooks 访问。
--
-- A webhook URL mirrors that app's new posts into a Discord channel: the text, the first image,
-- and who posted it. Leave a URL blank and that app sends nothing - the whole feature is off
-- until you fill one in, and the two apps are independent.
-- 填写 webhook URL 后，对应应用的新帖子会同步到 Discord 频道：包括正文、第一张
-- 图片和发布者。URL 留空则该应用什么都不发送 - 在填入 URL 前整个功能处于关闭
-- 状态，两个应用互不影响。
--
-- To create one: Discord -> Server Settings -> Integrations -> Webhooks -> New Webhook, pick the
-- channel, then Copy Webhook URL.
-- 创建方法：Discord -> 服务器设置 -> 整合 -> Webhook -> 新建 Webhook，选择频道，
-- 然后复制 Webhook URL。
--
-- Posts are mirrored under the IN-GAME persona only: the handle and display name, never the
-- character name or citizenid. A channel fed by these is safe to leave public; it cannot be used
-- to work out which player is behind an account.
-- 同步的帖子只显示游戏内身份：账号句柄和昵称，绝不会显示角色名或 citizenid。
-- 由这些 webhook 推送的频道可以放心设为公开；无法通过它反推出账号背后是哪个
-- 玩家。
--
-- Only top-level posts are mirrored. Birdy replies, comments and likes are not.
-- 只同步顶层帖子。Birdy 的回复、评论和点赞不会同步。
-- Photogram posts from PRIVATE accounts are never mirrored: marking an account private is a
-- visibility choice the app honours, and relaying those to Discord would quietly undo it.
-- 私密账号发布的 Photogram 帖子绝不会同步：把账号设为私密是应用尊重的可见性
-- 选择，把这些帖子转发到 Discord 等于在不知情的情况下破坏了它。
return {
    -- Birdy (the microblog). Blank = off.
    -- Birdy（微博客应用）。留空 = 关闭。
    Birdy = '',

    -- Photogram (the photo feed). Blank = off.
    -- Photogram（照片动态应用）。留空 = 关闭。
    Photogram = '',

    -- What Discord shows as the sender. The webhook's own name/avatar are used when these are
    -- blank, so leaving them alone is fine.
    -- Discord 中显示的发送者名称/头像。留空时使用 webhook 自身的名称和头像，
    -- 所以保持默认即可。
    Username  = 'sd-phone',
    AvatarUrl = '',
}
