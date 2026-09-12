-- Main config - an index that stitches the per-group config files together.
-- Every consumer still does `require 'configs.config'` and reads the same
-- table; to change a group's settings, edit its own file in this folder
-- (e.g. configs/garages.lua for the Garages app).

local config = {
    -- Locale file under `locales/<Locale>.json`. Falls back to `en` if missing.
    -- 语言文件位于 `locales/<Locale>.json`，缺失时回退到 `en`。cn = 简体中文。
    Locale = 'cn',

    -- Keep the screen left-to-right even when the language reads right-to-left.
    -- Arabic mirrors the whole interface by default, the way an Arabic iPhone does.
    -- Turn this on only if you want the old left-to-right layout with Arabic text.
    ForceLeftToRight = false,

    -- Debug / dev logging toggle.
    -- 调试 / 开发日志开关。
    Debug  = false,

    -- Per-group settings (one file each).
    -- 各分组设置（每组一个文件）。
    Framework   = require 'configs.framework',    -- ox_core group type mapping (other frameworks need none) / ox_core 分组类型映射（其他框架不需要）
    Phone       = require 'configs.phone',        -- open/close, keybind, safety blocks / 打开关闭、按键绑定、安全拦截
    Lockscreen  = require 'configs.lockscreen',    -- wallpaper, clock format / 壁纸、时钟格式
    Apps        = require 'configs.apps',          -- dock, wallpaper, app catalog + enable flags / 底部停靠栏、壁纸、应用目录与启用开关
    StatusBar   = require 'configs.statusbar',     -- carrier / signal / battery / 运营商 / 信号 / 电池
    Photos      = require 'configs.photos',        -- camera capture + Fivemanage upload / 相机拍摄 + Fivemanage 上传
    Payphone    = require 'configs.payphone',      -- street payphones (ox_target + dial UI) / 街头公用电话（ox_target + 拨号界面）
    Accounts    = require 'configs.accounts',      -- app-account limits (Photogram/Cherry/Vibez/Ryde) / 应用账号限制（Photogram/Cherry/Vibez/Ryde）
    Mail        = require 'configs.mail',          -- email accounts + limits / 邮箱账号与限制
    Messages    = require 'configs.messages',       -- SMS / iMessage threads / 短信 / iMessage 对话
    Groups      = require 'configs.groups',        -- player groups / crews / 玩家群组 / 小队
    Birdy       = require 'configs.birdy',         -- microblog / 微博客
    Photogram   = require 'configs.photogram',     -- photo social + live video streaming / 图片社交 + 直播推流
    Vibez       = require 'configs.vibez',          -- short-video social + live video streaming / 短视频社交 + 直播推流
    Voice       = require 'configs.voice',          -- camera/Live audio: own mic + nearby voices (WebRTC) / 相机/直播音频：自己的麦克风 + 附近人声（WebRTC）
    Contacts    = require 'configs.contacts',      -- phone-book + recents / 通讯录 + 最近通话
    Giphy       = require 'configs.giphy',         -- Messages GIF picker display tunables (key is in configs/server/apikeys.lua) / 短信 GIF 选择器显示参数（密钥在 configs/server/apikeys.lua）
    Garages     = require 'configs.garages',       -- vehicle list (multi-system) / 车辆列表（多系统兼容）
    Weather     = require 'configs.weather',       -- live weather + world time (multi-sync) / 实时天气 + 世界时间（多同步端兼容）
    Health      = require 'configs.health',        -- daily step/distance totals + the steps leaderboard / 每日步数/里程统计 + 步数排行榜
    DarkChat    = require 'configs.darkchat',      -- anonymous chat rooms / 匿名聊天室
    Marketplace = require 'configs.marketplace',   -- classifieds / 分类信息
    Pages       = require 'configs.pages',          -- yellow-pages board / 黄页板块
    Banking     = require 'configs.banking',        -- wallet + transfers / 钱包 + 转账
    Services    = require 'configs.services',        -- job/company directory + boss management / 职业/公司名录 + 老板管理
    VoiceMemos  = require 'configs.voicememos',     -- voice notes + Fivemanage / 语音备忘录 + Fivemanage
    Share       = require 'configs.share',          -- nearby share sheet / 近距离分享面板
    Notes       = require 'configs.notes',         -- per-character notes / 角色私有笔记
    Calendar    = require 'configs.calendar',      -- per-character events + shared invites with RSVP / 角色日程 + 带 RSVP 回复的共享邀请
    Documents   = require 'configs.documents',     -- Files: per-character documents + folders / 文件：角色文档 + 文件夹
    Id          = require 'configs.id',            -- ID: identity cards from framework records + nearby show / 证件：基于框架记录的身份证 + 近距离出示
    Housing     = require 'configs.housing',       -- property list (multi-system) / 房产列表（多系统兼容）
    Cookie      = require 'configs.cookie',        -- clicker mini-game + leaderboard / 点击小游戏 + 排行榜
    Casino      = require 'configs.casino',        -- Casino app: blackjack/roulette/slots table limits + spin cadence / 赌场应用：21点/轮盘/老虎机桌限 + 旋转节奏
    Stocks      = require 'configs.stocks',         -- stock + crypto market, brokerage wallet / 股票 + 加密货币市场、券商钱包
    Radio       = require 'configs.radio',          -- frequencies + job-restricted bands / 频率 + 职业限制频段
    Music       = require 'configs.music',          -- which URL sources the Music library accepts / 音乐库接受哪些 URL 来源
    WeazelNews  = require 'configs.weazelnews',     -- broadcast network: staff-published articles + breaking ticker / 广播网：员工发布的文章 + 突发新闻滚动条
    Streaks     = require 'configs.streaks',        -- photo-a-day streaks: milestone cash + global gallery / 每日照片连续打卡：里程碑奖金 + 全球画廊
    Medical     = require 'configs.medical',      -- Medical ID: who may scan another player's card in the field / 医疗证件：谁可以在现场扫描他人的医疗卡
    Mdt         = require 'configs.mdt',            -- police terminal: departments, permission grades, jail + dispatch limits / 警用终端：部门、权限等级、监狱 + 调度限制
    Racing      = require 'configs.racing',         -- Racing: tracks, races, MMR, the gate creator / 赛车：赛道、比赛、MMR 段位、闸门创建器
    Migrate     = require 'configs.migrate',         -- one-time lb-phone -> sd-phone data import / 一次性 lb-phone → sd-phone 数据导入
    Sim         = require 'configs.uniqueandsim',    -- unique phones + SIM cards (see its pick-your-setup header) / 唯一手机 + SIM 卡（见文件头部的方案选择说明）
    CellTowers  = require 'configs.celltowers',   -- degradable service by distance to a mast / 距信号塔越远，服务越差
    Wifi        = require 'configs.wifi',          -- local networks that carry data off the towers / 局域网络，走数据而不耗信号塔流量
    Bluetooth   = require 'configs.bluetooth',     -- devices other resources register for phones to pair with / 其他资源注册、供手机配对的设备
    Shells      = require 'configs.shells',        -- selectable phone chassis, and whether players may pick / 可选手机外壳，以及玩家是否可自行选择
}

-- Server-only secrets: third-party API keys live in configs/server/apikeys.lua, which is NOT in
-- fxmanifest files{} (the glob is `configs/*.lua`, so the server/ subfolder never ships to a
-- client). Merged in server-side only, reachable as config.ApiKeys; on the client this stays nil
-- and no client code reads it.
-- 服务端专属机密：第三方 API 密钥存放在 configs/server/apikeys.lua，该文件不在 fxmanifest 的
-- files{} 中（通配符是 `configs/*.lua`，所以 server/ 子文件夹永远不会下发给客户端）。
-- 仅在服务端合并，可通过 config.ApiKeys 访问；客户端此值为 nil，也没有任何客户端代码读取它。
if IsDuplicityVersion() then
    config.ApiKeys  = require 'configs.server.apikeys'
    config.Webhooks = require 'configs.server.webhooks'
end

return config
