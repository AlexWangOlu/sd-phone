-- Loaded for side effects: supplies the two ox_lib string helpers that only exist from v3.39.0
-- (added 2026-06-28, released 2026-07-13). ox_lib has shipped the string MODULE since 2023 and
-- aliases `lib.string = string`, so on an older copy `lib.string` resolves fine and only the
-- function is missing - a nil field, not a nil module. Defining what is absent on the global
-- string table repairs every lib.string call site at once, without pinning users to an ox_lib
-- release five weeks younger than the phone. Each resource owns its Lua state, so this is
-- invisible to every other resource.

if not string.startsWith then
    ---Whether `str` begins with `prefix`. Mirrors ox_lib's own implementation.
    ---@param str string
    ---@param prefix string
    ---@return boolean
    function string.startsWith(str, prefix)
        return str:sub(1, #prefix) == prefix
    end
end

if not string.endsWith then
    ---Whether `str` ends with `suffix`. An empty suffix always matches, as it does in ox_lib.
    ---@param str string
    ---@param suffix string
    ---@return boolean
    function string.endsWith(str, suffix)
        return suffix == '' or str:sub(-#suffix) == suffix
    end
end
