-- Voice Memos app. Recordings are captured in the phone UI, uploaded to
-- Fivemanage (same media key as Photos - configs/server/apikeys.lua FivemanageMedia) and the
-- hosted URL is persisted per character.
-- 语音备忘应用。录音在手机界面中采集，上传到 Fivemanage（与照片使用同一个媒体
-- 密钥 - configs/server/apikeys.lua 的 FivemanageMedia），托管后的 URL 按角色保存。
return {
    ListLimit     = 100,            -- most-recent memos returned to the app 返回给应用的最近备忘条数
    MaxPerPlayer  = 200,            -- 每名玩家最多录音数
    MaxNameLength = 80,             -- 名称最大长度
    MaxAudioBytes = 12 * 1024 * 1024, -- ~12 MB base64 (a few minutes of audio) 约 12 MB base64（几分钟音频）
}
