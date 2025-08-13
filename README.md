# Campaigns
Campaign compatibility changes for MMH55.

---

## Getting Started

### What’s in this repo
- **Test map:** `DEV_C1M1.h5m` at the repository root (use it to verify the conversion pipeline). The test map file itself lives at the repo **root** under that exact name.
- **Campaign sources:** `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>/…`
- **Script editor:** **HoMM5MapScriptsEditor 1.3.50** (recommended for inspecting/editing map scripts).  
  - Original project page: <https://hmm5.sklabs.ru/>  
  - Source code: <https://github.com/HSerg/HoMM5MapScriptsEditor>  
  - A copy is provided in this repository: [`HoMM5MapScriptsEditor.1.3.50.zip`](HoMM5MapScriptsEditor.1.3.50.zip)
- **Utilities:** 7‑Zip/WinRAR for editing `.h5m` archives, and a text/XML editor (Notepad++/VS Code are recommended) for `*.xdb`.

> **Path clarification**  
> Use the **paths from this repository**. The correct mission path is  
> `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>`  
> Do **not** use a folder name with “.h5u”. That suffix appears in packaged mod files, not in this repo layout.  
> If you want to grab files from an installed game, **don’t**—use the files from this repository instead. Mixing versions may lead to unpredictable bugs, behavior changes, and artifacts.

### Repository layout (reference)

```
.
├─ README.md
├─ DEV_C1M1.h5m
├─ HoMM5MapScriptsEditor.1.3.50.zip
└─ UserMODs/
   └─ MMH55-Cam-Maps/
      └─ Maps/
         └─ Scenario/
            ├─ C1M1/
            ├─ C1M2/
            ├─ C1M3/
            ├─ C1M4/
            └─ C1M5/
```

---

## Convert a campaign mission into a single-player map

1. **Duplicate the test map**  
   Copy `DEV_C1M1.h5m` and rename the copy to your working map name, e.g. `DEV_MY_MAP.h5m`.

2. **Rename the internal folder**  
   Open `DEV_MY_MAP.h5m` as a zip archive (7‑Zip/WinRAR).  
   Go to `Maps/SingleMissions/` and rename the folder `DEV_C1M1` → `DEV_MY_MAP`.

3. **Clear the working folder**  
   Inside `Maps/SingleMissions/DEV_MY_MAP/` delete **all existing files**.

4. **Populate with the target mission**  
   From this repository, copy all files from  
   `UserMODs/MMH55-Cam-Maps/Maps/Scenario/<MissionFolder>/`  
   Paste them into the archive at  
   `DEV_MY_MAP.h5m/Maps/SingleMissions/DEV_MY_MAP/`.

> These steps are required if you want to **test a campaign mission as a single‑player map**.

---

## Make the converted map start in single-player

Campaign maps require at least two players for a skirmish start. Activate Player 2 in the map configuration.

1. In `DEV_MY_MAP.h5m`, open `Maps/SingleMissions/DEV_MY_MAP/Map.xdb`  
   (campaigns sometimes use an internal id like `C1M2.xdb`).

2. In the `<players>` section, ensure **Player 2** has `ActivePlayer=true`.  
   A minimal, working item:

```xml
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
  <AddHeroTrigger>
    <Action><FunctionName/></Action>
  </AddHeroTrigger>
  <RemoveHeroTrigger>
    <Action><FunctionName/></Action>
  </RemoveHeroTrigger>
  <VictoryMessageRef href=""/>
  <DefeatMessageRef href=""/>
  <Race>TOWN_INFERNO</Race>
  <Colour>PCOLOR_RED</Colour>
</Item>
```

**Design rule:** keep **Instant Travel** blocked in converted campaign missions (preserves the original level design and encounter intent).

---

## Contributing

Both **fork + PR** and **direct collaborator** flows are supported. When unsure, use **fork + PR**.

### Fork & PR workflow (recommended)

[Fork & PR workflow (YouTube)](https://www.youtube.com/watch?v=-9ftoxZ2X9g "Watch: Fork & PR workflow")

```powershell
# 1) Fork https://github.com/Might-Magic-Heroes-5-5/campaigns on GitHub.

# 2) Clone your fork
git clone https://github.com/ACTUAL_DATA:GITHUB_USERNAME/campaigns.git
cd campaigns

# 3) Add upstream to sync later
git remote add upstream https://github.com/Might-Magic-Heroes-5-5/campaigns.git

# 4) Create a working branch
git checkout -b ACTUAL_DATA:BRANCH_NAME

# 5) Commit changes
git add -A
git commit -m "C1M3: fix enemy hero army formula; enable tutorial; add Memory Mentor"

# 6) (Optional) Use a specific SSH key on Windows PowerShell
$env:GIT_SSH_COMMAND = 'ssh -i ACTUAL_DATA:SSH_PRIVATE_KEY_PATH -o IdentitiesOnly=yes'
git remote set-url origin git@github.com:ACTUAL_DATA:GITHUB_USERNAME/campaigns.git

# 7) Push your branch to your fork
git push origin HEAD:refs/heads/ACTUAL_DATA:BRANCH_NAME
```

Then open a Pull Request from your fork/branch to `Might-Magic-Heroes-5-5/campaigns:main`.

**Before submitting a PR**
- Launch the converted `DEV_*.h5m` in-game and verify it starts from the single-player menu.
- Keep **Instant Travel** disabled where it is disabled in the original mission.
- In the PR description, briefly note what was tested (e.g., “smoke-tested start; Player 2 active”).

### Direct collaborator workflow

```powershell
git checkout -b ACTUAL_DATA:BRANCH_NAME
git add -A
git commit -m "C1M1: tutorial updated for 5.5"
git remote set-url origin git@github.com:Might-Magic-Heroes-5-5/campaigns.git
$env:GIT_SSH_COMMAND = 'ssh -i ACTUAL_DATA:SSH_PRIVATE_KEY_PATH -o IdentitiesOnly=yes'
git push origin HEAD:refs/heads/ACTUAL_DATA:BRANCH_NAME
```

**Troubleshooting push/permissions**
- If a browser auth opens and you receive `403` when pushing, you likely pushed to the **upstream** repo. Ensure `origin` points to your **fork**, or use SSH with the correct key:  
  `git remote -v` → `origin https://github.com/ACTUAL_DATA:GITHUB_USERNAME/campaigns.git`
- ACTUAL_DATA here is your credentials, see git tutorials on how to use it

---

## Media (screenshots & clips)

Place media files under **`git_docs/`**. The links below assume that folder.

### Local video (optional)
If you commit an MP4 to the repo, this pattern shows a **thumbnail that links to the video**:

[![Convert mission demo (MP4)](git_docs/ACTUAL_DATA-convert-thumb.png)](git_docs/ACTUAL_DATA-convert-demo.mp4 "Play MP4 in browser")

> GitHub renders thumbnails as images; clicking opens the video file or YouTube page.

---

## Documentation

General modding knowledge and editor walkthroughs are centralized at the **Heroes 5 Wiki**: <https://heroes5.fandom.com/wiki/Heroes_5_Wiki>.  
Repo-specific guides may also live under `git_docs/` if added.

---

## Changes

### Legend
- **change:** something not broken but behaves different  
- **fix:** fix of ToE bug  
- **fix(RCXX):** fixed regression from specific MMH55 version  
- **new:** new campaign feature

### C1M1 – Haven: The Queen
- fix: Vanilla tutorial is available and updated for 5.5  
- fix: on a very rare occasion due to racing conditions mission would not complete

### C1M2 – Haven: Rebellion
- fix: Vanilla tutorial is available and updated for 5.5  
- fix: Impossible difficulty was treated as Normal

### C1M3 – Haven: The Siege
- fix: Tutorial is available and updated for 5.5  
- fix(RC19c): Enemy hero appeared with 1 imp instead of similar army  
- change: enemy hero army formula was based on Isabel army size **OR** a flat limit whichever is higher. This allowed for abuse as the limit value was static and quite low. The limit formula is now based on the weeks passed since start.  
- change: As soon as the enemy hero appears, he will try to capture the player town and will target player heroes if they are on his way.  
- new: added Memory Mentor  
- new: Added a commented ambush battle vs necro units (likely leftover by Nival developers). Winning grants a random minor artifact.

### C1M4 – Haven: The Trap
- fix: Tutorial is available and updated for 5.5  
- new: added Memory Mentor

### C1M5 – Haven: The Fall of the King
- fix: Tutorial is available and updated for 5.5  
- fix: Siege enemy heroes wander around instead of attacking the castle  
- new: added Memory Mentor
