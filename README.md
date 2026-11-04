# THE FOREST

A Roblox multiplayer survival-horror experience.

## Creative direction

- Main mode: **99 Nights**
- Lobby: a fully walkable physical forest outpost, not a menu screen.
- Visual identity: beautiful, warm, inviting daylight; unsettling, dangerous forest atmosphere after dark.
- Lobby capacity target: 6 players.
- Build order: physical lobby first; gameplay and UI only after the world is approved.

## Lobby experience

The lobby is a handcrafted rectangular forest compound with:
- A large playable courtyard and readable paths.
- A continuous timber palisade, reinforced entrance gate and corner watch posts.
- A detailed supply shop with a readable sign, interior, shelves, counter, stock crates and warm lanterns.
- A central campfire gathering area with six seats, stones, logs and warm light.
- Three rectangular matchmaking pads with bright perimeter outlines. These are visual set pieces only; queue logic is intentionally out of scope.
- A forest perimeter with grounded trunks, roots, branches, layered crowns, bushes and rocks.
- Daytime lighting designed to feel welcoming; the forest beyond the fence remains mysterious.

## First Studio build

The first runnable builder is available at:

`Studio/Installers/LobbyBuilder_1_0.lua`

### Install

1. Open the intended Roblox place in Roblox Studio and save a backup copy first.
2. Open the installer file from this repository.
3. Copy its complete contents.
4. In Studio, open **View → Command Bar**.
5. Paste the code and press Enter.
6. Check the Output window for `THE FOREST | LOBBY BUILDER 1.0 COMPLETE`.
7. Press Play and inspect the whole compound.

The installer creates `Workspace/THE_FOREST_LOBBY`. Re-running it replaces only that generated folder. It does not delete other Workspace folders or game systems. It does update global Lighting settings for the lobby's daytime look. Save a backup before running it.

## Planned Studio architecture

The installer is the first vertical slice. The next iteration will split it into reusable modules while preserving the same generated world:

```
Workspace/
  THE_FOREST_LOBBY/
    01_Ground_And_Paths/
    02_Palisade_And_Gate/
    03_Supply_Shop/
    04_Rectangular_Queue_Pads/
    05_Campfire_Center/
    06_Props_And_Lanterns/
    07_Forest_And_Nature/
    08_Player_Spawn/
    09_Signs/
ReplicatedStorage/
  THE_FOREST/
    Shared/
    Config/
ServerScriptService/
  THE_FOREST/
    Lobby/
    Services/
ServerStorage/
  THE_FOREST/
    Assets/
StarterPlayer/
  StarterPlayerScripts/
    THE_FOREST/
```

## Engineering rules

1. Preserve unrelated game systems and user content.
2. Keep builders deterministic and safe to rerun.
3. Keep static scenery anchored and avoid unnecessary physics.
4. Keep decorative lights and part counts within a performance budget.
5. Do not implement queue logic, shop purchases, monetization, UI or survival gameplay until the physical lobby is approved.
6. Test in Roblox Studio and fix Output errors before expanding.

## Development milestones

- [x] M0 — create repository and document the lobby direction.
- [x] M1 — first physical lobby builder and install instructions.
- [ ] M2 — run in the actual place, inspect screenshots and fix geometry.
- [ ] M3 — upgrade shop details, props and terrain transitions.
- [ ] M4 — split builder into maintainable ModuleScripts.
- [ ] M5 — lighting, atmosphere, ambient sound and optimization.
- [ ] M6 — Studio test pass and visual polish.

## Current status

The first installer is committed. The Roblox place file itself has not been modified by GitHub; the installer must be run in Studio on a backed-up copy of the intended place.