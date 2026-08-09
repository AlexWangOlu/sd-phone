-- Music app sources. The library plays whatever URL a player pastes in; these decide
-- which URLs it accepts. Anything not matched is refused in the UI before a track exists.
--
-- Why it matters: Rockstar's Creator PLA (2.4) forbids distributing musical works
-- licensed by a third party such as ASCAP, BMI or SESAC. That is about the WORK, not the
-- link, so a direct .mp3 of a chart song is the same breach as a YouTube link to it.
-- Music your players wrote themselves is not licensed by a third party, so curating
-- their tracks is fine. That is what the two allowlists are for.
--
-- Pick whichever suits you; they combine freely.
--   self-hosted only  AllowedHosts  = { 'cdn.myserver.com' }   cleanest, nothing leaves you
--   curated YouTube   AllowedVideos = { 'https://youtu.be/x' } specific videos, nothing else
--   open YouTube      AllowYouTube  = true                     anything, and the risk is yours
return {
    -- Opens YouTube completely: any video, any player, no list. Leave it off unless you
    -- accept responsibility for whatever your players decide to paste.
    AllowYouTube = false,

    -- Direct audio links, curated by hostname. A leading dot covers subdomains, so
    -- '.example.com' matches 'cdn.example.com'. Listing a host vouches for it and any
    -- path on it passes, which is what a CDN with extensionless URLs needs.
    --
    -- Leaving this EMPTY is still usable: links ending in a real audio file (.mp3 .ogg
    -- .oga .opus .wav .m4a .aac .flac .weba) are accepted and everything else is refused,
    -- so a streaming-service page cannot work. Adding an entry switches that default off
    -- and only the hosts listed here pass.
    AllowedHosts = {
        -- 'cdn.myserver.com',
        'www.soundhelix.com',   -- test: paste www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
    },

    -- Individual YouTube videos, playable even while AllowYouTube is false. Use it for
    -- tracks your community made and uploaded. Full URLs or bare 11-character ids both
    -- work, ids are case-sensitive, and any URL shape of a listed video matches
    -- (watch?v=, youtu.be, music.youtube.com, /embed/).
    --
    -- YouTube's API terms expect their player to be visible rather than hidden for audio,
    -- so self-hosting the same file via AllowedHosts stays the tidier option where you
    -- have the choice.
    AllowedVideos = {
        -- 'SOME_VIDEO_ID',
        'https://www.youtube.com/watch?v=YrRhEWiHBjU&list=RDYrRhEWiHBjU&start_radio=1',   -- test: 80's Synthwave royalty/copyright free
    },

    -- Named songs your players can pick straight out of "Add from allowlist", without
    -- typing a URL. Use it to publish a set list from your own CDN. A listed URL always
    -- plays, whatever AllowedHosts says, because listing it here is the vouch.
    -- A bare string works, or give it a title and artist to show a proper name.
    AllowedTracks = {
        -- 'https://cdn.myserver.com/song.mp3',
        { url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3', title = 'Song Two', artist = 'SoundHelix' },
        { url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3', title = 'Song Three', artist = 'SoundHelix' },
    },
}
