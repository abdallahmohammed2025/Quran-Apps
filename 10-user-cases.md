# Detailed User Cases

This document provides detailed user case specifications following the format: Actor, Preconditions, Main Flow, Alternate Flows, Postconditions, and Acceptance Criteria.

## Quran Reading User Cases

### UC-Q-01: Resume Reading from Home

**Actor**: User (Daily Reader persona)

**Preconditions**:
- App has stored last-read ayah
- App is installed and configured
- User has previously read Quran in app

**Main Flow**:
1. User opens app → Home screen displayed
2. User sees "Resume Reading" section showing:
   - Last-read surah name (Arabic + transliteration)
   - Last-read ayah number or page number
3. User taps "Resume Reading" button
4. App opens Quran reading view at last-read ayah
5. App highlights that ayah for 2 seconds (visual feedback)
6. App updates "last-opened timestamp" (for analytics)

**Alternate Flows**:
- **A1**: Last-read position missing or invalid
  - App shows "Start Reading" button instead
  - On tap, opens surah list
  - User selects surah to begin reading
  
- **A2**: Database locked or corrupted
  - App detects corruption
  - Shows safe mode prompt: "Rebuild content index?"
  - If user confirms: Rebuilds index, preserves user data if possible
  - If user declines: Shows error, offers to contact support

- **A3**: App is offline
  - Resume reading still works (uses local data)
  - No network dependency for reading

**Postconditions**:
- Reading view is open at last-read position
- Last-read position remains unchanged until user scrolls
- User can continue reading from where they left off

**Acceptance Criteria**:
- Resume reading opens in < 500ms from tap when offline
- Last-read position is accurate
- Highlight animation is smooth
- Works without network connection

---

### UC-Q-02: Navigate to Specific Surah

**Actor**: User

**Preconditions**:
- App is installed and content packs are downloaded
- User is on Home or Quran tab

**Main Flow**:
1. User taps "Go to Surah" (from Home) or opens Quran tab
2. App displays surah list (all 114 surahs)
3. User scrolls or searches to find desired surah
4. User taps on a surah (e.g., "Al-Baqarah")
5. App opens reading view at ayah 1 of selected surah
6. App shows surah header with name and bismillah (if applicable)

**Alternate Flows**:
- **A1**: User has "remember per-surah position" enabled
  - App opens at last position within that surah (if exists)
  - Otherwise opens at ayah 1

- **A2**: User uses search to find surah
  - User types surah name in search
  - App filters surah list
  - User taps result
  - Same as main flow from step 5

- **A3**: User uses jump-to feature
  - User taps "Jump to" button
  - User selects "Surah + Ayah" option
  - User picks surah from picker
  - User picks ayah number
  - App opens at specified location

**Postconditions**:
- Reading view is open at specified surah
- User can read from that position
- Last-read is updated as user scrolls

**Acceptance Criteria**:
- Surah list loads in < 300ms
- Reading view opens in < 500ms
- Search works instantly
- Jump-to navigation is accurate

---

### UC-Q-03: Search for Ayah

**Actor**: User (Learner persona)

**Preconditions**:
- App is installed
- Search index is built (local or downloaded)
- User is on Quran tab or Search screen

**Main Flow**:
1. User taps "Search" button or opens Search screen
2. User enters search query (Arabic or translation text)
3. App shows search results as user types (debounced 300ms)
4. Results are grouped by surah
5. Each result shows:
   - Surah name
   - Ayah number
   - Snippet with highlighted search term
6. User taps a search result
7. App opens reading view at that ayah
8. App highlights the search term in the ayah text

**Alternate Flows**:
- **A1**: No results found
  - App shows message: "No results found"
  - Suggests: "Try different search terms" or "Check spelling"
  - User can modify query

- **A2**: Very large result set
  - App shows first 50 results
  - Shows "X results found, showing first 50"
  - User can load more by scrolling
  - Or refine search with filters

- **A3**: User applies filters
  - User selects "Filter by Surah" or "Filter by Juz"
  - App filters results accordingly
  - Results update immediately

- **A4**: Offline search
  - Search works using local index
  - No network required
  - Same functionality as online

**Postconditions**:
- Reading view is open at selected ayah
- Search term is highlighted
- User can continue reading from that point

**Acceptance Criteria**:
- First results appear in < 300ms
- Search works offline
- Results are accurate and relevant
- Highlighting is clear and visible

---

### UC-Q-04: Create Bookmark

**Actor**: User

**Preconditions**:
- User is reading Quran in reading view
- User has tapped on an ayah

**Main Flow**:
1. User taps on an ayah
2. App shows ayah actions sheet/bottom sheet
3. User taps "Bookmark" option
4. App shows bookmark creation dialog:
   - Optional: Select folder
   - Optional: Add label
   - Optional: Choose color
5. User confirms (or uses defaults)
6. App creates bookmark
7. App shows confirmation (toast or checkmark)
8. Bookmark is saved locally
9. Bookmark is synced to cloud (if sync enabled)

**Alternate Flows**:
- **A1**: User selects existing folder
  - App shows folder picker
  - User selects folder
  - Bookmark is added to that folder

- **A2**: User creates new folder
  - User taps "New Folder"
  - User enters folder name
  - Folder is created
  - Bookmark is added to new folder

- **A3**: Bookmark already exists for this ayah
  - App shows "Already bookmarked" message
  - Offers to edit or remove bookmark
  - User can update bookmark details

- **A4**: Offline creation
  - Bookmark is saved locally
  - Queued for sync when online
  - Same user experience

**Postconditions**:
- Bookmark is created and saved
- Bookmark appears in Library/Bookmarks
- Bookmark can be accessed later
- Last-read position unchanged

**Acceptance Criteria**:
- Bookmark creation is instant (< 100ms)
- Bookmark persists across app restarts
- Bookmark syncs when online (if enabled)
- Works offline

---

### UC-Q-05: Add Note to Ayah

**Actor**: User (Learner persona)

**Preconditions**:
- User is reading Quran in reading view
- User has tapped on an ayah

**Main Flow**:
1. User taps on an ayah
2. App shows ayah actions sheet
3. User taps "Add Note" option
4. App opens note editor
5. User types note text
6. User taps "Save"
7. App saves note (auto-saves draft every 30 seconds)
8. App shows confirmation
9. Note indicator appears on ayah in reading view
10. Note is saved locally
11. Note is synced to cloud (if sync enabled)

**Alternate Flows**:
- **A1**: User cancels note creation
  - User taps "Cancel"
  - App discards draft (after confirmation if text entered)
  - Returns to reading view

- **A2**: Note already exists for this ayah
  - App opens existing note for editing
  - User can update note
  - Save updates existing note

- **A3**: Long note text
  - Editor supports scrolling
  - Character count shown (optional)
  - No arbitrary limit (reasonable limit if needed)

- **A4**: Note encryption (if enabled)
  - Note is encrypted before saving
  - Decrypted when viewing
  - Transparent to user

**Postconditions**:
- Note is saved and attached to ayah
- Note appears in Library/Notes
- Note indicator visible in reading view
- Note can be edited or deleted later

**Acceptance Criteria**:
- Note creation is smooth
- Auto-save works reliably
- Note persists across app restarts
- Note syncs when online (if enabled)
- Works offline

---

## Audio User Cases

### UC-AUD-01: Play Audio from Current Ayah

**Actor**: User (Listener persona)

**Preconditions**:
- User is in reading view
- Audio reciter is selected (default or user-selected)
- Network connection available OR audio is downloaded

**Main Flow**:
1. User taps on an ayah
2. App shows ayah actions sheet
3. User taps "Play Audio" option
4. App starts audio playback from that ayah
5. App shows audio controls (play/pause, next/prev, speed, etc.)
6. Audio plays in background (if user navigates away)
7. Lock screen shows audio controls
8. Reading view highlights current playing ayah (if auto-scroll enabled)

**Alternate Flows**:
- **A1**: Audio not downloaded, network unavailable
  - App shows error: "Audio not available offline. Download to listen offline."
  - Offers download option
  - User can download for offline use

- **A2**: Audio download in progress
  - App shows progress indicator
  - Queues playback for when download completes
  - Or allows streaming if network available

- **A3**: Audio playback interrupted (phone call)
  - Audio pauses automatically
  - After call ends, user can resume
  - App remembers position

- **A4**: User changes reciter mid-playback
  - App stops current playback
  - Starts new reciter from same ayah
  - Smooth transition

**Postconditions**:
- Audio is playing
- Audio controls are available
- Reading view syncs with audio (if enabled)
- Playback continues in background

**Acceptance Criteria**:
- Audio starts in < 2 seconds
- Background playback works
- Lock screen controls work
- Auto-scroll is smooth (if enabled)

---

### UC-AUD-02: Download Surah for Offline Listening

**Actor**: User (Listener persona)

**Preconditions**:
- User is in Audio section
- Reciter is selected
- Network connection available
- Sufficient storage space available

**Main Flow**:
1. User navigates to Audio → Reciter → Surah list
2. User selects a surah (e.g., Surah 36 - Ya-Sin)
3. User taps "Download" button
4. App shows download confirmation with size estimate
5. User confirms download
6. App enqueues download
7. App shows download progress (progress bar, percentage, speed)
8. Download completes
9. App marks surah as "Available Offline"
10. User can now play audio offline

**Alternate Flows**:
- **A1**: Network lost during download
  - App pauses download
  - Shows "Download paused - no network"
  - Automatically resumes when network returns
  - Or user can manually resume

- **A2**: User on cellular, setting disallows cellular downloads
  - App shows: "Large download detected. Use Wi-Fi?"
  - User can:
    - Wait for Wi-Fi (pause download)
    - Allow cellular (proceed)
    - Cancel download

- **A3**: Insufficient storage
  - App detects insufficient space
  - Shows error: "Insufficient storage. Free up space or remove old downloads."
  - Offers storage management screen
  - User can clean up and retry

- **A4**: Download fails
  - App shows error message
  - Offers retry option
  - Logs error for debugging
  - User can retry download

**Postconditions**:
- Surah is downloaded and available offline
- Download appears in download queue as "Completed"
- User can play audio offline
- Storage usage updated

**Acceptance Criteria**:
- Download progress is accurate
- Download resumes after interruption
- Storage check prevents failures
- Works on Wi-Fi and cellular (if allowed)

---

### UC-AUD-03: Manage Audio Playback (Speed, Repeat, Sleep Timer)

**Actor**: User (Listener persona)

**Preconditions**:
- Audio is playing
- User is in reading view or audio controls visible

**Main Flow**:
1. User taps audio controls to expand
2. User sees options:
   - Speed control (0.5x, 0.75x, 1.0x, 1.25x, 1.5x, 2.0x)
   - Repeat mode (None, Ayah, Surah, Range)
   - Sleep timer (5, 10, 15, 30, 60 min, Custom)
3. User adjusts speed to 1.5x
4. Audio playback speed changes immediately
5. User sets repeat to "Repeat Ayah"
6. Audio repeats current ayah when it ends
7. User sets sleep timer to 30 minutes
8. Audio stops after 30 minutes
9. App shows notification: "Sleep timer ended"

**Alternate Flows**:
- **A1**: User changes speed while audio is playing
  - Speed changes immediately
  - No interruption to playback
  - Speed preference saved

- **A2**: User sets repeat range
  - User selects "Repeat Range"
  - User picks start and end ayah
  - Audio repeats within that range
  - Exits repeat when range completes

- **A3**: User cancels sleep timer
  - User taps "Cancel Timer"
  - Timer is cancelled
  - Audio continues playing

- **A4**: Sleep timer ends
  - Audio fades out (optional) or stops
  - Notification shown
  - User can resume if desired

**Postconditions**:
- Audio playback settings are applied
- Settings are saved as preferences
- Audio continues playing with new settings
- Sleep timer is active (if set)

**Acceptance Criteria**:
- Speed changes are immediate and smooth
- Repeat works correctly
- Sleep timer is accurate
- Settings persist across sessions

---

## Azkar User Cases

### UC-AZ-01: Start Morning Azkar Session

**Actor**: User (Azkar User persona)

**Preconditions**:
- App is installed
- Azkar content is downloaded
- User is on Home or Azkar tab
- It is morning (or user manually starts)

**Main Flow**:
1. User taps "Morning Azkar" from Home or opens Azkar tab → Morning category
2. App displays morning azkar list
3. User sees first azkar item with:
   - Arabic text
   - Translation (if enabled)
   - Counter (0 / target count, e.g., 0 / 3)
4. User taps counter button
5. Counter increments (1 / 3)
6. User continues tapping until count reaches target (3 / 3)
7. If auto-advance enabled: App automatically moves to next item
8. If auto-advance disabled: User manually taps "Next"
9. Progress bar updates showing session progress
10. User continues through all items
11. On completion: App shows "Session Complete" summary

**Alternate Flows**:
- **A1**: Auto-advance enabled
  - When count reaches target, app automatically shows next item
  - Smooth transition
  - Progress updates

- **A2**: User locks screen mid-session
  - Session state is saved
  - On app resume, user can continue session
  - Progress is preserved

- **A3**: User wants to reset counter
  - User taps "Reset" button
  - Counter resets to 0
  - User can restart that item

- **A4**: User wants to skip item
  - User taps "Mark as Done" (if enabled)
  - Item is marked complete without full count
  - Moves to next item

**Postconditions**:
- Azkar session is in progress
- Progress is tracked
- Session state is saved
- User can continue or complete later

**Acceptance Criteria**:
- Counter increments instantly
- Auto-advance works smoothly
- Progress tracking is accurate
- Session state persists

---

### UC-AZ-02: Complete Morning Azkar Session with Auto-Advance

**Actor**: User (Azkar User persona)

**Preconditions**:
- Auto-advance is enabled in settings
- User is in morning azkar session
- User is on an azkar item

**Main Flow**:
1. Current item shows count target (e.g., 3 times)
2. User taps counter 3 times
3. Count reaches target (3 / 3)
4. App shows brief completion animation/feedback
5. App automatically advances to next item
6. Progress bar updates
7. User continues with next item
8. Process repeats for all items
9. On last item completion:
   - App shows "Session Complete" summary
   - Summary shows:
     - Total items completed
     - Time spent
     - Streak update (if applicable)
   - Options: "Reset Session" or "Done"

**Alternate Flows**:
- **A1**: User manually navigates
  - User can tap "Next" or "Previous" at any time
  - Auto-advance doesn't prevent manual navigation
  - Progress updates correctly

- **A2**: Session interrupted
  - User closes app or locks screen
  - Session state saved
  - On resume: "Continue session?" prompt
  - User can resume from where they left off

- **A3**: User changes repeat count
  - User overrides default count (e.g., 3 → 7)
  - App uses personal count
  - Auto-advance uses new target

**Postconditions**:
- Session is complete
- Progress is saved
- Streak is updated (if applicable)
- User can start new session or view history

**Acceptance Criteria**:
- Auto-advance is smooth and timely
- Progress tracking is accurate
- Session completion is clear
- Works offline

---

### UC-AZ-03: Set Azkar Reminder

**Actor**: User (Azkar User persona)

**Preconditions**:
- App is installed
- Notification permissions granted (or will be requested)
- User is in Settings or Azkar category

**Main Flow**:
1. User goes to Azkar → Morning category (or Settings → Reminders)
2. User taps "Set Reminder" button
3. App shows reminder creation screen:
   - Time picker (default: 6:00 AM)
   - Time window (default: 30 minutes)
   - Recurrence (daily, specific days)
   - Notification content (generic or snippet)
4. User sets time to 6:30 AM
5. User sets time window to 30 minutes
6. User enables reminder
7. App requests notification permission (if not granted)
8. App schedules local notification
9. App shows confirmation: "Reminder set for 6:30 AM daily"
10. Reminder appears in reminder list

**Alternate Flows**:
- **A1**: Notification permission denied
  - App shows: "Notifications disabled. Enable in Settings to receive reminders."
  - Provides "Open Settings" button
  - Reminder is saved but won't trigger until permission granted

- **A2**: User sets custom recurrence
  - User selects "Specific days"
  - User picks days (e.g., Monday, Wednesday, Friday)
  - Reminder scheduled for selected days only

- **A3**: User sets quiet hours
  - User has quiet hours configured (e.g., 10 PM - 6 AM)
  - If reminder time falls in quiet hours, app warns user
  - User can adjust time or allow during quiet hours

- **A4**: Timezone change
  - App detects timezone change
  - Automatically reschedules reminders
  - Shows notification: "Reminders adjusted for new timezone"

**Postconditions**:
- Reminder is scheduled
- Notification will trigger at set time
- Reminder appears in reminder list
- User can edit or delete reminder

**Acceptance Criteria**:
- Reminder is scheduled correctly
- Notification triggers at right time
- Timezone changes handled
- Quiet hours respected
- Works offline (local notifications)

---

### UC-AZ-04: Receive and Interact with Azkar Reminder

**Actor**: User (Azkar User persona)

**Preconditions**:
- Reminder is set and enabled
- Notification permission granted
- Reminder time has arrived

**Main Flow**:
1. Reminder notification appears on device
2. Notification shows:
   - Title: "Time for Morning Azkar" (or custom)
   - Body: Generic message or azkar snippet (if enabled)
   - Actions: "Open", "Snooze", "Mark Done" (if supported)
3. User taps "Open" action (or notification itself)
4. App opens to morning azkar category
5. User can start azkar session
6. If user taps "Snooze":
   - Notification is snoozed for selected duration (10/30/60 min)
   - Notification rescheduled
   - Snooze count incremented

**Alternate Flows**:
- **A1**: User taps "Mark Done" from notification
  - Azkar session is marked as started
  - Notification is dismissed
  - App may open to azkar category (optional)

- **A2**: User ignores notification
  - Notification remains in notification center
  - User can interact later
  - Reminder doesn't retrigger (one-time for that day)

- **A3**: User is in quiet hours
  - Notification is suppressed
  - Queued for after quiet hours (optional)
  - Or skipped for that day

- **A4**: Multiple reminders at same time
  - App groups notifications (if enabled)
  - Or shows separate notifications
  - User can interact with each

**Postconditions**:
- User is aware of reminder
- User can start azkar session
- Reminder interaction is logged (for analytics)
- Next reminder scheduled (if recurring)

**Acceptance Criteria**:
- Notification appears at correct time
- Notification actions work
- App opens to correct screen
- Snooze works correctly
- Works offline (local notifications)

---

## Settings User Cases

### UC-SET-01: Change Theme

**Actor**: User

**Preconditions**:
- App is installed
- User is in Settings

**Main Flow**:
1. User opens Settings → Appearance
2. User sees "Theme" option with current theme selected
3. User taps "Theme"
4. App shows theme options:
   - System (follows device)
   - Light
   - Dark
   - Sepia
   - Night Mode
5. User selects "Dark"
6. App immediately applies dark theme
7. All screens update to dark theme
8. Theme preference is saved
9. Theme persists across app restarts

**Alternate Flows**:
- **A1**: User selects "System"
  - App follows device theme
  - Changes when device theme changes
  - Respects system dark mode

- **A2**: User selects "Night Mode"
  - App applies extra dark theme
  - Optional: Red tint for eye comfort
  - Optimized for low-light reading

**Postconditions**:
- Theme is changed and applied
- Theme preference is saved
- All screens reflect new theme
- Theme persists

**Acceptance Criteria**:
- Theme changes immediately
- Theme persists across restarts
- All screens update correctly
- Works offline

---

### UC-SET-02: Adjust Font Size

**Actor**: User (Low-Vision User persona)

**Preconditions**:
- App is installed
- User is in Settings → Appearance

**Main Flow**:
1. User opens "Font Size" settings
2. User sees two sliders:
   - Arabic Font Size
   - Translation Font Size
3. User adjusts Arabic font size slider
4. App shows live preview of Arabic text
5. User adjusts translation font size slider
6. App shows live preview of translation text
7. User confirms settings
8. Font sizes are saved
9. Reading view updates with new font sizes

**Alternate Flows**:
- **A1**: User selects very large font
  - Layout adapts (scrollable content)
  - Controls remain accessible
  - Text doesn't truncate
  - Reader mode available (minimal UI)

- **A2**: User uses system font scaling
  - App respects system dynamic type
  - Font sizes scale with system setting
  - Layout adapts accordingly

**Postconditions**:
- Font sizes are updated
- Preferences are saved
- Reading view reflects new sizes
- Settings persist

**Acceptance Criteria**:
- Font size changes are immediate
- Preview is accurate
- Layout adapts correctly
- Works for all font sizes
- Persists across restarts

---

### UC-SET-03: Export User Data

**Actor**: User

**Preconditions**:
- App is installed
- User has some user data (bookmarks, notes, highlights)
- User is in Settings → Privacy

**Main Flow**:
1. User opens Settings → Privacy → Export Data
2. App shows export options:
   - Format: JSON, PDF, or Text
   - Include: Bookmarks, Notes, Highlights, Settings (checkboxes)
3. User selects format (e.g., JSON)
4. User selects what to include (all checked by default)
5. User taps "Export"
6. App generates export file
7. App shows share sheet (iOS) or file picker (Android)
8. User saves or shares file
9. Export file contains all selected data

**Alternate Flows**:
- **A1**: Large amount of data
  - Export may take time
  - App shows progress indicator
  - File generation happens in background

- **A2**: User cancels export
  - Export is cancelled
  - No file generated
  - Returns to settings

- **A3**: Export fails
  - App shows error message
  - Suggests retry
  - Logs error for debugging

**Postconditions**:
- Export file is generated
- User has copy of their data
- Data remains in app (export doesn't delete)
- File can be imported elsewhere (if format supports)

**Acceptance Criteria**:
- Export includes all selected data
- Export format is correct and readable
- Export works for large datasets
- Export is complete (no data omitted)

---

## Search User Cases

### UC-SEARCH-01: Search Arabic Text

**Actor**: User (Learner persona)

**Preconditions**:
- App is installed
- Search index is built
- User is on Search screen

**Main Flow**:
1. User opens Search screen
2. User selects "Arabic" search type
3. User types Arabic text in search box
4. App shows search results as user types (debounced 300ms)
5. Results show:
   - Surah name
   - Ayah number
   - Arabic text snippet with highlighted search term
6. User taps a result
7. App opens reading view at that ayah
8. Search term is highlighted in ayah text

**Alternate Flows**:
- **A1**: Diacritics-insensitive search
  - User has "Ignore diacritics" enabled
  - Search matches text with or without diacritics
  - More results returned

- **A2**: Normalization enabled
  - User has Arabic normalization enabled
  - Hamza variations normalized (أ, إ, آ)
  - Yaa variations normalized (ي, ى)
  - More flexible matching

- **A3**: No results
  - App shows "No results found"
  - Suggests: "Try different search terms" or "Check spelling"
  - User can modify query

**Postconditions**:
- Search results are displayed
- User can open result in reading view
- Search term is highlighted
- User can refine search

**Acceptance Criteria**:
- Search is fast (< 300ms for first results)
- Results are accurate
- Highlighting is clear
- Works offline
- Handles Arabic text correctly

---

## Sync User Cases

### UC-SYNC-01: Enable Cloud Sync

**Actor**: User

**Preconditions**:
- App is installed
- User has some local data (bookmarks, notes, etc.)
- User is in Settings → Privacy → Cloud Sync

**Main Flow**:
1. User opens Cloud Sync settings
2. User sees sync status: "Disabled"
3. User taps "Enable Sync"
4. App shows sign-in options:
   - Apple Sign-In (iOS)
   - Google Sign-In (Android)
   - Email link (optional)
5. User selects sign-in method (e.g., Apple Sign-In)
6. User completes authentication
7. App shows "Syncing..." indicator
8. App uploads local data to cloud
9. Sync completes
10. App shows "Synced" status with last sync time
11. User data is now synced across devices

**Alternate Flows**:
- **A1**: User cancels sign-in
  - Sync remains disabled
  - No data uploaded
  - Returns to settings

- **A2**: Sync fails during upload
  - App shows error message
  - Offers retry option
  - Local data remains intact
  - User can retry sync

- **A3**: User has data on multiple devices
  - App detects existing cloud data
  - Shows conflict resolution options
  - User can choose merge strategy
  - Data is merged and synced

**Postconditions**:
- Cloud sync is enabled
- Local data is synced to cloud
- Future changes will sync automatically
- User can access data on other devices

**Acceptance Criteria**:
- Sign-in works correctly
- Data uploads successfully
- Sync status is accurate
- Conflicts are resolved correctly
- Works reliably

---

### UC-SYNC-02: Sync Across Devices

**Actor**: User

**Preconditions**:
- Cloud sync is enabled on Device A
- User has bookmarks/notes on Device A
- User installs app on Device B
- User signs in with same account on Device B

**Main Flow**:
1. User opens app on Device B
2. User signs in with same account
3. App detects cloud data available
4. App shows "Syncing data..." indicator
5. App downloads data from cloud
6. App merges with local data (if any)
7. Sync completes
8. User's bookmarks/notes from Device A appear on Device B
9. User can now access data on both devices
10. Changes on either device sync to other device

**Alternate Flows**:
- **A1**: Conflicting edits
  - Same item edited on both devices
  - App uses "latest wins" strategy (default)
  - Or shows conflict resolution UI
  - User can choose which version to keep

- **A2**: Device B has local data
  - App merges cloud and local data
  - Duplicates are handled
  - All data preserved
  - User can review merged data

- **A3**: Large dataset
  - Sync may take time
  - App shows progress indicator
  - Sync happens in background
  - User can use app during sync

**Postconditions**:
- Data is synced across devices
- User can access data on both devices
- Future changes sync automatically
- Data is consistent (eventually)

**Acceptance Criteria**:
- Sync works reliably
- Data is complete on both devices
- Conflicts are resolved correctly
- Sync is fast for typical datasets
- Works in background

