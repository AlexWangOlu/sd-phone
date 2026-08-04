-- App accounts engine. Governs how many accounts one character may create in each app that
-- signs in through it (Photogram, Cherry, Vibez, Ryde), and nothing else - Mail keeps its own
-- limits in configs/mail.lua, and Squawk is still one account per character.
return {
    -- Accounts one character may create per app. Their usernames must still differ, but the
    -- accounts may share a recovery email and phone number, so one person can run several
    -- handles from a single contact. 0 = unlimited.
    MaxPerApp = 3,

    -- Per-app overrides, keyed by app id. Anything left out uses MaxPerApp above.
    PerApp = {
        -- photogram = 5,
        -- ryde      = 1,
    },
}
