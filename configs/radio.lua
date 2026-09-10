-- Radio app - numeric frequencies carried over pma-voice. RestrictedRanges gates
-- frequency bands to specific jobs: a frequency inside a listed range can only be
-- tuned by a player whose job is in that range's `jobs`. Ranges are inclusive and
-- may overlap (a player passes if they match ANY covering range); frequencies not
-- covered by any range are open to everyone. Leave the list empty for no limits.
-- 无线电应用 - 数字频率通过 pma-voice 传输。RestrictedRanges 用于把频段
-- 限制给特定工作：落在所列范围内的频率，只有工作在该范围 `jobs` 列表中的
-- 玩家才能调到。范围包含端点且可以重叠（玩家匹配任意一个覆盖范围即通过）；
-- 没有被任何范围覆盖的频率对所有人开放。留空列表表示不限制。
return {
    RestrictedRanges = {
        { min = 1.0,  max = 10.0, jobs = { 'police' },                label = 'Police' },  -- 警察频段
        -- { min = 10.1, max = 20.0, jobs = { 'ambulance', 'doctor' },   label = 'EMS' },  -- 急救频段
    },
}
