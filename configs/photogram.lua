-- Photogram app. Posts/stories/DMs are server-backed and need no tuning here; the knobs
-- below only govern Live video - the broadcaster encodes its camera view to a real video
-- stream (VP8/VP9) and the server (server/photogram/live.lua) relays it to viewers.
-- Photogram 应用。帖子/快拍/私信由服务端支持，无需在此调整；下面的参数
-- 只管理直播视频 - 主播把自己的相机画面编码为真实视频流（VP8/VP9），
-- 服务端（server/photogram/live.lua）将其中转给观众。
return {
    Live = {
        -- Whether players can broadcast at all. Off by default: a live stream relays real
        -- video through your server, so it costs bandwidth on every viewer. With this off
        -- the Go Live action is hidden from the app and the server refuses to start one.
        -- 玩家是否可以开播。默认关闭：直播会通过你的服务器中转真实视频，
        -- 每个观众都会消耗带宽。关闭后应用中隐藏“开播”操作，服务端也会
        -- 拒绝开启直播。
        Enabled           = false,

        -- Concurrent viewers allowed on one stream (0 = unlimited). Each viewer costs
        -- ~Bitrate of server uplink, so this is the main protection knob on large servers.
        -- 单场直播允许的同时观看人数（0 = 不限）。每个观众约消耗 比特率
        -- 大小的服务器上行带宽，因此这是大型服务器的主要保护参数。
        MaxViewers        = 50,

        -- Target video encode bitrate, bits/s. Higher = sharper but more bandwidth per
        -- viewer. ~900 kbps is a good 540p balance.
        -- 目标视频编码比特率（比特/秒）。越高越清晰，但每个观众消耗带宽
        -- 越多。约 900 kbps 是 540p 的良好平衡点。
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
        -- 主播按此间隔（毫秒）重新锚定视频流，让中途加入的人快速获得清晰
        -- 画面。越低加入越快，但效率略降。
        KeyframeMs        = 4000,

        -- Per-viewer latent send ceiling (bytes/s) the server uses to pace each chunk
        -- onto the wire without slamming the net thread.
        -- 每个观众的潜在发送上限（字节/秒），服务端用它控制每个数据块的
        -- 发送节奏，避免压垮网络线程。
        RelayBytesPerSec  = 512 * 1024,
    },
}
