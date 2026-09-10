-- Homes app - lists the player's owned / rented properties from whatever
-- housing system is running. Read-only - the bridge never writes to another
-- resource's tables. Each system is read via its own adapter (server export
-- where one exists, otherwise a defensive DB query).
-- 房产应用 - 从正在运行的住房系统中列出玩家拥有/租赁的房产。只读 - 桥接层
-- 绝不会写入其他资源的数据表。每个系统通过各自的适配器读取（有服务端导出
-- 时用导出，否则使用防御性数据库查询）。
return {
    Enabled = true,  -- 是否启用房产应用

    -- 'auto' picks the first started resource from the list below. Override
    -- with an exact resource name if auto-detect guesses wrong.
    -- 'auto' 会从下面列表中选择第一个已启动的资源。自动检测判断错误时，
    -- 可填写确切资源名强制指定。
    System  = 'auto',

    -- Checked in priority order when System = 'auto'; first `started` wins.
    -- System = 'auto' 时按优先级顺序检查，第一个已启动的生效。
    Resources = {
        'qs-housing', 'ps-housing', 'vms_housing', 'rtx_housing',
        'origen_housing', 'bcs_housing', 'loaf_housing', 'tk_housing', 'RxHousing', 'LNS_Housing',
        'nolag_properties', 'kartik-properties',
    },
}
