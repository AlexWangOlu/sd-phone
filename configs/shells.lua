-- Phone shells. A shell is the chassis only: rail shape and finish, corner radius, bezel
-- thickness, the camera cutout and where the side buttons sit. The screen itself never changes
-- size, so every app looks and behaves identically whichever shell a player picks.
-- 手机外壳。外壳只是机身：边框形状和质感、圆角半径、边框厚度、摄像头开孔以及
-- 侧边按键位置。屏幕本身尺寸不变，因此无论玩家选哪种外壳，每个应用的外观和
-- 行为都完全一致。
--
-- Shell ids ship in web/src/shell/shells.ts. The ones that exist today:
-- 外壳 id 在 web/src/shell/shells.ts 中。目前有：
--   ios        the default. Rounded rail, Dynamic Island, polished finish.
--              默认款。圆润边框、灵动岛、亮面质感。
--   android    flat matte rail, tighter corners, small centred punch-hole camera.
--              平直哑光边框、更紧的圆角、居中小挖孔摄像头。
--   edge       the thinnest bezel, near-square rail, tiny centred pinhole camera.
--              最窄边框、近方正边框、居中超小针孔摄像头。
--   classic    thicker bezel, centred notch, gently rounded corners, matte finish.
--              较宽边框、居中刘海、柔和圆角、哑光质感。
--   compact    thin sides with a forehead and chin, camera in the bezel, no cutout at all.
--              窄侧边但带额头和下巴、摄像头在边框内、完全没有开孔。
--   droplet    barely-there borders with a tiny teardrop notch.
--              几乎无边框，带微小水滴刘海。
--   dual       the thinnest borders of all, wide twin-camera punch-hole.
--              全部中边框最窄、宽双摄挖孔。
--   rugged     armoured: the thickest border of the set, deep buttons, spare key.
--              装甲风：本系列最宽边框、深陷按键、备用键。
--   gaming     the boxiest body, even borders, shoulder triggers on the right.
--              最方正机身、等宽边框、右侧肩键。
--   waterfall  near-frameless body, glass rolled over all four edges, orange key.
--              近无框机身、四曲面玻璃、橙色按键。
return {
    -- false locks everyone to Forced below (or to the first entry of Allowed when Forced is nil)
    -- and hides the Phone Shell page from Settings entirely, so there is no dead control.
    -- false 把所有人锁定到下面的 Forced（Forced 为 nil 时锁定到 Allowed 的第一个），
    -- 并从设置中完全隐藏“手机外壳”页面，不留无效控件。
    AllowPlayerChoice = true,

    -- Shells players may pick from. Remove entries to narrow the list. An id that does not exist
    -- is ignored rather than erroring, so a typo costs you one option and not the picker.
    -- 玩家可选的外壳。删除条目即可收窄列表。不存在的 id 会被忽略而不是报错，
    -- 因此拼写错误只会让你少一个选项，不会弄坏选择器。
    Allowed = {
        'ios', 'android', 'edge', 'classic', 'compact',
        'droplet', 'dual', 'rugged', 'gaming', 'waterfall',
    },

    -- Set to a shell id to put every phone on it regardless of what a player chose earlier. Their
    -- stored choice is kept, so clearing this hands their own shell back rather than resetting it.
    -- 设为某个外壳 id 可让所有手机都使用它，无论玩家之前选了什么。玩家保存的
    -- 选择会保留，因此清除此项会把他们自己的外壳还回去，而不是重置。
    Forced = nil,
}
