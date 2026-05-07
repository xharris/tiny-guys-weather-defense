# Tiny Wizard Weather Defense

## TODO

- [x] HUD UI
    - [x] Abilities
    - [x] Cooldowns
    - [x] Stats (ie. Crit chance)
- [x] Pause UI
    - [x] Open with 'P' or 'Esc'
    - [x] Adjust volume
        - [x] Master
        - [x] Music
        - [x] SFX
    - [x] Exit
    - [ ] Polish style
- [x] AudioPlayer component
    - [x] Can adjust volume of audio type (sfx, music, master)
    - [x] Improve positional audio
        - Ants
            - [ ] Only plays once
            - [ ] Position should be average position of all ants?
    - [ ] Forest audio effects? (ie. reverb)
- [ ] Rework controls
    - [ ] Project a small cone in aim direction
    - [ ] Hold primary to enable targeting
    - [ ] While targeting, every 0.2s an enemy in the cone is locked-on (ordered by closest position)
    - [ ] While targeting, lower movement speed / turn rate
    - [ ] Release to use ability on all locked on targets
    - [ ] Ability is released in order or targeting (~0.2s micro-delay)
- [ ] Abilities
    - [ ] Remove crit
    - [ ] Chance for ability to activate twice
    - [ ] Gradually widen cone while targeting
    - [ ] 3s charge = lightning (rework)
    - [ ] Update raindrop vfx
    - [ ] Update lightning vfx
    - [ ] Mini-tornado while charging
- [ ] Enemies
    - [ ] Improve fly movement
    - [ ] Update ant to use velocity instead of setting position manually
- [ ] L/R triggers to do quick 90 deg turns?
    - [ ] May need to lock mouse and show controlled cursor sprite, or just switch to controller-only and worry about kbm later
- [ ] Boss (robots) that have one-shot attacks on player?
    - [ ] Spawn at certain time of day
    - [ ] Appears on certain days (day 3, day 6, day 10, etc)
    - [ ] Wand emits beam of light at night?
    - [ ] Spider
        - [ ] Day
        - [ ] Shoot stun webs
        - [ ] Dash and swipe attack with leg
    - [ ] Night, Firefly robot with laser beam or something

## Inspiration

- ![Rain](https://imgur.com/let-rain-oc-mrICIdC)
- Staccato choir samples, Voices of the Opera
