---@type string[] Every built-in sd-phone app id shipped on the home screen. Custom apps may not
---claim one of these, and the lb-phone compat layer maps foreign app names onto them.
local BUILTIN = {
    'photos', 'bank', 'settings', 'clock', 'messages', 'phone', 'calendar', 'mail', 'weather',
    'maps', 'music', 'stocks', 'ryde', 'notes', 'voicememos', 'health', 'compass', 'groups',
    'services', 'pages', 'review', 'marketplace', 'radio', 'darkchat', 'cherry', 'photogram',
    'garages', 'homes', 'calculator', 'passwords', 'cookie', 'wordle', 'flappy', 'blocks',
    'blackjack', 'climber', 'railrunner', 'connectfour', 'chess', 'battleship', 'vibez',
    'weazelnews', 'streaks', 'birdy', 'appstore', 'camera',
}

---@type table<string, true> Set form of BUILTIN for O(1) membership tests.
local set = {}
for i = 1, #BUILTIN do set[BUILTIN[i]] = true end

return { list = BUILTIN, set = set }
