-- Marketplace app - player-to-player classifieds. Listings are server-wide and
-- persist; the feed shows everyone's, "Your Posts" shows the caller's own. A
-- blank contact number on a new listing falls back to the poster's number.
-- 市场应用 - 玩家对玩家的分类信息。帖子全服务器可见且持久保存；信息流显示
-- 所有人的帖子，“我的发布”显示发布者自己的。新帖子联系号码留空时，回退
-- 使用发布者本人的号码。
return {
    ListLimit            = 100,  -- most-recent listings returned to the feed 信息流返回的最近帖子数
    MaxListingsPerPlayer = 15,   -- 每名玩家最多发布数
    MinTitleLength       = 1,    -- 标题最短长度
    MaxTitleLength       = 60,   -- 标题最长长度
    MinBodyLength        = 1,    -- 正文最短长度
    MaxBodyLength        = 500,  -- 正文最长长度
    MaxPrice             = 999999999,  -- price cap; no price = a "wanted" post 价格上限；不填价格 = “求购”帖
    MaxImageUrlLength    = 512,  -- 图片链接最大长度
    MaxImages            = 3,    -- photos attachable to a listing 每个帖子可附带的照片数
    MaxContactLength     = 20,   -- 联系方式最大长度
}
