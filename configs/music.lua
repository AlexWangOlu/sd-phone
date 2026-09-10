-- Which links the Music app will accept. Anything not matched here is refused.
-- 音乐应用接受哪些链接。不匹配的内容一律拒绝。
--
-- By default it accepts the two Creative Commons songs below and nothing else. That is
-- deliberate: Rockstar's Creator PLA (2.4) forbids sharing music licensed by someone
-- else, and that is about the song, not the link, so a .mp3 of a chart track is no
-- different to a YouTube link to it. Opening anything up is your call, and your risk.
-- 默认只接受下面两首知识共享歌曲，其他一概不接受。这是有意为之：Rockstar 的
-- 创作者政策（PLA 2.4）禁止分享他人授权的音乐，限制针对的是歌曲本身而非链接，
-- 因此一首榜单歌曲的 .mp3 与指向它的 YouTube 链接没有区别。开放任何内容都
-- 由你决定，风险也由你承担。
return {
    -- Any YouTube video, from any player.
    -- 允许任何玩家添加任意 YouTube 视频。
    AllowYouTube = false,

    -- Any direct audio file, from any host.
    -- 允许来自任意主机的直接音频文件链接。
    AllowAnyAudioLink = false,

    -- Hosts you trust. Every file on them is allowed, so prefer a host you control.
    -- A leading dot covers subdomains: '.myserver.com' matches 'cdn.myserver.com'.
    -- 你信任的主机。其上的每个文件都允许，因此优先使用你自己控制的主机。
    -- 前导点涵盖子域名：'.myserver.com' 匹配 'cdn.myserver.com'。
    AllowedHosts = {
        -- 'cdn.myserver.com',
    },

    -- Named songs, listed one by one. Players pick these from "Add from allowlist"
    -- instead of typing a URL, and a listed link always plays whatever AllowedHosts says.
    -- The two below are real, working examples: Kevin MacLeod tracks on Wikimedia Commons
    -- under CC BY 3.0, which allows playing them as long as he is credited. Delete them
    -- if you want to ship nothing, or copy the shape for your own songs.
    -- 逐首列出的具名歌曲。玩家从“从白名单添加”中选择这些歌曲，而不用输入
    -- URL；列出的链接无论 AllowedHosts 如何设置都可以播放。下面两首是真实
    -- 可用的示例：Wikimedia Commons 上 Kevin MacLeod 的曲目，采用 CC BY 3.0
    -- 许可，只要署名即可播放。不想附带任何歌曲可删除它们，或照此格式添加
    -- 你自己的歌曲。
    AllowedTracks = {
        -- 'https://cdn.myserver.com/song.mp3',
        { url = 'https://upload.wikimedia.org/wikipedia/commons/4/47/Kevin_MacLeod_~_Monkeys_Spinning_Monkeys.ogg',
          title = 'Monkeys Spinning Monkeys', artist = 'Kevin MacLeod (CC BY 3.0)' },
        { url = 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Kevin_MacLeod_-_Gustav_Holst_Thaxted.oga',
          title = 'Thaxted', artist = 'Kevin MacLeod (CC BY 3.0)' },
    },

    -- Specific YouTube videos, allowed even while AllowYouTube is false. Good for music
    -- your own community made. URLs or bare video ids both work. Check the licence is
    -- real: "no copyright music" on a re-upload channel usually means nothing.
    -- 特定的 YouTube 视频，即使 AllowYouTube 为 false 也允许。适合放你自己
    -- 社区制作的音乐。URL 或纯视频 ID 均可。请确认许可是真实的：转载频道上
    -- 的“无版权音乐”通常什么都保证不了。
    AllowedVideos = {
        -- 'https://www.youtube.com/watch?v=SOME_VIDEO_ID',
    },
}
