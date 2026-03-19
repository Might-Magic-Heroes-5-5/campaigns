# Campaigns
Campaign compatibility changes for MMH55.

---

## Getting Started

### What’s in this repo
- **Test map:** `DEV_C1M1.h5m` at the repository **root** (use it to verify the conversion pipeline).
- **Campaign sources:** `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>/…`
- **Script editor:** **HoMM5MapScriptsEditor 1.3.50** (recommended for inspecting/editing map scripts)  
  - Original page: <https://hmm5.sklabs.ru/>  
  - Source code: <https://github.com/HSerg/HoMM5MapScriptsEditor>  
  - A copy is optionally stored here: `HoMM5MapScriptsEditor.1.3.50.zip`
- **Utilities:** 7-Zip/WinRAR for editing `.h5m` archives, and a text/XML editor (Notepad++ / VS Code) for `*.xdb`.

> **Path clarification**  
> Use the **paths from this repository**. The correct mission path is  
> `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>`  
> Do **not** use a folder name with `.h5u` when working inside this repo (that suffix appears in packaged mod files, not in this layout).

### Repository layout (reference)

~~~text
.
├─ README.md
├─ DEV_C1M1.h5m
├─ HoMM5MapScriptsEditor.1.3.50.zip              # optional convenience copy
├─ git_docs/                                      # screenshots, thumbnails, local videos and docs
└─ UserMODs/
   └─ MMH55-Cam-Maps/
      └─ Maps/
         └─ Scenario/
            ├─ C1M1/
            ├─ C1M2/
            ├─ C1M3/
            ├─ C1M4/
            └─ C1M5/
~~~

Additional code loaded dynamically can be found at
./UserMODs\MMH55-Cam-Maps\scripts
it is two files:
campaign_ai.lua
campaign_common.lua

They are loaded on each map and script.lua header as:
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua"); <-- this is from main 5.5 repo
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

Arcane Knowledge: How doFile() Paths Work
The doFile() function loads Lua scripts from a root path defined by the game engine.

For a packaged mod (.h5u file), the root is the archive's root.

For a single map (.h5m file), the root is also the archive's root.

This is why shared campaign scripts, which are placed in the /scripts/ folder at the root of the packaged .h5u mod, are called with a leading slash (e.g., doFile("/scripts/campaign_common.lua")). This indicates an absolute path starting from the root of the archive.

Types are located at this repository in /git_docs/types.xml, it is a copy and in future must be linked from MMH5 core repository. For now it is updated manually by maintainers

They are extracted directly from MMH55-Frame.pak\types.xml


---

## How to convert a campaign into a single-player map

This is needed if you need to test map and run it in Scenarios mode. 
It is useful for making test runs.

These steps reflect the current process used by contributors.
1) **Ensure environment is correct**
   The MMH5.5 Editor (64-bit) is typically at `[Game]\bin\MMH55_Editor_64.exe`. Open `DEV_C1M1.h5m` to confirm your toolchain works.
   Open this editor, and open test map using: "File -> Open" feature
   If everything correct you will see first mission of Isabell
   ![Preview](./git_docs/test_map.png)
2) **Copy the test map**
   Duplicate `DEV_C1M1.h5m` and rename the copy to `DEV_MY_MAP.h5m`.
    
3) **Rename the internal folder**
   Open `DEV_MY_MAP.h5m` as a zip archive (7-Zip/WinRAR).  
   Change `Maps/SingleMissions/DEV_C1M1` → `Maps/SingleMissions/DEV_MY_MAP`.

4) **Clear the working folder**
   Inside `Maps/SingleMissions/DEV_MY_MAP/`, delete **all** files.

5) **Copy mission files from the repo**
   From this repo, copy everything from:  
   `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<mission_name>/`  
   and paste **into the archive** at:  
   `DEV_MY_MAP.h5m/Maps/SingleMissions/DEV_MY_MAP/`.

6) **Rename the main map file and update the tag**
   - Rename the mission’s main map file from `C1M1.xdb` (or the mission’s original name) to **`map.xdb`**.  
   - Open `map-tag.xdb` in the same folder and change the `AdvMapDesc` line to:

   ~~~xml
   <AdvMapDesc href="map.xdb#xpointer(/AdvMapDesc)"/>
   ~~~

> **When committing changes back to the campaign sources in this repo:**  
> - Rename **`map.xdb` back to the original file name** (e.g., `C1M1.xdb`).  
> - Revert any temporary player changes you made to start the map as a skirmish (see the next section).

---

## Make the converted map start in single-player

Campaign maps require at least two players to start as a skirmish. Activate Player 2 in the map configuration.

1) Open `DEV_MY_MAP.h5m/Maps/SingleMissions/DEV_MY_MAP/map.xdb` (or the internal mission id file if you haven’t renamed yet).  
2) In the `<players>` section, ensure **Player 2** has `ActivePlayer=true`. A minimal known-good item:

~~~xml
<Item>
  <MainTown/>
  <MainHero/>
  <ActivePlayer>true</ActivePlayer>
  <Team>0</Team>
  <CanBeHumanPlayer>true</CanBeHumanPlayer>
  <CanBeComputerPlayer>true</CanBeComputerPlayer>
  <Behaviour>PB_RANDOM</Behaviour>
  <CaptureAbility>0</CaptureAbility>
  <StartHero/>
  <HeroInTown>false</HeroInTown>
  <ReserveHeroes/>
  <AddHeroTrigger><Action><FunctionName/></Action></AddHeroTrigger>
  <RemoveHeroTrigger><Action><FunctionName/></Action></RemoveHeroTrigger>
  <VictoryMessageRef href=""/>
  <DefeatMessageRef href=""/>
  <Race>TOWN_INFERNO</Race>
  <Colour>PCOLOR_RED</Colour>
</Item>
~~~
## Design notes and inspirations tracked:
**Design rule:** keep **Instant Travel** blocked in converted campaign missions (preserves the intended progression and encounter design).

---

## Contributing

Both **fork + PR** and **direct collaborator** flows are supported. When unsure, use **fork + PR**.

### Fork & PR workflow (recommended)

[Fork & PR workflow](https://www.youtube.com/watch?v=-9ftoxZ2X9g "Watch: Fork & PR workflow")

~~~powershell
# 1) Fork https://github.com/Might-Magic-Heroes-5-5/campaigns on GitHub.

# 2) Clone your fork
git clone https://github.com/ACTUAL_DATA_GITHUB_USERNAME/campaigns.git
cd campaigns

# 3) Add upstream (original repo) to sync later
git remote add upstream https://github.com/Might-Magic-Heroes-5-5/campaigns.git

# 4) Create a working branch
git checkout -b ACTUAL_DATA_BRANCH_NAME

# 5) Commit atomic changes
git add -A
git commit -m "C1M3: fix enemy hero army formula; enable tutorial; add Memory Mentor"

# 6) (Optional) Use a specific SSH key on Windows PowerShell
$env:GIT_SSH_COMMAND = 'ssh -i ACTUAL_DATA_SSH_PRIVATE_KEY_PATH -o IdentitiesOnly=yes'
git remote set-url origin git@github.com:ACTUAL_DATA_GITHUB_USERNAME/campaigns.git

# 7) Push your branch to your fork
git push origin HEAD:refs/heads/ACTUAL_DATA_BRANCH_NAME
~~~

Open a Pull Request from your fork/branch to `Might-Magic-Heroes-5-5/campaigns:main`.

**Before submitting a PR**
- Launch the converted `DEV_*.h5m` in-game and verify it starts from the single-player menu.
- Keep **Instant Travel** disabled where the original mission has it disabled.
- In the PR description, note what was tested (e.g., “smoke-tested start; Player 2 active”).

### Direct collaborator workflow

~~~powershell
git checkout -b ACTUAL_DATA_BRANCH_NAME
git add -A
git commit -m "C1M1: tutorial updated for 5.5"
git remote set-url origin git@github.com:Might-Magic-Heroes-5-5/campaigns.git
$env:GIT_SSH_COMMAND = 'ssh -i ACTUAL_DATA_SSH_PRIVATE_KEY_PATH -o IdentitiesOnly=yes'
git push origin HEAD:refs/heads/ACTUAL_DATA_BRANCH_NAME
~~~

**Troubleshooting push/permissions**
- If a browser auth opens and you receive **403**, you likely pushed to the **upstream** repo. Ensure `origin` points to your **fork**, or use SSH with the correct key:  
  `git remote -v` → `origin https://github.com/ACTUAL_DATA_GITHUB_USERNAME/campaigns.git`

---

## How to add Media for documentation (screenshots & clips)

Place media under **`git_docs/`** in this repo.
Examples how to write README:

- **Local MP4 with clickable thumbnail** (thumbnail must also be in `git_docs/`):  
  `[![Convert demo](git_docs/ACTUAL_DATA-convert-thumb.png)](git_docs/ACTUAL_DATA-convert-demo.mp4 "Play MP4")`

- **YouTube with custom thumbnail** (thumbnail in `git_docs/`):  
  `[Fork & PR workflow](https://www.youtube.com/watch?v=-9ftoxZ2X9g "Watch on YouTube")`

- **Screenshots from the discussion** (replace file names with actual ones you commit under `git_docs/`):  
  `![Guide step 1](git_docs/ACTUAL_DATA-guide-1.png)`  
  `![Guide step 2](git_docs/ACTUAL_DATA-guide-2.png)`  
  `![Guide step 3](git_docs/ACTUAL_DATA-guide-3.png)`  
  `![Guide step 4](git_docs/ACTUAL_DATA-guide-4.png)`

---

## Documentation

General modding knowledge and editor walkthroughs are centralized at the **Heroes 5 Wiki**: <https://heroes5.fandom.com/wiki/Heroes_5_Wiki>.  
Repo-specific guides may also live under `git_docs/` as well as files.

# 1) Creatures lua parsing
python scripts/parse_creatures_to_lua.py \
  --root "C:/Program Files (x86)/GOG Galaxy/Games/campaigns" \
  --types "C:/Program Files (x86)/GOG Galaxy/Games/campaigns/types.xml" \
  --out "C:/Program Files (x86)/GOG Galaxy/Games/campaigns/h55_enums_creatures.lua"

# 2) Spells (updated to Lua)
python scripts/parse_spells.py \
  --root "C:/Program Files (x86)/GOG Galaxy/Games/campaigns/LOCAL_DIR" \
  --types "C:/Program Files (x86)/GOG Galaxy/Games/campaigns/types.xml" \
  --lua  "C:/Program Files (x86)/GOG Galaxy/Games/campaigns/h55_enums_spells.lua"

# 3) General packing information
## How to package a map for the campaign

After modifying a mission and testing it as a single-player map, you need to package it back into the campaign format to be used in the game's campaign mode.

1.  **Revert Test-Only Changes**: Before packaging, undo any modifications made solely for single-player testing. This typically includes deactivating Player 2 if you enabled them to launch the map as a skirmish.
2.  **Prepare the Folder Structure**: Create a directory structure that mirrors the game's requirements. For example, for mission C1M4, the structure would be `Maps/Scenario/C1M4/`.
3.  **Place Map Files**: Copy your final map files (e.g., `C1M4.xdb`, `map-tag.xdb`) into the mission folder you created (e.g., `C1M4/`). Ensure the `map-tag.xdb` correctly points to the main map file.
4.  **Create the Archive**:
    * Archive the root `Maps` folder into a `.zip` file.
    * Rename the file extension from `.zip` to `.h5u` (e.g., `my_changes_for_C1M4.h5u`).
5.  **Install the Mod**: Place the final `.h5u` file into your game's `UserMods` folder to apply the changes.

## Other Modding Questions (FAQ)

### Can neutral heroes be added in the editor?

No, it is not currently possible to add a neutral hero to a creature stack in the Map Editor, similar to the feature available in QAI for generated maps. This is considered extremely difficult to implement due to the complexity of the feature and a lack of knowledge on the Map Editor's internal workings.

### Where are game object IDs (spells, units, etc.) located?

The name-to-ID mappings for all in-game objects can be found in the `types.xml` file, which is extracted from the `MMH55-Frame.pak` file. This includes IDs for spells, units, towns, adventure map objects, and more.

---

## Gameplay Changes

### Legend
- **change:** something not broken but behaves different
- **fix:** fix of ToE bug
- **scene(xxx)** changes for campaign scenes/cutscenes. xxx inside brackets denote when the cutscene occurs. Intro/Outro means start/end of mission scene.
- **new:** new campaign feature

### C1M1 – Haven: The Queen
- fix: Vanilla tutorial is available and updated for 5.5
- fix: on a very rare occasion due to racing conditions mission would not complete

### C1M2 – Haven: Rebellion
- fix: Vanilla tutorial is available and updated for 5.5
- fix: Impossible difficulty was treated as Normal

### C1M3 – Haven: The Siege
- fix: Tutorial is available and updated for 5.5
- change: enemy hero army formula was based on Isabel army size **OR** a flat limit whichever is higher. This allowed for abuse as the limit value was static and quite low. The limit formula is now based on the weeks passed since start and increase faster based on diffiuclty.
- change: As soon as the enemy hero appears, he will try to capture the player town and will target player heroes if they are on his way
- new: added Memory Mentor
- new: Added a commented ambush battle vs necro units (likely leftover by Nival developers). Winning grants a random minor artifact

### C1M4 – Haven: The Trap
- fix: Tutorial is available and updated for 5.5
- new: added Memory Mentor

### C1M5 – Haven: The Fall of the King
- fix: Tutorial is available and updated for 5.5
- fix: Siege enemy heroes wander around instead of attacking the castle
- new: added Memory Mentor
- new: increased grail spawn locations from 3 to 11
- change: "Protect Dunmor" quest - enemy onslaught attacks against Dunmor will continue inifinitely (previously were only up to 3) and will stop only when the condition for that has triggered.
- change: "Protect Dunmor" quest - onslaught attacks will stop, on normal and hard difficulies - when the Grail is built, on Heroic and Impossible difficulties - when Godric has left.

### C2M3 – Inferno: The Conquest
- fix: Druid weekly growth magic did not start unless player captured Wenlan, now that happens on any captured Sylvan town.
- fix: Player 2 heroes no longer flee battles
- change: Reduced amount and power of weekly elven spawns per week due to Elven source magic.
- change: Elder Druids circle power increased
- new: Added Memory Mentor

### C2M4 – Inferno: The Ship
- fix: Erewell stopped being reinforced after week 4.

### C3M1 – Necropolis: The Temptation
- changed: Starting bonus choice
- changed: Academy heroes tracking is available on all difficulties but their detection range is being reduced.
- fix: Enemy hero Amin did not patrol the map as inteneded

### C3M2 – Necropolis: The Attack
- fix: Certain player movement could make patrols halt and stop at place indefinitely
- fix: Enemy patrol ships that attack player hero could trigger multiple combats one after another instead of one

### C3M3 – Necropolis: The Invasion
- fix: Player is not granted Cloak of Death's Shadow upon any of his heroes visiting Bahiyaa
- change: Cloak of Death's Shadow and Staff of the Netherworld are given only when Markal visits Ziyad and Bahiyaa instead of any player hero. That is reflected in quests description
- new: Added Memory Mentor

### C3M5 – Necropolis: Lord of Heresh
- fix: Godric's Angel trap does not trigger on a rare occasion which breaks the main quest line
- fix: Renegade upgrade type units does not run away from Isabella. Now they are and Godric receives True upgrade type reinforcements for the final battle
- change: Godric reinforcement mechanic is now aligned with game difficulty level.
- change: When Godric sabotage troops take ownership of a player mine the camera will move to the mine location
- change: Player3 (Academy) heroes are more aggressive, their onslaught will focus on sieging and taking player cities at any cost
- new: Added Memory Mentor

### C4M2 – Dungeon: The Expansion
- fix: Removed an undeground Vampire lords stack  as it could not be attacked nor it guarded any treasures.

### C4M3 – Dungeon: The Cultists
- fix: Red AI player (Inferno) heroes wander around instead of attacking player towns and heroes
- fix: Red AI player (Inferno) heroes could freeze till end of game
- fix: multiple 5.5 related script crashes that may stop mission objectives from finishing even though requirements are met
- new: Added Memory Mentor

### C4M4 – Dungeon: The March
- fix: Storyline enemy is Grawl but the actual in-game hero was Alastor

### C4M5 – Dungeon: Raelag's Offer
- fix: an undeground Poltergeist stack is now removed as it could not be attacked nor it guarded any treasures

### C5M1 - Sylvan: The Refugees
- fix: Orson onslaught hero could not spawn and attack because he was already present on map
- fix: Onslaught heroes did not attack or rarely attack any posts due to bug into ToE engine
- change: Biara army size increased

### C5M3 - Sylvan: The Defense
- change: Disabled "Summon Boat" spell on map so Purple player cannot cross the river (Findan already has the spell).
- change: Disabled Purple player from hiring heroes in  Syris Thalla.
- change: Purple player oslaught heroes will spawn only when none are present and he has no control over Syris Thalla.
- change: Diraya skills due to her class being changed from Avenger to Druid
- fix: Purple player oslaught heroes sometimes did not appear and attack Syris Thalla.
- fix: "Prepare the garrison" quest did not always count some base/upgrade type of Druids, Unicorns, Dragons.
- fix: "Prepare the garrison" quest did not count units in heroes at the town gate unless it is Findan.
- new: Added Memory Mentor

### C5M4 - Sylvan: The Archipelago
- new: Added Memory Mentor
- change: Inferno heroes army is now stronger and will scale up with every month that passes by

### C5M5 - Sylvan: The Vampire Lord
- fix: mission dialog where Findan sends a messenger to Zehir did not trigger on start of month 2. This is Nival code error and also did not appear in standard campaigns. The dialog has only narrative meaning and did not break the gameplay.
- fix: Nikolay occasionally transfered his army to other heroes due to AI not considering him the main player hero.
- fix: Player 2 heroes no longer flee from combat and fight till the very end.
- change: Nikolay army is now stronger on Impossible difficulty. He also knows all Dark and Summoning spells and gains 0/5/10/15 Attack and Defense on Normal/Hard/Heroic/Impossible difficuties.
- new: map ambient light was not changed proplerly as the night draws near. Now the dusk will gradually become darker. If the player manages to break the dragons causing the night, daylight will shine bright.
- new: Combat arena light and Skydome reflects the one on the adventure map.
- new: Message will notify the player when the night countdown is at 40%, 20% and when the night comes
- new: Camera will go through the locations of all player visible Spectral Dragons when the night counter is at 60%.
- changed: Night counter increases 25% faster at Hard, 50% faster at Heroic and 75% faster at Impossible difficulty

### C6M2 - Academy: The Liberation
- fix: it was possible to get the outro cinematic if you directly capture Lorekeep. Now that happens only when the mission is about to end.
- fix: Lorekeep capture quest can now change from completed to active state if the enemy captures it from the player.
- fix: AI hired and cluttered many heroes on the Lorekeep island for no reason. 
- new: Lorekeep now has a hero that guards it (was empty before) and his army power is based on game difficulty level.
- new: Added Memory Mentor

### C6M3 - Academy: The Triumvirate
- fix: final Markal fight (vs Findan) used dummy Markal hero instead of the one importred from C3M5
- change: First Garrison troop strength increased by about 30%
- change: Haven towns are now of higher town level:
   - Dwellings: T1, T2, T3, T4, T5 built up to non-upgraded level.
   - Magic Guilds  from none to level 3
   - Common buildings: Village to Town Hall, +Marketplace, +Blacksmith, Tavern is disabled.
- change: Markal fights are now more challenging and scale with difficulty and time passed.

### C6M4 - Academy: The Alliance
- fix: added missing scene after Isabel is defeated
- new: Added Memory Mentor
- change: Isabel army size significantly increased and is based on difficulty

### C6M5 - Academy: Zehir's Hope
- new: Added Hill Fort on the map and the player starts with 500000 gold
- changed: Reworked Biara and Sovereign fights
- changed: Buffed Godric's army as his army value was considerably lower then the other heroes.

### A1C1M1 - Freyda: Rebels
- fix: Overlapping messages during troop desertion made them unreadable

### A1C1M4 - Freyda: Negotiations
- new: Added Memory Mentor

### A1C1M5 - Freyda: The Choice
- new: Added Memory Mentor

### A1C2M1 - Wulfstan: The Borderzone
- change: Raise level cap from 14 to 20

### A1C2M2 - Wulfstan: The Ambush
- change: Enemy hero leading the final attack is now more challenging.
- change: Lich stack with hidden army at Dungeon entry is now more challenging.
- change: Raise level cap from 22 to 25.
- new: Added Memory Mentor

### A1C2M3 - Wulfstan: The Guerrillas
- fix: Underground Haven hero did not patrol as intended
- fix: Caravan for "Intercept gold caravan" quest occasionally did not appear which made the mission unable to complete.

### A1C2M4 - Wulfstan: Two Brothers
- fix: Enemy hero interacting with scripted creatures invoked player recruiting dialogue instead of invoking a fight.
- fix: Duncan artifacts from mission A1C1M5 were not loaded
- change: Torhall siege combat is now more challenging.
- change: Replaced Cartographer with Memory Mentor

### A1C2M5 - Wulfstan: Laszlo
- fix: Duncan artifacts from mission A1C2M4 were not loaded
- fix: Dwarven Treasury could not be entered/attacked.

### A1C3M1 - Ylaya: The Spy
- change: Raise level cap from 14 to 20

### A1C3M2 - Ylaya: The Break
- change: Raise level cap from 22 to 25
- fix: unit attack/hit animation stuters on adventure map

### A1C3M3 - Ylaya: The Meeting
- fix: unit attack/hit animation stuters on adventure map
- fix: unreachable resource pile near the town towards the north
- new: Added Memory Mentor

### A1C3M5 - Ylaya: The Decoupling
- fix: Duncan and Wulfstan artifacts from mission A1C2M5 were not loaded
- change: Adjusted Siege catapult attack animation frequency. Now it is more like siege engine and less like gatling gun.
- new: Added Memory Mentor

### A2C0M0 - Rage of The Tribes: A Murder of Crows
- fix: Removed wondering enemy player hero.
- changed: Voron Peak defending army strengtened

## Dialogue changes

Changes that affect quality of dialogue scenes or lore. Credit goes to Rommy and Mооnst@r from the [Remastered Campaigns project](https://forum.heroesworld.ru/showthread.php?t=18706).

- Added Widescreen support for loading screens, cinematics and dialogues.

### C1M1 – Haven: The Queen
- scene(intro): Footman die from Succubus retaliation and then they are seen alive in the next camera shot. Now Footman are just damaged. Cavalry die animation was shown at Pit Lord Meteor Shower cast when they were already dead. Modified the timings of some scenes for better immersion.

### C1M2 – Haven: Rebellion
- scene(intro): Removed overly green fog ambience
- scene(capture Ashwood): Removed overly green fog ambience

### C1M3 – Haven: The Siege
- scene(clear scouts): Footman cheer animation is now in sync with Isabel's one

### C1M4 – Haven: The Trap
- scene(boots of Levitation): Added missing Isabel's sword animation effect

### C1M5 – Haven: The Fall of the King
- scene(intro): Added missing Freyda cheer animation when she agrees with Godric
- scene(Isabell going to Nicolai): Added missing Isabel sword animation during cast. Removed double buff sound. Adjusted angle so camera will not dip below terrain level.
- scene(Isabell going to Nicolai): 

### C2M1 – Inferno: The Betrayal
- scene(spot Erasiel): Scene showed enemy as Agrael instead of Erasiel

### C2M2 – Inferno: The Promise
- scene(clash with Haven army): Added missing Griffin flying animation at the end of scene

### C2M3 – Inferno: The Conquest
- scene(defeat Gilraen): Remove overly fog ambience
- scene(intro): Added Observatory doodad and Agrael happy animation
- scene(capture Sylvan city): Added a Tree of Knowledge doodad
- scene(at first week of Sylvan growth): Added a Tree of Knowledge doodad
- scene(attack druids): Added missing stone circle doodads
- scene(deafeated druids): Added missing stone circle doodads

### C2M4 – Inferno: The Ship
- scene(intro): Added missing Observatory doodad.
- scene(meet dragons): Improved Dragon entrance animation timing.
- scene(meet dragons): Added missing attack animation at dragon entrance
- scene(deserting units): Added mountain and misc doodads in the background
- scene(capture Nebyrciaz): Added missing Agrael cast animation

### C2M5 – Inferno: Agrael's Decision
- scene(outro): Removed overly green ambience

### C3M1 – Necropolis: The Temptation
- scene(intro): Removed overly foggy ambience
- scene(Markal death): Added missing Markal spell effect during cast
- scene(reach Vigil): Adjusted camera height so scene so Markal stays in frame.

### C3M3 – Necropolis: The Invasion
- scene(gather skeletons): Slightly adjusted camera set movement to sync with army cheer

### C3M5 – Necropolis: Lord of Heresh
- scene(intro): Added missing sound of Godric being hit by archer arrows. Blind effect cast on archers was positioned too low.
- scene(at prison): Added missing Freyda reaction after Markal cast

### C4M1 – Dungeon: The Clanlord
- scene(intro): Added grass and mountain doodads. One of the riders behind Raelag was "happy" insead of sitting idle.

### C4M2 – Dungeon: The Expansion
- scene(intro): Improved Raelag and Matron idle animation pace.
- scene(meet Shadya): Improved Raelag idle animation pace.
- scene(messengers escape): Adjusted camera angle to show Raelag talking instead of pointing at the empty sky.
- scene(grail in town): Added missing Raeleg spell effect during cast.

### C4M3 – Dungeon: The Cultists
- scene(Inferno arrival): Added missing spell effect during Raeleg cheer
- scene(Inferno defeated): Added missing spell effect during Raeleg cheer

### C4M5 – Dungeon: Raelag's Offer
- scene(outro): Fixed endless hoof movement sound. Fixed Markal was seen in camera before he arrives.

### C5M2 – Sylvan: The Emerald Ones
- scene(dragons assembled): Adjusted camera height to keep Findan inside frame

### C5M3 – Sylvan: The Defense
- scene(capture town): Dragons were seen in camera view before they arrived in combat
- scene(free both heroes): fixed both hero models were using Diraya female, now the second hero model is Findan's as it should.

### C5M4 - Sylvan: The Archipelago
- scene(defend Tieru): Camera angle adjacent to show Findan instead of the sky above him
- scene(Tieru death):  Biara's Meteor Shower that kills Tieru is presented properly
- scene(outro): Biara escape spell effect was not properly shown

### C5M5 - Sylvan: The Vampire Lord
- scene(intro): Sound volume was too high
- scene(outro): Added missing spell effect for Findan at the end

### C6M3 - Academy: The Triumvirate
- scene(intro): Added missing idle animation which caused Narxes to T-pose
- scene(prison): Added missing bash sound when godric hit his shield

### C6M4 – Academy: The Alliance
- scene(meet Raelag): camera is now showing Godric, Findan and Zehir while talking instead of the sky above them

### A1C1M1 - Freyda: Rebels
- scene(intro): Alaric speech animation
- scene(ambush): Freyda reaction timing when soldier is killed

### A1C1M2 - Freyda: The Suspicion
- scene(intro): Alaric speech animation
- scene(intro): Peasant convertion to Horned Daemons was not in sync and looked weird
- scene(burnt hut): Alaric speech animation

### A1C1M3 - Freyda: Duncan 
- scene(intro): leading peasant happy animation duration was too short
- scene(outro): Alaric speech animation

### A1C1M4 - Freyda: Negotiations 
- scene(intro): Alaric speech animation

### A1C2M2 - Wulfstan:  The Ambush
- scene(outro): Corrected Rolf's camera position as Isabel's model was visible on the widescreen monitor before she appeared.

### A1C2M5 - Wulfstan: Laszlo
- scene(outro): Removed an incorrect English phrase in the final cutscene of the fifth mission.

### A1C3M5 - Ylaya: The Decoupling
- scene(Alaric withdrawal): Alaric speech animation
- scene(outro): Alaric speech animation
