-- Call recording. Either party can record a call, and the other side is NOT told: a character
-- who knows they are being recorded does not incriminate themselves, and informing them would
-- remove the only thing the feature is for.
-- 通话录音。通话双方都可以录音，且不会告知对方：知道自己在被录音的角色不会
-- 自证其罪，而告知对方就会让这个功能失去唯一意义。
--
-- It ships OFF, and it is worth understanding what you are switching on before you do.
-- 该功能默认关闭，在开启之前值得先了解你打开的是什么。
--
-- The audio is a real person's real microphone, so it is personal data wherever your players
-- live. Nothing here creates a new capability - anyone can already record a call with OBS, and
-- the far party's voice arrives as game audio either way - but it does put those recordings on
-- your server, which makes them yours to account for.
-- 音频是真人的真实麦克风声音，因此在玩家所在的任何地区都属于个人数据。这并
-- 没有创造新能力 - 任何人本来就可以用 OBS 录下通话，对方的声音反正也是以
-- 游戏音频形式传来 - 但它确实会把这些录音放到你的服务器上，你需要对此负责。
--
-- What makes that defensible is disclosure and a retention limit, not an in-call warning: say in
-- your rules that phone calls may be recorded in character and kept for a period, and leave
-- KeepDays finite. Every recording is visible and deletable in the admin panel, so there is an
-- audit trail rather than a private stash. None of this is legal advice.
-- 让这一做法站得住脚的是事前告知和保留期限，而不是通话中的警告：在服务器
-- 规则中说明角色通话可能被录制并保留一段时间，并让 KeepDays 保持有限值。每条
-- 录音都可在管理面板中查看和删除，因此有审计痕迹而非私人藏匿。以上不构成
-- 法律建议。
return {
    -- Master switch. With this off the Record button never appears, the server refuses uploads,
    -- and the Recordings tab hides itself.
    -- 总开关。关闭后录音按钮永远不会出现，服务端拒绝上传，录音标签页隐藏。
    Enabled = false,

    -- Longest single recording. The recorder stops itself at the cap and uploads what it has,
    -- rather than dropping the lot for going over.
    -- 单条录音最长时长。到达上限后录音器会自行停止并上传已录内容，而不是
    -- 因超时全部丢弃。
    MaxMinutes = 10,

    -- Days a recording is kept before the prune sweep drops it. 0 keeps them forever, which
    -- means the storage bill grows forever too.
    -- 录音保留天数，到期后由清理任务删除。设为 0 表示永久保留，这也意味着
    -- 存储开销会永久增长。
    KeepDays = 30,

    -- Most recordings one character may hold. The oldest is dropped to make room.
    -- 一个角色最多持有的录音条数。超出时删除最旧的以腾出空间。
    MaxPerPlayer = 50,
}
