<div align="center">

# sd-phone (THIS IS A BETA RELEASE, WILL HAVE ISSUES)

**An iOS-themed smartphone for FiveM.** 45+ server-backed apps, real app accounts, a live game-view camera and online multiplayer games. Ships its own custom phone props: eight phone items in eight colours, each tinting both the on-screen frame and the custom prop model held in hand. A unique phone system as well as sim cards can be enabled!

**A drop-in lb-phone replacement.** Scripts and custom apps written against lb-phone's exports and events keep running unmodified, and a first-boot migration carries your players across rather than resetting them: phone numbers and lock passcodes, contacts, call history, blocked numbers, SMS threads including groups, photos and albums, and notes.

If sd-phone is useful to you, please ⭐ the repo. Issues and pull requests are always welcome.

[![Live demo](https://img.shields.io/badge/Live%20demo-try%20it%20in%20your%20browser-F0E155?style=for-the-badge)](https://fivem.samueldev.shop/phone)

[![Release](https://img.shields.io/github/v/release/Samuels-Development/sd-phone?label=Release&logo=github)](https://github.com/Samuels-Development/sd-phone)
[![Downloads](https://img.shields.io/github/downloads/Samuels-Development/sd-phone/total?label=Downloads&logo=github&color=94DD0C)](https://github.com/Samuels-Development/sd-phone)
[![Stars](https://img.shields.io/github/stars/Samuels-Development/sd-phone?label=Stars&logo=github)](https://github.com/Samuels-Development/sd-phone)
[![Discord](https://img.shields.io/discord/842045164951437383?label=Discord&logo=discord&logoColor=white)](https://discord.gg/FzPehMQaBQ)
[![Documentation](https://img.shields.io/badge/Docs-docs.samueldev.shop-94DD0C)](https://docs.samueldev.shop/resources/phone/)

![Framework](https://img.shields.io/badge/Framework-QBCore%20%7C%20QBox%20%7C%20ESX-3b82f6)
![Voice](https://img.shields.io/badge/Voice-pma--voice-3b82f6)
![Compatibility](https://img.shields.io/badge/lb--phone-drop--in%20compatible-3b82f6)

[**Live demo**](https://fivem.samueldev.shop/phone) · [**Documentation**](https://docs.samueldev.shop/resources/phone/) · [**Store**](https://fivem.samueldev.shop) · [**Discord**](https://discord.gg/FzPehMQaBQ)

</div>

---

## Preview

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c1300d66-6530-47d4-ad02-676646b96fc7" />

<img width="1920" height="1080" alt="bb6" src="https://github.com/user-attachments/assets/9234cba8-6293-4a9b-8f5a-372eb97c88af" />

<img width="1920" height="1080" alt="THIS" src="https://github.com/user-attachments/assets/7c9ee63d-a5d6-42ee-8664-a62e06838741" />

<img width="1920" height="1080" alt="mb3" src="https://github.com/user-attachments/assets/896f0a95-2077-405f-b494-17ffbc13684e" />

## Overview

sd-phone is a complete smartphone experience: lockscreen with passcode and Face Unlock, customizable homescreen with a real app switcher, notification banners with persistent server-authoritative unread badges, and a full catalog of apps backed by their own server modules. The UI is a React app rendered inside a real iPhone bezel; the phone is held as an in-hand prop, tints to the colour of the phone item you used, and keeps working while you walk.

Everything player-facing is translatable, apps resume where you left them, and the phone auto-detects your framework, inventory, banking, housing, garage, and voice resources with zero config flags.

## Powered by Fivemanage

<div align="center">

<a href="https://refer.fivemanage.com/samuel"><img src="https://docs.samueldev.shop/fivemanage-banner.png" alt="Fivemanage" width="500" /></a>

### sd-phone is partnered with Fivemanage for media hosting

The Camera, Photos and Voice Memos apps need somewhere to store what they capture. sd-phone uses **[Fivemanage](https://refer.fivemanage.com/samuel)** for that: every screenshot, camera video and voice recording uploads to Fivemanage and comes back as a fast CDN URL, so you never run your own media server. It is the CDN and logging platform trusted by thousands of FiveM servers.

**A free Fivemanage Media API token is required for photo, video and voice-note uploads to work.** In the Fivemanage dashboard open the Tokens tab, create a token of type **Media**, and paste it into `configs/server/apikeys.lua` under `FivemanageMedia`. Without a key the camera and recorders still open, but nothing uploads or saves.

<a href="https://refer.fivemanage.com/samuel"><img src="https://img.shields.io/badge/Get%20started%20with%20Fivemanage-%E2%86%92-0D0D0D?style=for-the-badge" alt="Get started with Fivemanage" /></a>

<sub>The free tier is plenty for most servers.</sub>

</div>

## Apps

| | |
|---|---|
| **Communication** | Phone (1:1, group and company calls over pma-voice), Messages (SMS, group threads, GIFs, money and location cards), Mail (multi-account, global inboxes), Groups, Dark Chat, Radio, Find Friends |
| **Social** | Photogram (posts, stories, DMs, real live video streaming), Birdy, Cherry, Vibez, Streaks, all on a shared accounts engine with registration, sign-in, and password resets delivered in-game |
| **Camera & media** | Camera (live game view: photos, video with voice capture, selfie mode), Photos, Music (with AirShare library sharing), Voice Memos |
| **World** | Maps (CDN-streamed tiles, routing, pins), Garages, Homes, Wallet, Services (company directory, dispatch messaging, phone multijob), Ryde (player-to-player ride hailing), Weazel News, Pages, Marketplace, Review, Weather, Stocks |
| **Games** | Chess, Connect Four, Battleship and Wordle with online lobbies, plus Blackjack, Cookie, Flappy, Blocks, Climber and Rail Runner with server-side leaderboards |
| **Utilities** | Clock (alarms), Calendar, Notes (with sketches), Calculator, Compass, Health, Passwords, App Store, Settings |

## Highlights

- **Real accounts engine.** Social apps use actual registration and login, with verification codes and password resets delivered by in-game mail or SMS. Accounts are global, not per-character-slot.
- **Live game-view camera.** The Camera app renders the world into the phone screen in real time; video clips record your microphone and nearby players' voices.
- **Photogram Live.** Stream real encoded video to other players' phones, with clean late-joins.
- **Deep world integration.** Garages and Homes bridge across ten-plus garage and housing systems; Wallet reads your framework bank; Services maps jobs to callable, messageable companies; Weather mirrors the in-game sky.
- **Custom apps.** Other resources can put their own apps on the phone: one export call turns any webpage into an installable app with icons, badges, notifications, popups and an App Store listing. Custom apps built for lb-phone run unmodified. Start from the [app templates](https://github.com/Samuels-Development/sd-phone-app-templates) (plain JS, React JS/TS, Vue 3, Svelte 5) and the [custom app guide](https://docs.samueldev.shop/resources/phone/custom-apps).
- **lb-phone drop-in compatibility.** Third-party scripts written against lb-phone's exports and events keep working unmodified, and a one-command migrator imports lb-phone player data. See the [compatibility docs](https://docs.samueldev.shop/resources/phone/lb-phone-compatibility).

## For developers

The phone ships a full integration surface, documented at [docs.samueldev.shop](https://docs.samueldev.shop/resources/phone/):

- [Server exports](https://docs.samueldev.shop/resources/phone/exports-server) for sending mail, messages and notifications, starting calls, managing contacts, resolving numbers to players, logging transactions, posting news, and more.
- [Client exports](https://docs.samueldev.shop/resources/phone/exports-client) for opening the phone, deep-linking into apps, and gating phone use.
- [Custom apps](https://docs.samueldev.shop/resources/phone/custom-apps) for shipping your own apps on the phone, with ready-made [templates](https://github.com/Samuels-Development/sd-phone-app-templates) for plain JS, React, Vue and Svelte. Apps written for lb-phone register and run unmodified.
- [First-party events](https://docs.samueldev.shop/resources/phone/events-server) on every lifecycle moment: messages, mail, calls, transactions, posts, contacts.
- [lb-phone compatibility](https://docs.samueldev.shop/resources/phone/lb-phone-compatibility) covering exports, events, and `dependency 'lb-phone'` lines.

```lua
-- A taste: text a player from a job script
exports['sd-phone']:sendSystemMessage('555-0199', 'LS Dispatch', targetNumber, 'New tow request at Legion Square.')

-- React to any SMS being sent
AddEventHandler('sd-phone:server:messages:sent', function(m)
    print(('%s texted %s'):format(m.senderNumber, m.targetNumber))
end)
```

## Compatibility

| Layer | Supported |
|---|---|
| Frameworks | QBCore, QBox, ESX (auto-detected) |
| Inventories | ox_inventory, tgiann-inventory, qb-inventory, qs-inventory(-pro), origen_inventory, codem-inventory, jaksam_inventory, lj-inventory, ps-inventory |
| Voice | pma-voice |
| Housing | 9 housing systems for the Homes app |
| Garages | 10 garage systems for the Garages app |
| Notify | ox_lib (default), lation_ui (opt-in), framework-native fallback |

## Installation

Full guide: [docs.samueldev.shop/resources/phone/installation](https://docs.samueldev.shop/resources/phone/installation)

**Dependencies:** [ox_lib](https://github.com/CommunityOx/ox_lib) · [oxmysql](https://github.com/CommunityOx/oxmysql) · [sd-phone-props](https://github.com/Samuels-Development/sd-phone-props) (streams the in-hand phone models)

1. Drop `sd-phone` and [`sd-phone-props`](https://github.com/Samuels-Development/sd-phone-props) into your resources folder and ensure them after `ox_lib` and `oxmysql`. Database tables create themselves on first boot.
2. Add the phone items to your inventory, one per frame colour (`phone_black`, `phone_blue`, `phone_green`, `phone_orange`, `phone_pink`, `phone_purple`, `phone_red`, `phone_yellow`). Ready-made ox_inventory definitions and item icons are in the [installation docs](https://docs.samueldev.shop/resources/phone/installation); the icons ship in this repo's `images/` folder. Players can also open with the keybind (default F1), gated on owning a phone item.
3. Set your API keys in `configs/server/apikeys.lua`: a [Fivemanage](https://refer.fivemanage.com/samuel) token of type **Media** in `FivemanageMedia` (required for the Camera, Photos and Voice Memos apps to upload), and optionally a GIPHY key for the Messages GIF picker.

**Download the [latest release](https://github.com/Samuels-Development/sd-phone/releases)** (the packaged `sd-phone-*.zip`), not the green *Code -> Download ZIP*. The release zip carries the compiled UI and runs as-is; the source zip is code only and has no `web/build/`, so the phone opens blank.

Building from a git clone yourself: `cd web && npm ci && npm run build`. The output lands in the gitignored `web/build/`; the server logs a clear error on boot if it is missing.

