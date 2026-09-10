-- Medical ID. The card itself is always on: every player can fill one in from Health, and it is
-- readable from their own lock screen. What this file configures is the OTHER way in - a medic
-- reading someone else's card in the field.
-- 医疗急救卡。卡片本身始终开启：每个玩家都能在健康应用中填写，并可在自己的
-- 锁屏上查看。本文件配置的是另一种查看途径 - 医护人员在现场读取他人的卡片。
--
-- Why that matters: the lock-screen card can only be read by someone else on a server running
-- unique phones (configs/uniqueandsim.lua with DataOwner 'device' or 'sim'), because on every
-- other setup a phone shows its HOLDER's data, not its owner's. Scanning works on all of them.
-- 这一点很重要：锁屏卡片只能在运行“唯一手机”模式的服务器上被他人读取
-- （configs/uniqueandsim.lua 中 DataOwner 为 'device' 或 'sim'），因为在
-- 其他所有配置下，手机显示的是持有者的数据而非机主的数据。扫描则在所有
-- 配置下都可用。
return {
    Scan = {
        -- Adds a "Scan Medical ID" option to the target eye on other players, for the jobs below.
        -- The scanned card opens on the medic's own phone. Needs ox_target, qb-target or qtarget;
        -- with none of them running this simply never appears.
        -- 为下列工作在注视其他玩家时添加“扫描医疗急救卡”选项。扫描出的卡片
        -- 在医护自己的手机上打开。需要 ox_target、qb-target 或 qtarget；这些
        -- 都没运行时该选项不会出现。
        Enabled = true,

        -- Jobs allowed to scan. Grade is ignored: a probationary medic on scene needs the card as
        -- much as a chief does. Set to {} to turn scanning off without disabling the feature.
        -- 允许扫描的工作。忽略职级：现场的实习医护和主任一样需要这张卡片。
        -- 设为 {} 可在不禁用功能的情况下关闭扫描。
        Jobs = { 'ambulance', 'ems', 'doctor' },

        -- Metres. The server re-checks this against both players' real positions, so a client that
        -- lies about who it is standing next to is refused.
        -- 距离（米）。服务端会用两名玩家的真实位置重新校验，因此谎报身边是谁
        -- 的客户端会被拒绝。
        Distance = 2.5,

        -- true  - only a player who is downed or dead can be scanned.
        -- false - anyone can, which is what you want if medics also run clinics and check-ups.
        -- true  - 只有倒地或死亡的玩家可以被扫描。
        -- false - 任何人都可以，医护同时开设诊所和体检时用这个。
        RequireDowned = false,

        -- Tell the person they were scanned. Off by default: a medic reading the card of someone
        -- who is unconscious should not be popping a notification on their screen.
        -- 告知被扫描者。默认关闭：医护查看昏迷者的卡片时，不应在对方屏幕上
        -- 弹出通知。
        NotifyTarget = false,
    },
}
