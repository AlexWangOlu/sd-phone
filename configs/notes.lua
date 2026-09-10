-- Notes app - private per-character notes. Body text + inline sketches (PNG
-- data URLs) persist server-side, keyed by citizenid, so they follow the
-- character across sessions and devices.
-- 备忘录应用 - 每个角色私有的备忘录。正文文字 + 内嵌涂鸦（PNG data URL）
-- 保存在服务端，以 citizenid 为键，因此会跟随角色跨会话、跨设备保留。
return {
    MaxNotesPerPlayer = 200,    -- 每名玩家最多备忘录数量
    MaxBodyLength     = 20000,  -- characters of text per note 每条备忘录的最大文字字数
    MaxSketches       = 12,     -- inline drawings per note 每条备忘录最多内嵌涂鸦数
    MaxImages         = 20,     -- attached photo URLs per note 每条备忘录最多附带的图片链接数
}
