-- Police bodycams and vehicle dashcams, watched from the MDT's Cameras section.
-- 警用随身摄像头和车载行车记录仪，可在 MDT 的"摄像头"板块中观看。
--
-- The picture is rendered by the TERMINAL, not by the officer. When a dispatcher opens a
-- unit, their own client quietly moves to that officer, bolts a camera to the officer's
-- chest and renders it. The officer is never touched: they keep playing on whatever
-- camera they like, in third person or first, and their client does no encoding and
-- sends no video anywhere.
-- 画面由观看终端（而不是被观看的警员）渲染。调度员打开某个单位时，自己的客户端会
-- 悄悄把视角移动到该警员身上，在警员胸前架一台摄像机并渲染画面。被观看的警员完全
-- 不受影响：他们继续用自己喜欢的视角（第一或第三人称）游戏，其客户端不做任何编码，
-- 也不向任何地方发送视频。
--
-- That is what makes the feed a real body-worn camera rather than a copy of the
-- officer's screen. It also means a camera costs no bandwidth at all: nothing is
-- relayed, because nothing leaves the watcher's machine.
-- 正因为如此，这才是真正的执法记录仪画面，而不是警员屏幕的拷贝。这也意味着摄像头
-- 不消耗任何带宽：没有任何数据被转发，因为没有任何东西离开观看者的机器。
--
-- The cost is that a terminal watches one unit at a time, and that the watcher's own
-- character is parked, hidden and immovable while they watch. They get it back the
-- moment they leave the camera.
-- 代价是：一台终端同一时间只能观看一个单位，而且观看期间观看者自己的角色会被停在
-- 原地、隐藏且无法移动。退出摄像头的一瞬间即可恢复控制。
return {
    -- Whether the Cameras section works at all.
    -- 摄像头板块是否启用（总开关）。
    Enabled = false,

    -- Framework jobs that carry a bodycam. Leave empty to mean "every police department in
    -- configs/mdt.lua". A job that is not a police department never gets a camera whatever
    -- is listed here, because the Cameras section is police-only on the server.
    -- 佩戴随身摄像头的框架 job 列表。留空表示"configs/mdt.lua 中的所有警察部门"。
    -- 非警察部门的 job 无论是否列在这里都不会有摄像头，因为服务端限定摄像头板块
    -- 仅供警察使用。
    Jobs = { 'police', 'bcso', 'sasp' },

    -- Whether an officer must be on duty to appear in the grid.
    -- 警员是否必须在班（在岗）才会出现在摄像头列表中。
    RequireDuty = true,

    -- Where the camera sits on the officer and how it sees. The offsets are measured from the
    -- ped's own origin, which sits at the HIPS rather than the feet, so Height is the rise from
    -- the waist to the top of the chest and not a height off the ground.
    -- 摄像头在警员身上的安装位置和视角参数。偏移量从 ped 自身的原点（位于髋部而非
    -- 脚底）开始计算，因此 Height 是从腰部到胸口上方的高度，而不是离地面的高度。
    Mount = {
        -- Forward of the chest, in metres. Far enough out that the officer's own body does not
        -- fill the lens, close enough that it still reads as worn rather than floating.
        -- 胸口前方的距离（米）。要足够远，使警员自己的身体不会挡住镜头；又要足够近，
        -- 看起来像是佩戴在身上而不是悬浮着。
        Forward = 0.34,
        -- Above the ped's origin, in metres. 0.38 lands on the upper chest, where a real
        -- body-worn camera clips on.
        -- 高于 ped 原点的距离（米）。0.38 落在胸口上方，正是现实中执法记录仪的
        -- 夹持位置。
        Height = 0.38,
        -- Sideways from the centre of the chest, in metres. Negative is the officer's left,
        -- which is the shoulder most departments mount on.
        -- 相对胸口中心的侧向偏移（米）。负值为警员左侧，多数部门把摄像头夹在左肩。
        Side = 0.0,
        -- Field of view. Body-worn cameras are wide; this is deliberately wider than the game's
        -- own first person.
        -- 视野（FOV）。执法记录仪是广角镜头，这里刻意比游戏自带的第一人称视角更广。
        Fov = 78.0,
        -- Downward tilt in degrees, because a camera on a chest points slightly at the ground.
        -- 向下倾斜角度（度），因为胸前的摄像头会略微朝向地面。
        Pitch = -8.0,
        -- How close geometry may come before it stops being drawn.
        -- 几何物体近于多少距离后停止渲染（近裁剪面）。
        NearClip = 0.10,

        -- The same figure while the officer is running. A ped pitches forward into a run and the
        -- camera does not, so the head swings toward the lens and for a moment you see the inside
        -- of their face. This rejects anything that close for as long as they are running, and
        -- drops back to NearClip the moment they stop.
        -- 警员奔跑时使用的同一参数。ped 奔跑时身体前倾而摄像头不会，于是头部会摆向
        -- 镜头，一瞬间你会看到脸的内侧。奔跑期间会剔除这么近的一切物体，停下的瞬间
        -- 恢复为 NearClip。
        --
        -- It also drops their arms and anything held while running, which is the deliberate trade:
        -- a clean picture is worth more than seeing their hands. Lower it toward NearClip to keep
        -- the arms, at the cost of the head clipping through on the first strides of a sprint.
        -- 奔跑时手臂和手持物也会被剔除，这是有意的取舍：干净的画面比看到手更重要。
        -- 把它向 NearClip 调低可以保留手臂，代价是冲刺头几步头部会穿模入镜。
        NearClipRunning = 0.32,
    },

    -- How the picture is graded, applied in the ENGINE rather than drawn over the top. That
    -- matters twice over: it looks like footage rather than like a filter, and because it is part
    -- of the rendered frame it is also what gets recorded.
    -- 画面的调色方式，在引擎内应用而不是后期叠加。这有两层意义：看起来像真实录像
    -- 而不是滤镜；而且因为它是渲染帧的一部分，录制下来的画面也带同样效果。
    Look = {
        -- A GTA timecycle modifier applied for as long as a camera is open. Set to false for a
        -- clean picture. Ones worth trying: 'scanline_cam' and 'scanline_cam_cheap' are the
        -- in-game security feeds, 'CAMERA_secuirity' is darker and greener, and
        -- 'Island_CCTV_ChannelFuzz' adds channel noise on top.
        -- 摄像头打开期间应用的 GTA timecycle 修改器。设为 false 则画面干净无修饰。
        -- 值得一试的选项：'scanline_cam' 和 'scanline_cam_cheap' 是游戏内监控画面
        -- 效果，'CAMERA_secuirity' 更暗更绿，'Island_CCTV_ChannelFuzz' 会在画面上
        -- 叠加频道噪点。
        Timecycle = 'scanline_cam_cheap',

        -- How strongly it is applied, 0.0 to 1.0. Low, because a body-worn camera is a cheap
        -- sensor and not a broken one.
        -- 效果强度，0.0 到 1.0。数值较低，因为执法记录仪是廉价传感器而不是坏了的
        -- 传感器。
        Strength = 0.4,

        -- Handheld movement, as a shake amplitude. A camera strapped to a moving person is never
        -- perfectly still, and a perfectly still one is the main reason a feed reads as a video
        -- game rather than as footage. 0 switches it off.
        -- 手持晃动幅度。绑在移动的人身上的摄像头不可能完全静止，而完全静止的画面
        -- 正是"像游戏而非像录像"的主要原因。0 为关闭。
        Shake = 0.35,
    },

    Dashcam = {
        -- Whether a police vehicle gets its own tile in the grid.
        -- 警用车辆是否在列表中拥有自己的画面卡片（行车记录仪）。
        Enabled = true,

        -- Seconds a dashcam stays on the grid after the officer gets out of the car.
        -- 警员下车后，行车记录仪画面在列表上保留的秒数。
        --
        -- Not a grace period for its own sake: a traffic stop is the moment a dashcam earns its
        -- keep, and it is precisely the moment the officer is stood in front of the car rather
        -- than sitting in it. Dropping the tile the instant they step out would take the camera
        -- away exactly when somebody wants to watch it. 0 keeps the old behaviour.
        -- 这不是为了宽限而宽限：临检停车正是行车记录仪最该发挥作用的时候，而此时
        -- 警员恰恰站在车前而不是坐在车里。刚下车就撤掉画面，等于在最需要看的时候
        -- 把摄像头拿走。0 为旧行为（下车立即消失）。
        LingerSeconds = 180,

        -- Metres the officer may be from the car while that lingering tile lasts. Past this it is
        -- not their car any more, it is one they parked somewhere and walked away from.
        -- 画面保留期间，警员与车辆允许的最大距离（米）。超过这个距离，那就不再是
        -- 他们的车，而是他们停在别处走开的车。
        LingerRange = 60.0,

        -- Where the camera sits in the vehicle.
        -- 摄像头在车内的安装位置。
        --
        -- By default it is sized to the vehicle rather than fixed, because one set of offsets that
        -- suits a cruiser puts the lens inside the bonnet of a van and behind the seats of a bike.
        -- The model's own bounding box gives the windscreen: a fraction of the way to the nose and
        -- a fraction of the way to the roof.
        -- 默认按车型自适应而不是固定偏移，因为同一组偏移适合巡逻车，却可能让镜头
        -- 卡在面包车引擎盖里、或落在摩托车座位后面。利用模型自身的包围盒定位挡风
        -- 玻璃：取到车头方向的某个比例、到车顶方向的某个比例。
        Mount = {
            -- Set to false to ignore everything below and use the fixed offsets instead.
            -- 设为 false 则忽略下面的所有自适应参数，改用固定偏移。
            Auto = true,

            -- Where the camera sits relative to the DRIVER'S SEAT, which is how a real dashcam is
            -- described: behind the rear-view mirror, looking out through the windscreen. Measured
            -- from the seat because every drivable vehicle has one and it is inside the cabin by
            -- definition, so this lands correctly on a cruiser, a van and a bike alike.
            -- 摄像头相对驾驶座的位置，这也是现实中行车记录仪的描述方式：后视镜后方、
            -- 透过挡风玻璃向前看。从座位开始测量，因为每辆可驾驶车辆都有驾驶座，且
            -- 它按定义就在车厢内，所以巡逻车、面包车、摩托车都能正确落位。
            SeatForward = 0.42,
            SeatHeight  = 0.60,

            -- Used only when a vehicle has no driver seat bone to measure from. Fractions of the
            -- model's own size. Less reliable, because a police car's height includes its LIGHTBAR
            -- and a fraction of that sits above the roof rather than under it.
            -- 仅当车辆没有驾驶座骨骼可测量时使用。为模型自身尺寸的比例。可靠性较低，
            -- 因为警车高度包含警灯条，其中一部分在车顶之上而非车顶之下。
            ForwardFactor = 0.28,
            HeightFactor  = 0.62,

            -- The fixed fallback, used when Auto is false or the model gives nothing usable.
            -- 固定兜底参数，当 Auto 为 false 或模型提供不了可用数据时使用。
            Forward  = 0.55,
            Height   = 0.65,
            Side     = 0.0,
            Fov      = 70.0,
            Pitch    = -4.0,
            NearClip = 0.15,
        },

        -- Vehicle models that carry a dashcam. Matched on the server against the model the
        -- officer is actually sitting in, so this is the authoritative list.
        -- 配备行车记录仪的车型。服务端用警员实际乘坐的车型匹配，因此这是权威清单。
        Models = {
            'police', 'police2', 'police3', 'police4', 'policeb', 'policet',
            'sheriff', 'sheriff2', 'fbi', 'fbi2', 'riot', 'pranger', 'polmav',
        },

        -- Vehicle classes that carry a dashcam as well (18 is Emergency). A class can only be
        -- read on the client, so this is reported by the officer's own game rather than read
        -- from the vehicle server-side: it decides which tile appears, never who may watch.
        -- 同样配备行车记录仪的车辆类别（18 为紧急车辆）。车辆类别只能在客户端读取，
        -- 因此这由警员自己的游戏上报，而不是服务端从车辆读取：它只决定出现哪个
        -- 画面，绝不决定谁可以观看。
        Classes = { 18 },
    },

    -- Recording the watch. Because the picture is rendered on the terminal, the only footage that
    -- can exist is footage somebody watched: there is no stream running when nobody is looking,
    -- so there is nothing to capture. What a terminal watches, it can keep.
    -- 录制观看内容。因为画面在终端上渲染，唯一可能存在的录像就是有人看过的画面：
    -- 没人看的时候没有任何流在运行，也就没有东西可采集。终端看过什么，就能保存
    -- 什么。
    Recording = {
        -- Whether watches are recorded at all. With this off the Cameras section is live only and
        -- the Recordings tab does not appear.
        -- 是否允许录制观看内容。关闭后摄像头板块只能实时观看，"录像"标签页不显示。
        Enabled = true,

        -- Whether opening a unit starts recording on its own. Left off, the dispatcher presses
        -- record when something is worth keeping, which is far kinder to storage.
        -- 打开单位画面时是否自动开始录制。默认关闭，由调度员在遇到值得保存的内容
        -- 时手动按录制，对存储空间友好得多。
        Auto = false,

        -- Seconds a single recording may run before it is closed and uploaded. A cap rather than a
        -- suggestion: the whole clip is held in memory on the server until it is uploaded.
        -- 单段录像在关闭并上传前允许录制的最长秒数。这是硬上限而非建议值：整段
        -- 录像在上传前都保存在服务端内存中。
        MaxSeconds = 300,

        -- Recordings shorter than this are thrown away rather than uploaded, so a terminal that
        -- opened the wrong unit for a second does not leave a file behind.
        -- 短于这个秒数的录像会被丢弃而不上传，这样终端不小心开错单位一秒钟也不会
        -- 留下文件。
        MinSeconds = 4,

        -- Capture profile. Width is capped by the watching terminal's own game resolution: asking
        -- for more than they render buys nothing but bitrate.
        -- 采集参数。宽度上限受观看终端自身游戏分辨率限制：要求比实际渲染更高的
        -- 分辨率只会白白增加码率。
        Fps     = 30,
        Width   = 1280,
        Bitrate = 2500000,

        -- How often (ms) the recorder emits a chunk to the server. Each one is paced onto the wire
        -- rather than blocking the net thread.
        -- 录制器向服务端发送数据块的频率（毫秒）。每个数据块都会按节奏发送，而不
        -- 是阻塞网络线程。
        TimesliceMs = 1000,

        -- Send ceiling (bytes/s) each chunk is paced with. Chunks cross the NUI boundary as
        -- base64, which is about a third larger than the encoded video, so leave headroom.
        -- 每个数据块发送时的速率上限（字节/秒）。数据块以 base64 形式跨越 NUI 边界，
        -- 比编码后的视频大约三分之一，因此要留余量。
        ChunkBytesPerSec = 2048 * 1024,

        -- Days a recording is kept before it is pruned. 0 keeps them forever, which is the
        -- default: footage is evidence, and quietly deleting it on a timer is the kind of thing
        -- nobody notices until the one clip that mattered has gone. Set a number here only if
        -- storage is the greater worry.
        -- 录像保留天数，到期清理。0 为永久保留（默认）：录像是证据，按定时器悄悄
        -- 删除证据这种事，往往要到关键那段录像消失了才会被人发现。只有在存储压力
        -- 更大时才在这里设置天数。
        KeepDays = 0,

        -- Recordings one terminal may hold before the oldest is dropped. Deliberately high rather
        -- than absent: it is a backstop against one dispatcher filling the table forever, not a
        -- retention policy. Recordings shared TO somebody count against theirs too.
        -- 一台终端可保存的录像数量上限，超出后最早的被丢弃。刻意设高而不是不设：
        -- 这是防止某个调度员无限占满数据表的兜底，而不是保留策略。别人分享给你的
        -- 录像也占用你的配额。
        MaxPerOfficer = 1000,
    },

    -- Terminals allowed on one officer's camera at once (0 = unlimited).
    -- 同一警员的摄像头允许同时观看的终端数量（0 = 不限）。
    MaxViewers = 6,

    -- Seconds a viewer may go quiet before the server stops counting them as watching. The
    -- terminal refreshes well inside this, so it only fires for a terminal that died without
    -- saying so.
    -- 观看者静默多少秒后服务端不再将其计为观看中。终端会在这个时间内充分刷新，
    -- 因此只有异常退出（没来得及通知）的终端才会触发。
    IdleSeconds = 15,

    -- Whether opening a camera writes a row to the MDT audit log, the same way a handset read
    -- does. The audited action is an officer choosing to watch a particular unit.
    -- 打开摄像头时是否向 MDT 审计日志写一条记录（与查看手机记录一样）。被审计的
    -- 行为是：某警员选择观看某个特定单位。
    LogViewing = true,
}
