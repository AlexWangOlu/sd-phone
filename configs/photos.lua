-- Photos / Camera. The Camera app renders the live game view into a NUI canvas (vendored
-- three.js + CfxTexture in web/src/render/) for a first-person viewfinder. The shutter
-- grabs that canvas as a base64 data-URL and sends it to the server over a latent event
-- (server/photos/init.lua), which uploads it to Fivemanage and stores only the returned
-- CDN URL in `phone_photos`.
-- 照片 / 相机。相机应用把实时游戏画面渲染到 NUI 画布（web/src/render/ 中内置的
-- three.js + CfxTexture）作为第一人称取景器。按下快门时把画布抓取为 base64
-- data-URL，通过 latent 事件发送到服务端（server/photos/init.lua），由服务端
-- 上传到 Fivemanage，并只把返回的 CDN 链接存入 `phone_photos`。
--
-- The Fivemanage Media key is read SERVER-SIDE so it never reaches clients: set FivemanageMedia
-- in configs/server/apikeys.lua (that file is excluded from fxmanifest files{}). A blank config
-- value still falls back to the legacy `sd_fivemanage_key` server convar. Create a "Media" token
-- at https://app.fivemanage.com.
-- Fivemanage Media 密钥在服务端读取，绝不会下发到客户端：在
-- configs/server/apikeys.lua 中设置 FivemanageMedia（该文件被排除在
-- fxmanifest files{} 之外）。配置值为空时仍会回退到旧版 `sd_fivemanage_key`
-- 服务端 convar。可在 https://app.fivemanage.com 创建“Media”令牌。
return {
    -- Which CDN uploads go to: 'fivemanage' or 'qbox'.
    -- 上传到哪个 CDN：'fivemanage' 或 'qbox'。
    --
    -- 'fivemanage' uses the Fivemanage Media token (FivemanageMedia in configs/server/apikeys.lua,
    -- or the legacy sd_fivemanage_key convar).
    -- 'fivemanage' 使用 Fivemanage Media 令牌（configs/server/apikeys.lua 中的
    -- FivemanageMedia，或旧版 sd_fivemanage_key convar）。
    --
    -- 'qbox' uses the Qbox Dashboard CDN (QboxCdn in configs/server/apikeys.lua, or the
    -- sd_qbox_cdn_key convar). Generate the token at https://dashboard.qbox.re -> CDN -> API.
    -- Anything other than 'qbox' stays on Fivemanage, so a typo never quietly moves your media.
    -- 'qbox' 使用 Qbox 仪表盘 CDN（configs/server/apikeys.lua 中的 QboxCdn，或
    -- sd_qbox_cdn_key convar）。在 https://dashboard.qbox.re -> CDN -> API 生成
    -- 令牌。除 'qbox' 外的任何值都保持使用 Fivemanage，因此拼写错误绝不会悄悄
    -- 改变你的图床。
    Provider = 'fivemanage',

    -- JPEG quality (0.0 - 1.0). 0.85 matches NPWD's default and balances
    -- file size against visible compression artefacts.
    -- JPEG 质量（0.0 - 1.0）。0.85 与 NPWD 默认值一致，在文件大小和可见压缩
    -- 痕迹之间取得平衡。
    Quality = 0.85,

    -- Per-player retention cap. Once exceeded, oldest photos are pruned to
    -- keep the row count bounded.
    -- 每名玩家的照片保留上限。超出后删除最旧的照片，以控制数据行数。
    MaxPhotosPerPlayer = 200,

    -- Per-player cap on custom albums (Recents + Favourites are always-present
    -- standard albums and don't count toward this).
    -- 每名玩家的自定义相册上限（“最近项目”和“个人收藏”是始终存在的标准相册，
    -- 不计入此上限）。
    MaxAlbumsPerPlayer = 50,

    -- Album-name length bounds. Max mirrors the React `<input maxLength>` so
    -- client and server agree.
    -- 相册名称长度限制。最大值与 React `<input maxLength>` 一致，确保客户端
    -- 和服务端统一。
    MinAlbumNameLength = 1,
    MaxAlbumNameLength = 40,

    -- How fast a capture is pushed to the server, in BYTES per second, per player.
    --
    -- This is the throttle on the latent event carrying the media, and it is deliberately well
    -- under a home connection's upload speed. It shares that connection with the player's own
    -- game traffic, and the game's packets are the ones that matter: saturate the uplink and
    -- their packet loss climbs until the server times them out. Slower here is a longer upload
    -- and a player who stays connected, which is the right trade.
    --
    -- 262144 (256 KB/s = 2 Mbit/s) leaves headroom on a modest connection. A one-minute clip is
    -- roughly 12 MB, so it lands in about 45 seconds in the background - the player can put the
    -- phone away and keep playing while it finishes. Raise it only if your players are on
    -- connections you know are fast, and lower it if you see packet loss during uploads.
    UploadBytesPerSec = 262144,

    -- Lets the phone upload a captured clip straight to Fivemanage over HTTPS, instead of pushing
    -- it to the server over the game network first.
    --
    -- UploadBytesPerSec above only decides how a clip is paced onto the ENet channel, and pacing
    -- is a trade, not a fix: the uploading player's packet loss climbs for as long as the transfer
    -- runs whatever rate you pick. With this on, the media never touches the game network at all,
    -- so there is nothing to pace. The server still mints the upload slot and still checks what
    -- comes back before it is saved, so the media key stays server-side as it always has.
    --
    -- Set false to force every capture back through the server. That also happens on its own when
    -- Provider is 'qbox' (there is no presigned equivalent) or when Fivemanage cannot be reached,
    -- so turning it off changes nothing except making the choice permanent.
    DirectUpload = true,

    -- Logs each capture upload to the server console: the size, the slice count, how long it
    -- took and the throughput it actually achieved. Off by default because it is one line per
    -- capture; turn it on when you are diagnosing upload problems and want real numbers rather
    -- than an impression.
    LogUploads = false,

    -- Player URL import (the Import button in Photos). Imported URLs are stored and rendered
    -- as-is, NOT re-hosted, so every phone that shows the picture fetches it from that host. A
    -- hostile host would learn the IP address of each viewer, which is why only the hosts in
    -- ImportAllowlist are accepted: large image CDNs behind their own edge network, where the
    -- uploader never sees who views the file. Camera uploads are unaffected because their URL
    -- comes from the server uploader.
    -- 玩家 URL 导入（照片中的“导入”按钮）。导入的 URL 原样存储和渲染，不会
    -- 重新托管，因此每张显示该图片的手机都会从那个主机拉取。恶意主机可以获取
    -- 每个查看者的 IP 地址，所以只接受 ImportAllowlist 中的主机：即有自己边缘
    -- 网络的大型图片 CDN，上传者无法看到谁查看了文件。相机上传不受影响，因为
    -- 其 URL 来自服务端上传器。
    AllowImport = true, -- master switch; false disables URL import and hides the button. 总开关；false 禁用 URL 导入并隐藏按钮。

    -- Hosts to always reject. Exact hostnames, or '*.domain.com' for every subdomain.
    -- IP loggers and URL shorteners belong here: a shortener can redirect an otherwise
    -- fine-looking link to anywhere, and the viewer's client would follow it.
    -- 始终拒绝的主机。精确主机名，或用 '*.domain.com' 涵盖所有子域名。
    -- IP 记录器和短链服务应放在这里：短链可以把看起来正常的链接重定向到任何
    -- 地方，而查看者的客户端会跟随跳转。
    ImportBlocklist = {
        'grabify.link', '*.grabify.link',
        'iplogger.org', '*.iplogger.org',
        'bit.ly', 'tinyurl.com', 't.co',
    },

    -- ONLY these hosts may be imported (the blocklist still applies on top). An empty list
    -- rejects every import instead of trusting the whole internet. '*.domain.com' matches the
    -- bare domain and every subdomain. Add a host only if its images are served by the platform
    -- itself, never by the person who uploaded them.
    -- 只有这些主机可以导入（黑名单仍然优先生效）。空列表会拒绝所有导入，而不是
    -- 信任整个互联网。'*.domain.com' 匹配裸域名和所有子域名。只有当图片由平台
    -- 本身提供（而非上传者个人）时才添加该主机。
    ImportAllowlist = {
        '*.imgur.com',
        '*.discordapp.com', '*.discordapp.net', -- note: Discord attachment links expire after roughly a day 注意：Discord 附件链接约一天后过期
        '*.fivemanage.com',
        '*.ibb.co',
        '*.postimg.cc',
        '*.gyazo.com',
        '*.redd.it',
        '*.giphy.com',
        '*.tenor.com',
        '*.twimg.com',
        '*.pinimg.com',
        '*.githubusercontent.com',
        '*.googleusercontent.com',
        '*.unsplash.com',
        '*.pexels.com',
        '*.wikimedia.org',
    },
}
