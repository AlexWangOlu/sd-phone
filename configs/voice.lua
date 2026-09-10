-- Phone voice capture for camera videos and Photogram Live. The recorder's own mic is always
-- mixed in client-side; the settings below govern capturing NEARBY players' voices, done with a
-- real WebRTC mesh (each nearby player's client streams their mic peer-to-peer, mixed into the
-- recording).
-- 手机语音采集，用于相机视频和 Photogram 直播。录制者自己的麦克风始终在客户端
-- 混入；下面的设置管理采集“附近”玩家的声音，通过真正的 WebRTC 网格实现（每个
-- 附近玩家的客户端点对点串流其麦克风，混入录制内容）。
--
-- Provider/Resources pick which voice script carries CALLS and the RADIO. The two supported
-- dialects are not interchangeable: pma-voice takes numeric call channels and Mumble natives,
-- SaltyChat takes string call identifiers and has no mic-mute API at all, so the phone hides its
-- in-call Mute button there rather than offering one that does nothing.
-- Provider/Resources 决定由哪个语音脚本承载“通话”和“对讲机”。支持的两种方言
-- 不可互换：pma-voice 使用数字通话频道和 Mumble 原生函数，SaltyChat 使用字符串
-- 通话标识符且完全没有麦克风静音 API，因此手机在 SaltyChat 下会隐藏通话中的
-- 静音按钮，而不是放一个没用的按钮。
return {
    -- Which voice API the phone speaks. 'auto' takes the first started entry of Resources
    -- below; naming a dialect outright pins it, which is what you want when both scripts are
    -- installed or the resource has been renamed.
    --   'auto' | 'pma-voice' | 'saltychat'
    -- 手机使用哪种语音 API。'auto' 取下面 Resources 中第一个已启动的条目；直接
    -- 指定方言可锁定选择，当两个脚本都安装了或资源被重命名时应这样做。
    --   'auto' | 'pma-voice' | 'saltychat'
    Provider = 'auto',

    -- Detection order for 'auto', and the map from a resource name to the dialect it speaks.
    -- Add an entry for a renamed fork rather than editing the bridge: a fork of SaltyChat
    -- called something else still speaks 'saltychat'.
    -- 'auto' 的检测顺序，以及资源名称到其方言的映射。重命名的分支请在这里添加
    -- 条目，而不是改桥接层：换了名字的 SaltyChat 分支说的仍然是 'saltychat'。
    Resources = {
        { name = 'pma-voice', provider = 'pma-voice' },
        { name = 'saltychat', provider = 'saltychat' },
    },

    -- Master switch. When false, recordings carry only the recorder's own voice. Note:
    -- capturing other players' microphones may have privacy implications on your server.
    -- 总开关。为 false 时，录制内容只包含录制者自己的声音。注意：采集其他玩家
    -- 的麦克风在你的服务器上可能涉及隐私问题。
    RecordNearbyVoices = true,

    -- Metres - how close another player must be to be captured.
    -- 米 - 其他玩家距离多近才会被采集。
    NearbyRange        = 12.0,

    -- Cap on simultaneous nearby voices mixed into one recording (protects
    -- bandwidth/CPU on busy streets).
    -- 一次录制中混入的同时附近声音上限（在繁忙街道上保护带宽/CPU）。
    MaxNearbyVoices    = 6,

    -- Only capture a nearby player while they're actually transmitting in-game
    -- (pma-voice / Mumble push-to-talk or open mic), so silent/muted players
    -- aren't recorded and you capture what you'd actually hear. Set false to
    -- stream their mic the whole time (or for non-Mumble voice like SaltyChat,
    -- where the talking state can't be read).
    -- 只在附近玩家于游戏内实际发言时采集（pma-voice / Mumble 按键说话或自由
    -- 麦），这样沉默/静音的玩家不会被录到，采集到的就是你实际能听到的内容。
    -- 设为 false 则全程串流其麦克风（或用于 SaltyChat 等无法读取说话状态的
    -- 非 Mumble 语音）。
    TransmitGated      = true,

    -- 'cloudflare' provisions TURN relays (needed for players on different networks) from
    -- Cloudflare Realtime; 'none' uses STUN only (works on LAN / permissive NATs only).
    -- This one setting serves every WebRTC feature: video calls and nearby-voice capture.
    -- Without it, video calls between players on different home connections show a black
    -- picture. (MDT bodycams need none of this: the watching terminal renders the officer's
    -- view in-engine, so no video is streamed.)
    -- 'cloudflare' 从 Cloudflare Realtime 配置 TURN 中继（不同网络下的玩家需要）；
    -- 'none' 仅使用 STUN（只在局域网/宽松 NAT 下可用）。
    -- 这一个设置服务于所有 WebRTC 功能：视频通话和附近声音采集。没有它，不同
    -- 家庭网络的玩家之间视频通话会显示黑屏。（MDT 执法记录仪不需要这些：观看
    -- 终端在引擎内渲染警员视角，不串流视频。）
    -- TURN secrets are read from server convars (NOT committed to the repo):
    -- TURN 密钥从服务端 convar 读取（不要提交到仓库）：
    --     set sd_cf_turn_token_id   "your-cloudflare-turn-token-id"
    --     set sd_cf_turn_api_token  "your-cloudflare-turn-api-token"
    -- Create them at Cloudflare dash -> Realtime -> TURN. Free tier covers a normal server.
    -- 在 Cloudflare 面板 -> Realtime -> TURN 创建。免费档可满足普通服务器。
    Turn = {
        Provider   = 'cloudflare',   -- 'cloudflare' | 'none'
        TtlSeconds = 86400,          -- lifetime of provisioned TURN credentials 配置的 TURN 凭据有效期（秒）
    },

    -- Always-available public STUN (free). TURN is layered on top when configured.
    -- 始终可用的公共 STUN（免费）。配置后 TURN 会叠加在其上。
    StunServers = {
        'stun:stun.l.google.com:19302',
        'stun:stun1.l.google.com:19302',
    },
}
