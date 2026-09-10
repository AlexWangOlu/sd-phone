-- Vibez app. The feed, profiles and comments are server-backed and need no tuning here; the
-- knobs below only govern Live video - the broadcaster encodes its camera view to a real video
-- stream (VP8/VP9) and the server (server/vibez/live.lua) relays it to viewers.
-- Vibez（短视频）应用。信息流、资料和评论由服务端支持，无需在此调整；下面的参数
-- 只管理直播视频 - 主播把自己的相机画面编码为真实视频流（VP8/VP9），服务端
-- （server/vibez/live.lua）将其中转给观众。
return {
    Live = {
        -- Whether players can broadcast at all. Off by default: a live stream relays real
        -- video through your server, so it costs bandwidth on every viewer. With this off
        -- the Go LIVE action is hidden from the app and the server refuses to start one.
        -- 玩家是否可以开播。默认关闭：直播会通过你的服务器中转真实视频，每个
        -- 观众都会消耗带宽。关闭后应用中隐藏“开播”操作，服务端也会拒绝开启。
        Enabled           = false,

        -- Concurrent viewers allowed on one stream (0 = unlimited). Each viewer costs
        -- ~Bitrate of server uplink, so this is the main protection knob on large servers.
        -- 单场直播允许的同时观看人数（0 = 不限）。每个观众约消耗 比特率 大小的
        -- 服务器上行带宽，因此这是大型服务器的主要保护参数。
        MaxViewers        = 50,

        -- Target video encode bitrate, bits/s. Higher = sharper but more bandwidth per
        -- viewer. ~900 kbps is a good 540p balance.
        -- 目标视频编码比特率（比特/秒）。越高越清晰，但每个观众消耗带宽越多。
        -- 约 900 kbps 是 540p 的良好平衡点。
        Bitrate           = 900000,

        -- Broadcaster capture/encode frame rate.
        -- 主播采集/编码帧率。
        Fps               = 25,

        -- How often (ms) the encoder emits a chunk. Lower = lower latency, slightly
        -- more overhead.
        -- 编码器输出数据块的间隔（毫秒）。越低延迟越低，开销略增。
        TimesliceMs       = 250,

        -- The broadcaster re-anchors the stream this often (ms) so people joining
        -- mid-stream get a clean picture quickly. Lower = faster joins but marginally
        -- less efficient.
        -- 主播按此间隔（毫秒）重新锚定视频流，让中途加入的人快速获得清晰画面。
        -- 越低加入越快，但效率略降。
        KeyframeMs        = 4000,

        -- Per-viewer latent send ceiling (bytes/s) the server uses to pace each chunk
        -- onto the wire without slamming the net thread.
        -- 每个观众的潜在发送上限（字节/秒），服务端用它控制每个数据块的发送
        -- 节奏，避免压垮网络线程。
        RelayBytesPerSec  = 512 * 1024,
    },

    -- Text to speech on a Clout upload. The composer offers a text box and a voice; the
    -- server turns them into an audio clip and plays it over the video, the way TikTok does.
    -- Needs the same media upload key the app already uses to store videos (Fivemanage or
    -- Qbox). The endpoint is a free public relay, so it can rate limit or go down; a failure
    -- is soft, the post still uploads, just without the voiceover.
    -- Clout 上传的文字转语音。编辑器提供文本框和声音选项；服务端把它们转为音频
    -- 片段并像 TikTok 那样叠加在视频上播放。需要应用存储视频所用的同一个媒体
    -- 上传密钥（Fivemanage 或 Qbox）。该端点是免费公共中继，可能限流或宕机；
    -- 失败是软失败，帖子仍会上传，只是没有配音。
    TTS = {
        -- Whether the composer offers text to speech at all. With this off the field is hidden
        -- and the server ignores any TTS a client sends.
        -- 编辑器是否提供文字转语音。关闭后该字段隐藏，服务端忽略客户端发来的
        -- 任何 TTS 请求。
        Enabled  = true,

        -- Where the text is turned into audio. The default is the community TikTok-TTS relay.
        -- Swap it for your own if you self-host one that answers the same {text, voice} shape.
        -- 文本转为音频的端点。默认是社区 TikTok-TTS 中继。如果你自建了响应相同
        -- {text, voice} 格式的端点，可换成你自己的。
        Endpoint = 'https://tiktok-tts.weilnet.workers.dev/api/generation',

        -- The voices offered, as { label shown to the player, voice code sent to the endpoint }.
        -- 提供的声音，格式为 { 显示给玩家的标签（已汉化）, 发送给端点的声音代码 }。
        Voices = {
            { '英语（美式）- 女声',        'en_us_001' },
            { '英语（美式）- 男声 1',      'en_us_006' },
            { '英语（美式）- 男声 2',      'en_us_007' },
            { '英语（美式）- 男声 3',      'en_us_009' },
            { '英语（美式）- 男声 4',      'en_us_010' },
            { '英语（英式）- 男声 1',      'en_uk_001' },
            { '英语（英式）- 男声 2',      'en_uk_003' },
            { '英语（澳式）- 女声',        'en_au_001' },
            { '英语（澳式）- 男声',        'en_au_002' },
            { '法语 - 男声 1',             'fr_001' },
            { '法语 - 男声 2',             'fr_002' },
            { '德语 - 女声',               'de_001' },
            { '德语 - 男声',               'de_002' },
            { '西班牙语 - 男声',           'es_002' },
            { '西班牙语（墨西哥）- 男声',  'es_mx_002' },
            { '葡萄牙语（巴西）- 女声',    'br_003' },
            { '葡萄牙语（巴西）- 男声',    'br_005' },
            { '日语 - 女声',               'jp_001' },
            { '韩语 - 男声',               'kr_002' },
            { '鬼脸（惊声尖叫）',          'en_us_ghostface' },
            { '楚巴卡（星球大战）',        'en_us_chewbacca' },
            { 'C-3PO（星球大战）',         'en_us_c3po' },
            { '史迪奇（星际宝贝）',        'en_us_stitch' },
            { '冲锋队（星球大战）',        'en_us_stormtrooper' },
            { '火箭（银河护卫队）',        'en_us_rocket' },
            { '唱歌 - 女低音',             'en_female_f08_salut_damour' },
            { '唱歌 - 男高音',             'en_male_m03_lobby' },
        },
    },
}
