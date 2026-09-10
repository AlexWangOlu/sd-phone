-- lb-phone -> sd-phone data migration. When a server switches from lb-phone to sd-phone this
-- carries each player's essentials across, so people keep their phone instead of starting over:
-- phone number + lock passcode, contacts, call history, blocked numbers, SMS threads (incl.
-- groups), photos + albums, and notes.
-- lb-phone -> sd-phone 数据迁移。服务器从 lb-phone 换到 sd-phone 时，这会把每个
-- 玩家的 essential 数据带过来，让大家保留自己的手机而不用从头开始：电话号码 +
-- 锁屏密码、联系人、通话记录、黑名单号码、短信会话（含群组）、照片 + 相册和备忘。
--
-- Nothing happens until you ask for it. /phoneadmin -> Migration previews what is on the other
-- side, takes a domain selection and streams the run; set `enabled` below if you would rather it
-- ran by itself on the next boot instead.
-- 在你主动操作前什么都不会发生。/phoneadmin -> 迁移（Migration）会预览对方
-- 数据、让你选择迁移范围并流式执行；如果你更希望它在下次启动时自动运行，请把
-- 下面的 `enabled` 打开。
--
-- It is idempotent and non-destructive. A marker row (phone_migrations) stops it running twice,
-- every write is INSERT IGNORE / fill-only, and a player who already has sd-phone data is never
-- overwritten. Safe to leave enabled forever: once there is nothing left to import it is a cheap
-- no-op. The join is lb-phone's phone owner id -> framework citizenid, and each player's lb-phone
-- number is adopted as their sd-phone number so every contact / thread / call log still lines up.
-- 迁移是幂等且非破坏性的。标记行（phone_migrations）防止重复运行，所有写入都是
-- INSERT IGNORE / 仅填充，已有 sd-phone 数据的玩家绝不会被覆盖。可以一直开着：
-- 没有可导入内容后它就是个低成本空操作。关联方式是 lb-phone 的手机所有者 id ->
-- 框架 citizenid，每个玩家的 lb-phone 号码会沿用为 sd-phone 号码，因此所有联系人/
-- 会话/通话记录都能对上。
--
-- With unique phones on (configs/uniqueandsim.lua), the join is per PHONE instead: lb-phone keys
-- its data by phone number, so a player holding two phones has two separate sets of contacts and
-- photos, and both come across intact. Their phone items need no editing - sd-phone reads the
-- number lb-phone already wrote onto them. Servers without unique phones are unaffected: each
-- player keeps one number, exactly as before.
-- 开启唯一手机模式时（configs/uniqueandsim.lua），改为按“手机”关联：lb-phone
-- 按电话号码为数据建键，因此持有两部手机的玩家有两套独立的联系人和照片，两套
-- 都会完整迁来。手机物品无需修改 - sd-phone 会读取 lb-phone 已写在物品上的号码。
-- 未启用唯一手机的服务器不受影响：每个玩家保留一个号码，和以前完全一样。
return {
    -- Import automatically on resource start. Off by default: this reads millions of rows and runs
    -- the server heavy for as long as it takes, which is not something to do to a live server
    -- nobody was expecting it on.
    -- 资源启动时自动导入。默认关闭：这会读取数百万行数据，在运行期间给服务器
    -- 造成沉重负担，不该在没人预料到的情况下对正在运行的服务器执行。
    --
    -- Leave it off and you drive the import yourself from /phoneadmin -> Migration, which previews
    -- what lb-phone actually holds, lets you pick the domains, and streams the run with a live log
    -- and an ETA. Turn it on if you would rather it happen by itself on the next boot and never
    -- think about it again; it is idempotent, so once there is nothing left to import it is a
    -- cheap no-op. `sdphone:migrate` from the server console works either way.
    -- 保持关闭时，你可以从 /phoneadmin -> 迁移（Migration）自行驱动导入：它会预览
    -- lb-phone 实际持有的数据、让你选择迁移范围，并带实时日志和预计时间流式执行。
    -- 如果你更希望下次启动时自动完成、之后不用再管，可以打开它；它是幂等的，没有
    -- 可导入内容后就是低成本空操作。无论开关如何，服务端控制台的 `sdphone:migrate`
    -- 命令都可用。
    enabled = false,

    -- lb-phone's table prefix. Its tables are all phone_* (phone_phones, phone_phone_contacts,
    -- ...). Only touch this if you renamed them; it must be plain [a-z0-9_] or it is ignored.
    -- lb-phone 的数据表前缀。它的表都是 phone_*（phone_phones、
    -- phone_phone_contacts……）。只有你重命名过这些表时才需要改；必须是纯
    -- [a-z0-9_] 字符，否则会被忽略。
    sourcePrefix = 'phone_',

    -- How an lb-phone phone owner id maps to an sd-phone citizenid:
    --   'auto'      match owner_id against known citizenids first, else treat it as a license
    --   'citizenid' owner_id is already the citizenid (skip the license fallback)
    --   'license'   owner_id is a license; always map through the players table
    -- 'auto' is right for almost everyone (it covers both lb-phone identifier setups).
    -- lb-phone 手机所有者 id 如何映射到 sd-phone citizenid：
    --   'auto'      先把 owner_id 与已知 citizenid 匹配，否则当作 license 处理
    --   'citizenid' owner_id 已经是 citizenid（跳过 license 回退）
    --   'license'   owner_id 是 license；始终通过 players 表映射
    -- 几乎所有人用 'auto' 就对了（它覆盖 lb-phone 的两种标识符设置）。
    identifierMode = 'auto',

    -- Dry run: count everything and log the plan, but write nothing. Run the console command with
    -- `sdphone:migrate dry` for a preview without flipping this.
    -- 试运行：统计所有内容并记录计划，但不写入任何数据。不改此项也可用
    -- `sdphone:migrate dry` 控制台命令预览。
    dryRun = false,

    -- Per-domain switches, if you want to import only some of it. `numbers` must stay on: every
    -- other domain is keyed off the number -> citizenid resolution it establishes.
    -- 各数据域开关，只想导入部分内容时使用。`numbers` 必须保持开启：其他所有
    -- 域都以它建立的“号码 -> citizenid”解析为键。
    --
    -- `reactions` needs `messages` (it attaches to the messages that porter writes) and
    -- `sessions` needs `photogram` (it links to the accounts that porter creates). Turning
    -- `birdy` or `vibez` off also holds back their logins, since there is then no account for a
    -- Twitter or Trendy session to attach to.
    -- `reactions` 需要 `messages`（它附着在迁移器写入的消息上），`sessions` 需要
    -- `photogram`（它链接到迁移器创建的账户）。关闭 `birdy` 或 `vibez` 也会保留
    -- 它们的登录态不迁，因为没有账户可供 Twitter 或 Trendy 会话附着。
    --
    -- lb-phone passwords are bcrypt hashed and cannot be converted to sd-phone's hasher, so
    -- migrated accounts rely on the pre-seeded sessions to stay signed in. Anyone who logs out
    -- recovers through the normal in-app password reset.
    -- lb-phone 密码是 bcrypt 哈希，无法转换为 sd-phone 的哈希算法，因此迁移来的
    -- 账户依靠预置会话保持登录。登出的人可通过应用内正常的密码找回恢复。
    domains = {
        -- Registers each migrated number so a phone item can keep its own data. Does nothing
        -- unless unique phones are on, and runs before `numbers`.
        -- 注册每个迁移来的号码，让手机物品能保留各自的数据。仅在开启唯一手机时
        -- 有效，且在 `numbers` 之前运行。
        uniquephones = true,
        numbers    = true,  -- 电话号码
        contacts   = true,  -- 联系人
        blocked    = true,  -- 黑名单号码
        calls      = true,  -- 通话记录
        messages   = true,  -- 短信会话
        photos     = true,  -- 照片和相册
        notes      = true,  -- 备忘录
        -- wallpaper, theme, clock format, ringtones, volumes, home-screen layout
        -- 壁纸、主题、时钟格式、铃声、音量、主屏幕布局
        settings   = true,
        -- message reactions; needs `messages`
        -- 消息表情回应；需要 `messages`
        reactions  = true,
        -- Instagram accounts, posts, comments, likes, follows, stories and DMs
        -- Instagram 风格账户、帖子、评论、点赞、关注、快拍和私信
        photogram  = true,
        -- Twitter accounts, posts and replies, likes, reposts, follows and DMs
        -- Twitter 风格账户、帖子和回复、点赞、转发、关注和私信
        birdy      = true,
        -- Trendy accounts, videos, comments, likes, saves, follows and notifications
        -- Trendy（短视频）账户、视频、评论、点赞、收藏、关注和通知
        vibez      = true,
        -- mail accounts and their received messages
        -- 邮件账户及其收到的邮件
        mail       = true,
        -- wallet transaction history
        -- 钱包交易记录
        wallet     = true,
        -- voice memo recordings
        -- 语音备忘录录音
        voicememos = true,
        -- keeps players signed into their migrated accounts; needs `photogram`, runs last
        -- 让玩家保持登录迁移来的账户；需要 `photogram`，最后运行
        sessions   = true,
    },
}
