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
- A continuous timber palisade, corner towers/posts, a prominent entrance gate and defensive details.
- A detailed supply shop building with a readable sign, interior, shelves, counter, props and warm lanterns.
- A central campfire gathering area with seating, stones, logs, lighting and ambient effects.
- Rectangular matchmaking pads with crisp, visible perimeter outlines. At this stage they are visual set pieces only; queue logic is intentionally out of scope.
- Forest perimeter dressing: layered trees with grounded trunks, roots, branches and varied crowns; undergrowth, rocks, stumps, fallen logs and natural clutter.
- A deliberate lighting, fog, sound and color pass to support the day/night contrast.

## Roblox Studio architecture

Keep the place modular and preserve unrelated game systems.

```
Workspace/
  THE_FOREST_LOBBY/
    Terrain/
    Architecture/
    Shop/
    Camp/
    QueuePads/
    Nature/
    Props/
    Spawn/
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
Lighting/
SoundService/
```

The exact hierarchy may be adapted to the existing place after it is inspected. Never delete unrelated folders or systems.

## Engineering rules

1. Build through small, named ModuleScripts with clear responsibilities.
2. Use deterministic placement and configuration-driven dimensions.
3. Avoid thousands of unnecessary physical parts; use meshes, unions or grouped assets where appropriate, and anchor static scenery.
4. Keep collision enabled only where players need it.
5. Keep decorative effects and lights within a performance budget.
6. Make installation idempotent: rerunning the builder replaces only its own generated lobby folder.
7. Do not implement queue logic, shop purchases, monetization, UI or survival gameplay until the physical lobby is approved.
8. Validate all scripts in Roblox Studio and fix Output errors before expanding.

## Development milestones

- [ ] M0 — inspect the existing place and preserve its current systems.
- [ ] M1 — block out courtyard, perimeter, gate, spawn and paths.
- [ ] M2 — build the detailed shop exterior and interior.
- [ ] M3 — build campfire, seating, signs, props and rectangular queue pads.
- [ ] M4 — add layered forest dressing and terrain transitions.
- [ ] M5 — lighting, atmosphere, ambient sound and optimization.
- [ ] M6 — Studio test pass and visual polish.

## Current status

Repository initialized. The Roblox place file itself is not stored here yet. Source modules and installer will be added in reviewed, incremental commits.