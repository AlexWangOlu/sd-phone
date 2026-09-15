# MDT integrations

sd-phone exposes a native MDT API and a compatibility surface under the `lb-tablet` resource name.
The compatibility surface is intentionally limited to data that sd-phone actually stores.

## Native exports

All native exports are server exports on `sd-phone`.

| Export | Arguments | Result |
| --- | --- | --- |
| `mdtGetDepartments` | none | Configured departments |
| `mdtIsEmployee` | `source, department?` | Boolean |
| `mdtGetPermissions` | `source` | Granted SD permission keys |
| `mdtGetAccount` | `source` | Current MDT account |
| `mdtGetCallsign` | `source` | Callsign |
| `mdtSetCallsign` | `actorSource, target, callsign` | `success, data` |
| `mdtGetAvatar` | `source` | Avatar URL |
| `mdtGetPerson` | `source, citizenid` | Permission-gated person record |
| `mdtGetVehicle` | `source, plate` | Permission-gated vehicle record |
| `mdtUpdateVehicle` | `source, data` | Permission-gated updated vehicle |
| `mdtGetReport` | `source, refOrId` | Permission-gated report |
| `mdtSaveReport` | `source, data` | Permission-gated created/updated report |
| `mdtDeleteReport` | `source, refOrId` | `success, message` |
| `mdtGetCase` | `source, refOrId` | Permission-gated case |
| `mdtSaveCase` | `source, data` | Permission-gated created/updated case |
| `mdtDeleteCase` | `source, refOrId` | `success, message` |
| `mdtGetWarrant` | `source, refOrId` | Permission-gated warrant |
| `mdtIssueWarrant` | `source, data` | Permission-gated warrant |
| `mdtCloseWarrant` | `source, refOrId` | Permission-gated closed warrant |
| `mdtVoidWarrant` | `source, refOrId` | Permission-gated voided warrant |
| `mdtRegisterWeapon` | existing export: `data` | Serial or `false, message` |
| `mdtGetWeapon` | existing export: `serial` | Weapon record |
| `mdtGetWeaponsByOwner` | existing export: `citizenid` | Weapon records |
| `mdtSetWeaponStatus` | existing export: `serial, status, actorCitizenid?` | `success, message` |

The native read/write methods that take `source` retain SD’s normal department, grade, domain and
audit checks. `mdtGetTrustedPerson` (LEO only), `mdtGetTrustedVehicle`, `mdtGetTrustedCase`,
`mdtGetTrustedWarrant`, `mdtGetTrustedReport` and `mdtDeleteTrustedReport` exist only to back
LB’s source-less server exports; they are trusted
resource-to-resource operations and should not be exposed to client-controlled input.

## LB-compatible exports

The shim registers these exports when `lb-tablet` is not running:

- MDT discovery and identity: `GetMDTs`, `GetMDT`, `IsEmployeeOfMDT`, `GetMDTPermissions`,
  `GetMDTAccount`, `GetMDTCallsign`, `SetMDTCallsign`, `GetMDTAvatar`.
- Police profile reads: `GetMDTUser`, `GetMDTVehicle`.
- Report reads/writes: `GetMDTReport`, `CreateMDTReport`, `UpdateMDTReport`, `DeleteMDTReport`,
  plus the police and ambulance report aliases.
- Weapon registry: `RegisterMDTWeapon`, `GetMDTWeapon`, plus legacy `RegisterWeapon`.
- Police charge totals: `GetPolicePlayerCharges` (returns SD offence codes as `id` strings).
- Legacy police/ambulance callsign and avatar aliases.

The report adapters use SD report references and accept LB numeric IDs when the ID is an SD row ID.
Police report writes support suspects, civilians, descriptions and gallery attachments. SD does not
store LB’s officer relations, weapon relations or tags on reports, so a police payload containing
those fields is refused with a one-time compatibility warning rather than losing data. Ambulance
reports map patients, doctors, injuries and gallery attachments to SD’s medical report model.

Weapon compatibility is serial-based. SD does not have LB’s numeric weapon profile IDs, so the
registration result and returned `id` are the SD serial string.

`GetPolicePlayerCharges` is also intentionally code-based: SD’s penal code uses string codes, so it
does not fabricate LB numeric charge IDs.

## Deliberately not registered

These LB exports have no SD equivalent and are not shimmed:

- `GetMDTTags`, `GetMDTTag`, `CreateMDTTag`, `DeleteMDTTag` and police/ambulance tag aliases.
- `GetMDTProperty`.
- `GetUnits`, `GetPlayerUnit`, `SetPlayerUnit`, `ResetPlayerUnit`, `CreateUnit`, `RemoveUnit`,
  `SetUnitStatus`, `RenameUnit`, `GetPlayerUnits`.
- `LogMDTJailed`, `GetJailed`, `UpdateJailSentence` and legacy `LogJailed`.
- `UpdateMDTProfile`.
- Police warrant/case writes (`Create*`, `Update*`, `Delete*`) are not registered because LB models
  them as generic report tabs with tags, arbitrary involved entities and criminal sentencing. The
  read aliases `GetPoliceWarrant` and `GetPoliceCase` are available with the common SD fields;
  use the native `mdt*Warrant` and `mdt*Case` exports for complete functionality.

The existing LB dispatch exports remain available through the dispatch shim. The compatibility
kill switch is `sd_phone_lbtabletcompat 0`.
