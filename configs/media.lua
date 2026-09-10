-- LIVE VIDEO RELAY. You almost certainly do not need this. Leave Enabled = false and everything
-- works: Photogram Live and Vibez Live both stream fine without it.
-- 直播视频中继。你几乎肯定不需要它。保持 Enabled = false 即可，一切正常：
-- Photogram 直播和 Vibez 直播没有它也能正常串流。
--
-- What it is for: those live broadcasts normally send their video through the game server. That is
-- fine for a few viewers. If you run big broadcasts and want the video to travel between players'
-- browsers instead of through the game, this sends it down a separate connection.
-- 它的用途：这些直播通常通过游戏服务器发送视频。少数观众时没问题。如果你举办
-- 大型直播，想让视频在玩家浏览器之间传输而不是经过游戏服务器，此设置会让视频
-- 走一条独立连接。
--
-- Turning it on needs a domain name with a working SSL certificate (https). There is no way around
-- that: the phone's screen is a web page, and browsers refuse insecure video connections. If you do
-- not have one, leave this off.
-- 开启它需要一个带有效 SSL 证书（https）的域名。这一点无法绕过：手机屏幕是
-- 网页，浏览器会拒绝不安全的视频连接。没有的话请保持关闭。
--
-- This is NOT the setting for video calls or voice. That is TURN, in configs/voice.lua.
-- This is NOT where photo uploads go. That is Provider in configs/photos.lua.
-- 这不是视频通话或语音的设置。那是 configs/voice.lua 中的 TURN。
-- 这也不是照片上传的去向。那是 configs/photos.lua 中的 Provider。
--
-- If you do turn it on, put these two lines in your server.cfg (never in this file, so a key cannot
-- end up in a git commit):
-- 如果你确实要开启，把下面两行放进 server.cfg（绝不要放在本文件里，以免密钥
-- 被提交到 git）：
--     set sd_phone_relay_url "wss://media.example.com/ws"
--     set sd_phone_relay_key "paste-64-random-characters-here"
-- Generate the key with `openssl rand -hex 32`. The relay program in media-server/ needs the same
-- key as its SD_PHONE_RELAY_KEY environment variable. It is only used for this: it unlocks nothing
-- else on your server.
-- 用 `openssl rand -hex 32` 生成密钥。media-server/ 中的中继程序需要相同的密钥
-- 作为其 SD_PHONE_RELAY_KEY 环境变量。它只用于此用途：不能解锁你服务器上的
-- 任何其他东西。
return {
    -- Off by default. Turn on only if you have the domain and certificate described above.
    -- 默认关闭。只有在你拥有上述域名和证书时才开启。
    Enabled = false,

    -- Run the relay inside this resource, so there is no separate program to install or keep
    -- running. Handy for testing on your own machine.
    -- 在本资源内运行中继，无需安装或维护单独的程序。方便在自己机器上测试。
    --
    -- It still cannot give you a certificate. On a live server you need https in front of it and
    -- its address in sd_phone_relay_url, or players will not connect. Set this to false if you
    -- would rather run media-server/ on its own box.
    -- 它仍然无法给你证书。在正式服务器上你需要在它前面放 https，并把地址填入
    -- sd_phone_relay_url，否则玩家连不上。如果你更愿意在独立机器上运行
    -- media-server/，把此项设为 false。
    SelfHost = true,

    -- Which features use the relay. Turning one off does not break it, it just goes back to
    -- sending video through the game server like normal.
    -- 哪些功能使用中继。关闭某个不会弄坏功能，只是恢复为照常通过游戏服务器
    -- 发送视频。
    --
    -- MDT bodycams are missing on purpose: the watching officer's screen draws the view in-game,
    -- so there is no video to relay in the first place.
    -- MDT 执法记录仪有意不在其中：观看警员的屏幕在游戏内绘制视角，因此根本
    -- 没有视频需要中继。
    Features = {
        PhotogramLive = true,   -- Photogram Live broadcasts Photogram 直播
        VibezLive     = true,   -- Vibez Live broadcasts Vibez 直播
    },

    -- The settings below are fine as they are. Only change them if you know why you are.
    -- 下面的设置保持默认即可。只有在你清楚原因时才修改。

    -- How long a viewer's pass to watch a stream lasts, in seconds (10 to 120). Kept short so that
    -- taking someone's permission away actually stops them watching, rather than waiting for a
    -- long pass to run out. The convar sd_phone_relay_ttl overrides this.
    -- 观众观看直播的通行证有效期（秒，10 到 120）。保持较短，这样收回某人的
    -- 权限能真正立即阻止其观看，而不是等长通行证到期。convar
    -- sd_phone_relay_ttl 可覆盖此值。
    TokenTtlSeconds = 45,

    -- How many seconds before a pass expires the phone quietly asks for a new one.
    -- 通行证到期前多少秒，手机静默申请新通行证。
    RefreshLeadSeconds = 15,

    -- Let this server tell the relay to cut a stream off straight away, for example when an
    -- officer goes off duty. Turned off, a stream just lingers until its pass runs out.
    -- 允许本服务器通知中继立即切断直播，例如警员下班时。关闭后直播会持续到
    -- 通行证到期。
    ControlChannel = true,

    -- The server.cfg setting names the URL and key are read from. Only change these if one of the
    -- names clashes with another resource on your server. The values themselves never live here.
    -- 读取 URL 和密钥所用的 server.cfg 设置名。只有当某个名称与你服务器上的
    -- 其他资源冲突时才修改。值本身绝不存放在这里。
    UrlConvar        = 'sd_phone_relay_url',
    KeyConvar        = 'sd_phone_relay_key',
    TtlConvar        = 'sd_phone_relay_ttl',
    ControlUrlConvar = 'sd_phone_relay_control_url',
}
