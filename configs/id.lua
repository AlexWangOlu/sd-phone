-- ID app - the player's identity documents as a stack of cards: a State ID built from the
-- framework's character record, one card per licence they hold, and a job badge. A card can be
-- shown to a nearby phone through AirShare; the recipient sees it for ShareMinutes, then it is gone.
-- Nothing about another player is ever written to disk.
-- 证件应用 - 玩家的身份证件以一叠卡片呈现：根据框架角色记录生成的州身份证、
-- 每持有一张执照对应一张卡片，以及工作徽章。卡片可通过 AirShare 出示给附近的
-- 手机；对方可查看 ShareMinutes 分钟，之后消失。绝不向磁盘写入任何其他玩家
-- 的信息。
return {
    -- Licence keys that earn a card, as the framework names them in player metadata
    -- (`metadata.licences.driver` on qb/QBox, `user_licenses.type` on ESX where `drive`,
    -- `drive_bike` and `drive_truck` all count as `driver`). A held key missing from this table
    -- is hidden rather than shown with a bare name, so a typo never puts a strange card on a
    -- phone. `color` is the card face; pick something distinct from the State ID's graphite.
    -- 可生成卡片的执照键名，按框架在玩家元数据中的命名（qb/QBox 为
    -- `metadata.licences.driver`；ESX 为 `user_licenses.type`，其中 `drive`、
    -- `drive_bike` 和 `drive_truck` 都算作 `driver`）。持有的执照若未列在此表中
    -- 会被隐藏，而不是显示一个光秃名称，因此拼写错误绝不会在手机上出现奇怪
    -- 卡片。`color` 是卡面颜色；请选与州身份证石墨色不同的颜色。
    -- 注：label 为卡片上直接显示的名称（不走语言包），已汉化为中文。
    Licences = {
        driver   = { label = '驾驶证',     color = '#1E5BC6' },
        weapon   = { label = '武器许可证', color = '#8A1C2B' },
        business = { label = '营业执照',   color = '#0F766E' },
        hunting  = { label = '狩猎许可证', color = '#4D7C0F' },
        fishing  = { label = '钓鱼许可证', color = '#0E7490' },
        pilot    = { label = '飞行执照',   color = '#6D28D9' },
    },

    -- Order the licence cards stack in, top to bottom. A held licence not listed here is
    -- appended after these in name order.
    -- 执照卡片的堆叠顺序，从上到下。持有但未列在此处的执照按名称顺序追加
    -- 在后面。
    LicenceOrder = { 'driver', 'weapon', 'business', 'hunting', 'fishing', 'pilot' },

    -- Card colour per job for the job badge. A job missing here gets a colour derived from its
    -- name, which is stable but arbitrary; add the ones you want to look official.
    -- 工作徽章按工作名称指定的卡片颜色。未列在此处的工作会根据名称派生一个
    -- 稳定但随机的颜色；想让哪些工作看起来正式就添加哪些。
    JobColors = {
        police    = '#1D4ED8',
        sheriff   = '#92400E',
        ambulance = '#B91C1C',
        doctor    = '#B91C1C',
        lawyer    = '#6D28D9',
        judge     = '#6D28D9',
        mechanic  = '#EA580C',
        taxi      = '#CA8A04',
        realestate = '#0F766E',
    },

    -- The issuing authority printed on every card.
    -- 每张卡片上印刷的签发机关（直接显示，已汉化）。
    Issuer = '圣安地列斯州',

    -- How long a card shown to another phone stays viewable on it before it disappears.
    -- 出示给其他手机的卡片在消失前可查看的时长（分钟）。
    ShareMinutes = 5,
}
