-- Files app - private per-character documents. Text notes, imported photos and
-- external files persist server-side keyed by citizenid, organised into folders
-- that follow the character (or phone, under unique SIMs) across sessions.
-- 文件应用 - 每个角色私有的文档。文字笔记、导入的照片和外部文件保存在
-- 服务端（以 citizenid 为键），并按文件夹组织，跨会话跟随角色（使用独立
-- SIM 卡时跟随手机）。
return {
    MaxDocuments    = 200,    -- documents a player may keep at once 玩家可同时保存的文档数
    MaxFolders      = 60,     -- folders a player may create 玩家可创建的文件夹数
    MaxTextLength   = 25000,  -- characters of text stored per document 每个文档存储的最大文字字符数
    MaxNameLength   = 60,     -- max length of a document or folder name 文档或文件夹名称的最大长度
    MaxFolderDepth  = 5,      -- deepest nesting allowed in the folder tree 文件夹树允许的最大嵌套深度
    AllowShare      = true,    -- whether AirShare to a nearby phone is offered 是否提供隔空投送到附近手机的功能
    MaxSignatureLength = 150000, -- characters of a drawn-signature image data-URL 手写签名图片 data-URL 的最大字符数
}
