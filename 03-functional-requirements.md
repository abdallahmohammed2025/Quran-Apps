# Functional Requirements

## FR-1: Onboarding & First Run

### User Cases

**UC-ON-01: First Launch Language Selection**
- User opens app for first time
- App displays language selection screen
- Options: Arabic, English, Urdu, French, etc.
- User selects language → app UI updates immediately
- Proceeds to next onboarding step

**UC-ON-02: Preference Setup (Optional)**
- After language selection, show preference screen
- Options (all skippable):
  - Quran script style (Uthmani / IndoPak)
  - Font size slider (preview)
  - Theme selection (Light/Dark/System)
- User can skip all → uses defaults
- User can configure → settings saved

**UC-ON-03: Offline Content Download**
- App prompts: "Download offline Quran text pack? (Recommended: Yes)"
- Options: "Download Now" / "Later" / "Skip"
- If "Download Now":
  - Show progress indicator
  - Download base Quran text + metadata
  - Continue to next step when complete
- If "Later" or "Skip":
  - App works with online content (if available)
  - User can download later from Settings

**UC-ON-04: Notification Permission**
- App asks: "Enable notifications for azkar reminders?"
- Options: "Enable" / "Ask Later"
- If "Enable": Request system permission
- If denied: Show message "You can enable reminders later in Settings"
- App continues regardless of permission status

### Edge Cases

**EC-ON-01: No Internet Connection**
- Onboarding must complete successfully
- Defer all downloads
- Show message: "Connect to internet to download content"
- App enters "online-only" mode until download completes

**EC-ON-02: User Denies Notifications**
- App continues normally
- Show status indicator in Settings: "Notifications disabled"
- Provide "Enable in Settings" button with deep link

**EC-ON-03: Download Failure**
- Show error message with retry option
- Allow user to proceed without download
- Queue download for retry when connection available

**EC-ON-04: App Reinstalled**
- Detect if user previously had app installed (via iCloud/Google backup)
- Offer to restore previous settings
- If declined, start fresh onboarding

### Acceptance Criteria
- Onboarding completes in < 30 seconds (excluding downloads)
- All steps are skippable
- App is usable immediately after onboarding
- Settings can be changed later

---

## FR-2: Home Screen (Daily Utility)

### Must Include

**Resume Reading**
- Display last-read surah name (Arabic + transliteration)
- Display ayah number or page number
- One-tap button to open reading view at last position
- If no last-read: Show "Start Reading" CTA

**Daily Highlight (Configurable)**
- Daily verse:
  - Random or curated verse
  - Arabic text
  - Translation (user's default)
  - Tap to open in reading view
- Daily azkar:
  - One azkar item from morning/evening category
  - Arabic text + translation
  - Quick counter (optional)
  - Tap to open full azkar category

**Quick Actions**
- "Go to Surah" - Opens surah picker
- "Search" - Opens search interface
- "Morning Azkar" - Opens morning azkar category
- "Evening Azkar" - Opens evening azkar category
- "Continue Audio" - Only shown if audio is playing/paused

**Recent Items**
- Recent bookmarks (last 5)
- Recently opened surahs (last 5)
- Tap any item → opens in reading view

### Edge Cases

**EC-HOME-01: No Last-Read Position**
- Show "Start Reading" button
- Opens surah list on tap

**EC-HOME-02: Offline Mode**
- Show cached daily items if available
- If no cache: Show placeholder "Connect to internet for daily content"
- Resume reading still works (uses local data)

**EC-HOME-03: Corrupted Last-Read Data**
- Detect invalid position
- Reset to surah 1, ayah 1
- Show message: "Reading position reset"

**EC-HOME-04: Very Long Surah Names**
- Truncate with ellipsis
- Show full name on long-press or tooltip

### Acceptance Criteria
- Home screen loads in < 500ms
- All quick actions respond immediately
- Resume reading opens in < 1 second
- Works fully offline after initial setup

---

## FR-3: Quran Browsing & Navigation

### Browse Modes

**By Surah List**
- Display all 114 surahs
- Each item shows:
  - Surah name (Arabic)
  - Transliteration
  - Meaning/Translation (optional)
  - Ayah count
  - Type: Meccan / Medinan
  - Icon/badge for special surahs (e.g., Al-Fatiha, Al-Ikhlas)
- Default sort: Mushaf order (1-114)
- Alternative sorts: Alphabetical, by type, by length
- Search/filter within list

**By Juz**
- Display 30 juzs
- Each juz shows:
  - Juz number
  - Starting surah and ayah
  - Ending surah and ayah
  - Page range
- Tap juz → show starting point → open reading view

**By Hizb / Rub**
- Display 60 hizbs or 240 rubs
- Similar structure to juz view
- Quick navigation for precise positioning

**By Page (Mushaf Pages)**
- Display page numbers (typically 604 pages)
- Grid or list view
- Tap page → open reading view at page start

### Use Cases

**UC-BROWSE-01: Open Surah**
- User taps surah from list
- App opens reading view at ayah 1
- OR opens at last position within surah (if "remember per-surah position" enabled)
- Reading view highlights surah header

**UC-BROWSE-02: Navigate by Juz**
- User selects Juz 15
- App shows: "Juz 15 starts at Surah 17, Ayah 1"
- User confirms → opens reading view
- Reading view shows juz marker/header

**UC-BROWSE-03: Jump to Specific Location**
- User taps "Jump to" button
- Options:
  - Surah + Ayah picker
  - Page number input
  - Juz/Hizb selector
- User selects → opens reading view at location

**UC-BROWSE-04: Search Within Browse**
- User types in search box (surah list view)
- Filters surahs by name (Arabic/transliteration)
- Results update in real-time

### Edge Cases

**EC-BROWSE-01: Invalid Page Number**
- User enters page number > max pages
- Show inline error: "Page number must be between 1 and [max]"
- Auto-clamp to valid range
- Highlight input field

**EC-BROWSE-02: Multiple Mushaf Layouts**
- If Uthmani vs IndoPak supported:
  - Page numbers differ between layouts
  - Show current layout indicator
  - Map page numbers correctly per layout
  - Warn user if switching layouts affects page numbers

**EC-BROWSE-03: Empty Search Results**
- Show message: "No surahs found"
- Provide "Clear search" button
- Show suggestions if typo detected (optional)

**EC-BROWSE-04: Offline Browse**
- All browse views work offline
- Use cached surah metadata
- If metadata missing: Show "Download content" prompt

### Acceptance Criteria
- Surah list loads in < 300ms
- Jump-to navigation opens in < 500ms
- All browse modes work offline
- Page number validation prevents errors

---

## FR-4: Quran Reading View (Core)

### Layout Options

**Ayah List Mode (Primary)**
- Scrollable list of ayahs
- Each ayah shows:
  - Ayah number
  - Arabic text (properly shaped)
  - Translation(s) (if enabled)
  - Optional: Transliteration
- Smooth scrolling
- Infinite scroll or pagination

**Mushaf Page Image Mode (Optional Advanced)**
- Display page as image
- Zoom and pan support
- Heavier storage requirement
- Alternative to text rendering

### Required Features

**Text Rendering**
- Arabic text with proper shaping (using system fonts or custom)
- Support for diacritics (tashkeel)
- RTL layout for Arabic
- LTR layout for translations
- Mixed RTL/LTR handling

**Translation Display**
- Toggle per translation (show/hide)
- Multiple translations can be shown simultaneously
- User-selectable translations from Settings
- Font size independent for Arabic vs translation

**Audio Synchronization (Optional)**
- Word highlighting during audio playback
- Auto-scroll to current ayah (toggleable)
- Visual indicator for playing ayah

**Layout Controls**
- Line spacing adjustment
- Font size controls (Arabic + translation separately)
- Theme: Light / Dark / Sepia / Night mode
- Full-screen reading mode (minimal UI)

### Tap Interactions

**Single Tap on Ayah**
- Opens ayah actions sheet/bottom sheet
- Actions available:
  - Bookmark
  - Add note
  - Highlight
  - Copy Arabic
  - Copy translation
  - Share
  - Play audio from this ayah
  - View tafsir
  - View reference (sajdah, etc.)

**Long Press on Ayah**
- Enter selection mode
- Allow multi-ayah selection
- Show selection toolbar:
  - Copy
  - Share
  - Highlight
  - Bookmark range
  - Add note

**Swipe Gestures (Optional)**
- Swipe left/right: Previous/Next page
- Swipe up: Scroll to top
- Swipe down: Scroll to bottom

### Navigation Inside Reading View

**Previous/Next Controls**
- Previous page/section button
- Next page/section button
- Or swipe gestures

**Scroll Position**
- Preserve scroll position when leaving view
- "Back to top" button (floating, appears after scrolling)
- Smooth scroll to top

**Last Read Tracking**
- Continuously update "last read" as user scrolls
- Persist last visible ayah (not just last tapped)
- Update timestamp
- Sync to cloud (if enabled)

### Edge Cases

**EC-READ-01: Very Large Font**
- Ensure layout doesn't overlap controls
- Enable "reader mode" with minimal UI
- Hide navigation when in reader mode
- Show controls on tap

**EC-READ-02: RTL/LTR Mixing**
- Arabic (RTL) + English translation (LTR)
- Proper text direction handling
- Correct alignment
- Proper line breaks

**EC-READ-03: Screen Rotation**
- Preserve reading position
- Recalculate layout
- Maintain scroll position (normalized)
- Smooth transition

**EC-READ-04: Long Surah (e.g., Al-Baqarah)**
- Efficient rendering (virtualization)
- Fast scroll performance
- Jump-to-ayah still works
- Progress indicator for long scrolls

**EC-READ-05: Missing Translation**
- Show placeholder: "Translation not available"
- Allow user to download/select different translation
- Don't break layout

**EC-READ-06: Audio Playback Interruption**
- Handle phone calls
- Handle other audio apps
- Resume gracefully
- Update UI state

### Acceptance Criteria
- Reading view opens in < 500ms from cache
- Smooth scrolling (60 FPS)
- Text rendering is accurate and properly shaped
- All interactions respond in < 100ms
- Works fully offline

---

## FR-5: Quran Search

### Search Types

**Arabic Search**
- Search within Arabic text
- Diacritics-insensitive option (ignore tashkeel)
- Normalization options:
  - Hamza variations (أ, إ, آ)
  - Yaa variations (ي, ى)
  - Taa marbuta (ة, ه)
- Fuzzy matching (optional)

**Translation Search**
- Search within selected translation(s)
- Multi-translation search (search all enabled translations)
- Language-specific search rules
- Phrase matching

**Surah Name Search**
- Search by Arabic name
- Search by transliteration
- Partial matching
- Auto-complete suggestions

### Advanced Filters

**Scope Filters**
- Restrict to specific surah(s)
- Restrict to specific juz(s)
- Restrict to specific page range
- Combine multiple filters

**Search Mode**
- Exact phrase match
- Partial match (contains)
- Starts with
- Ends with
- Word boundary matching

**Arabic Normalization**
- Toggle normalization rules
- Preserve diacritics vs ignore
- Handle different Arabic script styles

### Search Results

**Result Display**
- Group results by surah
- Show surah name + ayah number
- Display snippet with highlighted search term
- Show context (previous/next ayah, optional)
- Result count indicator

**Result Interaction**
- Tap result → opens reading view at ayah
- Highlight search term in reading view
- Scroll to result if needed
- "Clear highlight" option

**Result Management**
- Pagination or infinite scroll
- Sort options: Relevance, Surah order, Ayah order
- Export results (optional)

### Edge Cases

**EC-SEARCH-01: Offline Search**
- Must work using local index
- Pre-built search index included in content pack
- Fast local search performance
- No network dependency

**EC-SEARCH-02: Very Large Result Sets**
- Paginate results (e.g., 50 per page)
- Or infinite scroll with virtualization
- Show "X results found" message
- Allow user to refine search

**EC-SEARCH-03: Empty Results**
- Show helpful message: "No results found"
- Suggest:
  - Check spelling
  - Try different search terms
  - Remove filters
  - Try Arabic search if searching translation

**EC-SEARCH-04: Special Characters**
- Handle Arabic diacritics correctly
- Handle punctuation
- Handle numbers (Arabic vs Western)
- Escape special regex characters

**EC-SEARCH-05: Search Performance**
- Debounce input (300ms delay)
- Show loading indicator
- Cancel previous search if new query entered
- Cache recent searches

### Acceptance Criteria
- First results appear in < 300ms for common queries
- Search works fully offline
- Results are accurate and relevant
- Highlighting is clear and visible
- Handles edge cases gracefully

---

## FR-6: Bookmarks, Highlights, Notes

### Bookmarks

**Default Bookmarks**
- Last-read position (auto-bookmark)
- User-created bookmarks

**Bookmark Creation**
- From ayah actions → "Add Bookmark"
- Optional: Select folder/collection
- Optional: Add label
- Optional: Choose color
- Quick bookmark (no folder) → goes to default folder

**Bookmark Folders/Collections**
- Create custom folders (e.g., "Dua", "Study", "Ramadan")
- Organize bookmarks into folders
- Folder management:
  - Rename
  - Delete (with confirmation)
  - Reorder
  - Change color/icon

**Bookmark Management**
- View all bookmarks (Library screen)
- Filter by folder
- Search bookmarks
- Edit bookmark (change folder, label, color)
- Delete bookmark (with undo option)
- Sort: Date, Surah order, Custom

### Highlights

**Highlight Creation**
- From ayah actions → "Highlight"
- Choose color from palette (3-6 colors)
- Quick highlight (uses last color)
- Multi-ayah highlight (long-press selection)

**Highlight Management**
- View all highlights (Library screen)
- Filter by color
- Filter by surah
- Remove highlight
- Change highlight color

**Highlight Display**
- Show in reading view with background color
- Subtle but visible
- Don't interfere with text readability
- Toggle show/hide highlights (optional)

### Notes

**Note Creation**
- From ayah actions → "Add Note"
- Opens note editor
- Attach note to specific ayah
- Rich text support (optional) or plain text
- Auto-save draft

**Note Management**
- View all notes (Library screen)
- Edit note
- Delete note (with confirmation)
- Search notes (full-text search)
- Export notes (JSON/PDF/text)

**Note Display**
- Show note indicator in reading view
- Tap indicator → show note preview
- Full note view on tap
- Notes icon/badge on ayah

### Use Cases

**UC-LIB-01: Create Bookmark with Folder**
- User taps ayah → "Add Bookmark"
- Selects folder "Dua"
- Adds label "Powerful Dua"
- Bookmark saved
- Appears in Library under "Dua" folder

**UC-LIB-02: Export Notes**
- User goes to Library → Notes
- Taps "Export"
- Options: JSON, PDF, Text
- User selects format
- File generated and shared/saved

**UC-LIB-03: Organize Bookmarks**
- User goes to Library → Bookmarks
- Long-press bookmark → drag to folder
- Or tap edit → change folder
- Bookmarks reorganized

### Edge Cases

**EC-LIB-01: Deleting Translation Pack**
- User deletes translation pack
- Bookmarks/notes/highlights remain intact
- Only translation data removed
- Ayah references still valid

**EC-LIB-02: Content Pack Version Change**
- Content pack updated
- Ayah IDs must remain stable
- If ayah IDs change: Migration required
- Preserve user content during migration

**EC-LIB-03: Large Number of Bookmarks**
- Efficient rendering (virtualization)
- Fast search/filter
- Pagination if needed
- Don't impact app performance

**EC-LIB-04: Corrupted User Data**
- Detect corruption
- Attempt recovery
- If recovery fails: Offer to reset user data
- Backup/export before reset

**EC-LIB-05: Cloud Sync Conflicts**
- Multiple devices with conflicting edits
- Conflict resolution strategy:
  - Latest timestamp wins (default)
  - Or manual merge
  - Show conflict resolution UI

### Acceptance Criteria
- Bookmark creation is instant (< 100ms)
- All user content persists across app restarts
- Export functions work correctly
- Search/filter is fast (< 200ms)
- Works fully offline

---

## FR-7: Audio Recitation

### Core Playback

**Playback Controls**
- Play/Pause
- Next/Previous ayah
- Next/Previous surah
- Seek (if file format supports)
- Speed control (0.5x - 2.0x, increments of 0.25x)
- Repeat modes:
  - Repeat ayah
  - Repeat surah
  - Repeat range (ayah X to Y)
  - No repeat
- Sleep timer (5, 10, 15, 30, 60 minutes, or custom)

**Background Playback**
- Continue playing when app is backgrounded
- Lock screen controls
- Notification controls
- Control center / notification shade controls
- Headphone button controls (play/pause, skip)

**Media Notifications**
- Show current surah/ayah
- Show reciter name
- Show artwork (if available)
- Show progress bar
- Actions: Play/Pause, Next, Previous, Close

### Reciter Management

**Browse Reciters**
- List of available reciters
- Each reciter shows:
  - Name (Arabic + transliteration)
  - Style description
  - Bitrate options
  - Download status
  - Thumbnail/artwork
- Filter by style, language
- Search reciters

**Select Default Reciter**
- Set default from reciter list
- Or from playback screen
- Persist preference
- Use default for "Play from ayah" actions

### Downloads

**Download Options**
- Download by surah (individual surahs)
- Download by juz (entire juz)
- Download whole Quran (with size warning)
- Download by reciter (all surahs for reciter)

**Download Management**
- Download queue view
- Show progress for each item
- Pause/Resume downloads
- Cancel downloads
- Retry failed downloads
- Storage usage indicator

**Storage Management**
- View downloaded content by reciter
- View by surah/juz
- Clear downloads:
  - By reciter
  - By surah
  - All downloads
- Storage cleanup recommendations

### Sync with Reading

**Auto-Scroll (Toggleable)**
- When audio plays, reading view auto-scrolls to current ayah
- Smooth scrolling
- Highlight current ayah
- Pause auto-scroll if user manually scrolls

**Visual Indicators**
- Highlight currently playing ayah
- Show play icon on ayah
- Progress indicator (optional)
- Sync button to jump reading to audio position

### Edge Cases

**EC-AUDIO-01: Network Drop During Streaming**
- Detect network loss
- Retry with exponential backoff
- If local version available: Switch to local
- Show error message if no local version
- Queue for download when network returns

**EC-AUDIO-02: Audio URL Changes**
- Use versioned manifest for audio URLs
- Check manifest version on app start
- Update URLs if manifest changed
- Handle 404 errors gracefully
- Fallback to cached URLs if available

**EC-AUDIO-03: OS Kills Background Process**
- Save playback state
- Resume on app restart
- Restore position
- Continue from last ayah

**EC-AUDIO-04: Multiple Audio Sources**
- Handle switching between reciters
- Handle switching between online/offline
- Smooth transition
- Preserve playback state

**EC-AUDIO-05: Large Download Sizes**
- Warn user before downloading whole Quran
- Show estimated size
- Check available storage
- Allow pause/resume for large downloads
- Background download support

**EC-AUDIO-06: Audio Format Compatibility**
- Support common formats (MP3, M4A, OGG)
- Handle format errors gracefully
- Fallback to alternative format if available
- Show format info to user

### Acceptance Criteria
- Audio starts playing in < 2 seconds
- Background playback works reliably
- Downloads resume after interruption
- Auto-scroll is smooth and accurate
- Works offline for downloaded content

---

## FR-8: Azkar Library

### Categories

**Standard Categories (Examples)**
- Morning Azkar
- Evening Azkar
- After Prayer
- Sleep / Wake Up
- Travel
- Anxiety / Hardship
- Food / Home
- General Duas
- Protection
- Gratitude

**Category Structure**
- Each category contains multiple azkar items
- Categories can have subcategories (optional)
- Categories have time tags (morning/evening/etc.)
- Custom categories (optional, advanced)

### Azkar List View

**Item Display**
- Arabic text (prominent)
- Transliteration (optional, toggleable)
- Translation (optional, toggleable)
- Source/reference (e.g., "Sahih Bukhari, Book 1, Hadith 234")
- Repeat count requirement (e.g., "3 times", "7 times", "100 times")
- Virtues/benefits (optional, expandable)
- Counter display (current count / target)

**List Organization**
- Sort by order (default)
- Sort by name
- Filter by time tag
- Search within category

### Azkar Item Interaction

**Counter Functionality**
- Tap counter button → increments count
- Visual feedback (animation, color change)
- Show remaining count (target - current)
- Haptic feedback (toggleable)
- Vibration on completion (optional)

**Auto-Advance (Toggleable)**
- When count reaches target → automatically move to next item
- Show brief completion message
- Smooth transition
- Update progress bar

**Manual Controls**
- "Reset" button → reset count to 0
- "Mark as Done" → complete item without full count (optional)
- "Previous" / "Next" buttons
- Jump to specific item

**Additional Actions**
- Bookmark/favorite item
- Share item (text/image)
- Copy Arabic text
- Copy translation
- View full reference
- Add note (optional)

### Session Behavior

**Session Progress**
- Track progress for time-based sessions (morning/evening)
- Show:
  - Percent complete
  - Items completed / total items
  - Time spent
  - Estimated time remaining
- Progress bar visualization

**Streaks (Optional)**
- Track consecutive days of completion
- Show streak counter
- Streak milestones (7 days, 30 days, etc.)
- Streak recovery (grace period)

**Resume Session**
- Save session state
- Resume later if interrupted
- Show "Continue session" option
- Clear session on completion

**Session Completion**
- Show completion summary:
  - Total items completed
  - Time spent
  - Streak update
- "Reset" button to start new session
- "Share progress" option (optional)

### Edge Cases

**EC-AZKAR-01: User Changes Repeat Count**
- Allow "personal override" of repeat count
- Preserve original count
- Show both: "Original: 3, Your: 7"
- Option to reset to original

**EC-AZKAR-02: Accessibility - Large Text**
- Support dynamic type scaling
- Large counter buttons
- Simple, clear UI
- High contrast mode support

**EC-AZKAR-03: Session Interruption**
- App closed mid-session
- Save state automatically
- Resume on next open
- Show "Continue session?" prompt

**EC-AZKAR-04: Multiple Sessions**
- Morning and evening sessions separate
- Track both independently
- Don't mix progress
- Clear separation in UI

**EC-AZKAR-05: Offline Mode**
- All azkar content available offline
- Counters work offline
- Progress saved locally
- Sync when online (if cloud sync enabled)

**EC-AZKAR-06: Very Long Azkar Text**
- Scrollable text area
- Proper text wrapping
- Readable font size
- Don't break layout

### Acceptance Criteria
- Azkar list loads in < 300ms
- Counter increments instantly
- Auto-advance works smoothly
- Progress tracking is accurate
- Works fully offline
- Accessible for low-vision users

---

## FR-9: Azkar Reminders & Notifications

### Reminder Types

**Morning Azkar**
- Time window (e.g., 6:00 AM - 7:00 AM)
- Daily recurrence
- Configurable time range

**Evening Azkar**
- Time window (e.g., 6:00 PM - 7:00 PM)
- Daily recurrence
- Configurable time range

**Prayer-Based Reminders (Optional Advanced)**
- Trigger after specific prayer (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Offset time (e.g., "30 minutes after Maghrib")
- Requires prayer times integration

**Custom Reminders**
- User selects category or specific azkar item
- User sets time
- User sets recurrence (daily, specific days, etc.)

**Periodic Reminders**
- Every X hours (e.g., every 3 hours)
- Configurable interval
- Start/end times

### Requirements

**Local Notifications**
- Work offline (no server dependency)
- Scheduled locally on device
- Reliable delivery
- Respect system Do Not Disturb settings

**Editable Schedule**
- View all reminders
- Edit reminder (time, recurrence, content)
- Enable/disable reminder
- Delete reminder
- Bulk actions (optional)

**Notification Content Options**
- Generic: "Time for evening azkar"
- Snippet: Show short azkar text (privacy setting)
- Custom message (user-defined)

**Notification Actions**
- "Mark Done" (if OS supports)
- "Snooze" (10/30/60 minutes)
- "Open App" (default)
- Custom actions (optional)

### Use Cases

**UC-REM-01: Create Morning Reminder**
- User goes to Azkar → Morning category
- Taps "Set Reminder"
- Selects time: 6:00 AM
- Selects time window: 30 minutes
- Enables reminder
- Notification scheduled

**UC-REM-02: Snooze Reminder**
- Notification appears
- User taps "Snooze 30 min"
- Notification rescheduled
- Reminder count incremented
- Max snoozes enforced (if set)

**UC-REM-03: Mark Done from Notification**
- Notification appears
- User taps "Mark Done"
- Azkar session marked as started
- Notification dismissed
- App opens to azkar category (optional)

**UC-REM-04: Edit Reminder Schedule**
- User goes to Settings → Reminders
- Taps reminder
- Changes time to 6:30 AM
- Saves changes
- Notification rescheduled

### Edge Cases

**EC-REM-01: Timezone Change**
- Detect timezone change
- Reschedule all reminders with new timezone
- Preserve local time (e.g., 6:00 AM stays 6:00 AM local)
- Show notification: "Reminders adjusted for timezone"

**EC-REM-02: Daylight Saving Time**
- Handle DST transitions
- Adjust reminder times if needed
- Or preserve absolute time (user preference)
- Test both spring forward and fall back

**EC-REM-03: User Disabled Notifications**
- Detect system-level notification denial
- Show status in Settings: "Notifications disabled"
- Provide "Enable in Settings" button with deep link
- App functionality unaffected

**EC-REM-04: Multiple Reminders at Same Time**
- Handle overlapping reminders
- Show combined notification or separate
- User preference: "Group notifications"
- Don't spam user

**EC-REM-05: Quiet Hours**
- Respect quiet hours setting
- Don't send notifications during quiet hours
- Queue notifications (optional) or skip
- Show in notification history

**EC-REM-06: App Uninstalled/Reinstalled**
- Reminders lost on uninstall
- On reinstall: Prompt to restore reminders
- Or start fresh (user choice)

**EC-REM-07: Device Reboot**
- Reminders must persist after reboot
- Reschedule on app launch
- Verify scheduled reminders after reboot
- Handle missed reminders (show on next open)

### Acceptance Criteria
- Reminders are reliable (99%+ delivery rate)
- Timezone changes handled correctly
- Quiet hours respected
- Notification actions work correctly
- Works fully offline
- No battery drain from scheduling

---

## FR-10: Prayer Times (Optional)

**Note**: Prayer times is a large scope item. If included, it becomes a significant module. This section outlines basic requirements if you choose to include it.

### Features

**Location-Based Calculation**
- Automatic location detection (with permission)
- Manual city selection (fallback)
- Multiple calculation methods (e.g., MWL, ISNA, Egypt, etc.)
- Madhab selection for Asr calculation (Hanafi vs standard)

**Prayer Time Notifications**
- Notifications for each prayer
- Configurable offset (e.g., "10 minutes before")
- Athan sound (where allowed by platform)
- Custom notification sounds

**Qibla Direction**
- Compass-based Qibla finder
- Calibration guidance
- Visual indicator
- Accuracy indicator

### Edge Cases

**EC-PRAYER-01: Location Permission Denied**
- Fallback to manual city selection
- Show message: "Enable location for automatic times"
- Provide city search/picker

**EC-PRAYER-02: Offline Mode**
- Use cached last-known location
- Use cached calculation method
- Show cached times with "Last updated" timestamp
- Update when online

**EC-PRAYER-03: Invalid Location**
- Detect invalid coordinates
- Fallback to default location
- Show error message
- Allow manual override

### Recommendation

**Treat prayer times as separate module** if you want to keep initial scope manageable. It can be added in a future release.

---

## FR-11: Settings

### Appearance

**Theme**
- System (follows device)
- Light
- Dark
- Sepia
- Night mode (extra dark, red tint option)

**Font Settings**
- Arabic font size (slider with preview)
- Translation font size (separate slider)
- Font family selection (if multiple available)
- Line spacing adjustment

**Quran Display**
- Script type (Uthmani / IndoPak)
- Show ayah numbers (toggle)
- Show surah headers (toggle)
- Show page markers (toggle)
- Show juz/hizb markers (toggle)

**Reading Experience**
- Keep screen on (toggle)
- Auto-scroll speed (if enabled)
- Tap to scroll (toggle)
- Reading direction (RTL/LTR for translations)

### Content

**Translations**
- Default translation selection (multi-select)
- Download/remove translations
- Translation display order
- Show translation source (toggle)

**Tafsir (if supported)**
- Tafsir source selection
- Download/remove tafsir
- Display preferences

**Reciter**
- Default reciter selection
- Reciter preferences (bitrate, etc.)

**Offline Packs**
- View installed packs
- Download packs
- Remove packs
- Storage usage
- Update packs

### Azkar

**Display Options**
- Show transliteration (toggle)
- Show translation (toggle)
- Show source/reference (toggle)
- Show virtues (toggle)

**Behavior**
- Auto-advance (toggle)
- Haptic feedback (toggle)
- Vibration on completion (toggle)
- Reset counters daily (toggle)

### Notifications

**Reminder Management**
- View all reminders
- Create/edit/delete reminders
- Enable/disable reminders
- Notification sound selection
- Quiet hours (start/end time)

**Permission Status**
- Notification permission status
- "Enable in Settings" button (if denied)

### Privacy

**Analytics**
- Analytics opt-in/out
- Clear explanation of what's collected
- Privacy policy link

**Crash Reports**
- Crash reports opt-in/out
- Clear explanation

**Data Management**
- Export data (bookmarks, notes, highlights, settings)
- Delete local data (with confirmation)
- Clear cache
- Reset app (nuclear option)

**Cloud Sync (if enabled)**
- Enable/disable sync
- Sync status
- Last sync time
- Sync account (if signed in)
- Sign out option

### General

**Language**
- App UI language selection
- Content language preferences

**About**
- App version
- Content pack versions
- Credits/attributions
- Privacy policy link
- Terms of service link
- Contact/support

**Advanced (Optional)**
- Debug mode (logs, etc.)
- Experimental features
- Developer options

### Edge Cases

**EC-SETTINGS-01: Invalid Font Size**
- Validate font size range
- Clamp to valid range
- Show preview
- Reset to default if corrupted

**EC-SETTINGS-02: Storage Full**
- Check available storage before downloads
- Warn user
- Offer cleanup options
- Prevent download if insufficient space

**EC-SETTINGS-03: Settings Sync Conflicts**
- Handle conflicts in cloud sync
- Latest wins (default)
- Or manual resolution
- Show conflict indicator

### Acceptance Criteria
- All settings apply immediately
- Settings persist across app restarts
- Export/import works correctly
- Settings UI is clear and organized
- Works offline (except sync-related)

---

## FR-12: Cloud Sync (Optional but Recommended)

### Sync Items

**User Content**
- Bookmarks (with folders)
- Notes
- Highlights
- Last-read position
- Azkar progress/streaks
- User preferences (optional)

**Download Lists**
- List of downloaded content (not actual files)
- Download queue state
- Resume downloads on other devices

**Not Synced**
- Actual audio files (too large)
- Content packs (handled separately)
- Cache files

### Authentication

**Anonymous Mode (Default)**
- No sign-in required
- Local-only data
- Can enable sync later

**Sign-In Options**
- Apple Sign-In (iOS)
- Google Sign-In (Android)
- Email link login (optional)
- Guest mode (temporary sync)

**Account Management**
- View account info
- Sign out
- Delete account (with data deletion)
- Switch accounts

### Conflict Resolution

**Settings**
- Latest timestamp wins
- Simple merge strategy
- Rare conflicts expected

**User Content (Notes/Highlights)**
- Merge by unique IDs
- If same item edited on both devices:
  - Latest timestamp wins (default)
  - Or show conflict resolution UI
- Preserve all unique items

**Bookmark Folders**
- Merge by folder ID
- If name conflicts: Append "(2)", "(3)", etc.
- Preserve folder structure

**Last-Read Position**
- Use most recent position
- Or device preference (e.g., "prefer this device")

### Edge Cases

**EC-SYNC-01: Offline Edits**
- Queue edits when offline
- Sync when online
- Show sync status indicator
- Handle sync failures gracefully

**EC-SYNC-02: User Logs Out**
- Ask: "Keep local data or delete?"
- If keep: Data remains but unsynced
- If delete: Wipe all user content
- Clear sync tokens

**EC-SYNC-03: Sync Failure**
- Retry with exponential backoff
- Show error message
- Allow manual retry
- Don't block app usage

**EC-SYNC-04: Large Data Sets**
- Efficient sync (delta updates)
- Compression if needed
- Progress indicator for large syncs
- Background sync

**EC-SYNC-05: Account Deletion**
- Delete all cloud data
- Option to export before deletion
- Confirm deletion (destructive action)
- Clear local sync state

### Acceptance Criteria
- Sync works reliably (99%+ success rate)
- Conflicts resolved correctly
- Offline edits synced when online
- Fast sync (< 5 seconds for typical data)
- Secure authentication
- Privacy-compliant

---

## FR-13: Admin/Content Management

### Content Versioning

**Pack Types**
- Quran text pack
- Translation packs (per language/translator)
- Tafsir packs (per source)
- Azkar pack
- Audio manifest
- Reciter metadata

**Version Management**
- Semantic versioning (e.g., "1.2.3")
- Version history
- Rollback capability
- Staged rollout (percentage-based)

### Remote Config

**Feature Flags**
- Enable/disable features remotely
- A/B testing support
- Gradual feature rollout
- Emergency kill switch

**Announcements**
- Banner messages
- In-app notifications
- Dismissible/expirable
- Targeted by app version

**Daily Content Rotation**
- Daily verse selection
- Daily azkar selection
- Curated content updates
- Scheduled updates

### Content Integrity

**Checksums**
- SHA-256 checksums for all packs
- Verify on download
- Verify on app start (optional)
- Reject corrupted packs

**Signatures (Optional)**
- Cryptographic signatures
- Verify publisher identity
- Prevent tampering
- Enhanced security

### Operational Requirements

**CDN Hosting**
- Fast global distribution
- Versioned URLs
- Cache headers
- Bandwidth optimization

**Rollback Strategy**
- Pin to previous pack version
- Emergency rollback procedure
- Version compatibility matrix
- Migration path documentation

**Staged Rollout**
- 5% → 25% → 50% → 100%
- Monitor error rates
- Automatic pause on errors
- Manual override

**Monitoring**
- Download success rates
- Checksum verification rates
- Version adoption
- Error tracking

### Admin Tools (Recommended)

**Web Dashboard (Optional)**
- View version status
- Push new versions
- Monitor adoption
- View analytics

**API (Optional)**
- Programmatic version management
- Integration with CI/CD
- Automated testing
- Content validation

### Edge Cases

**EC-ADMIN-01: Corrupted Pack**
- Detect corruption on download
- Reject pack, keep previous version
- Retry download
- Alert admin if persistent

**EC-ADMIN-02: Incompatible Version**
- Check version compatibility
- Block update if incompatible
- Show message to user
- Provide migration path

**EC-ADMIN-03: Rollback Required**
- Emergency rollback procedure
- Update remote config
- Force app to previous version
- Monitor for issues

### Acceptance Criteria
- Version updates are reliable
- Rollback works within minutes
- Content integrity verified
- Staged rollout prevents widespread issues
- Admin tools are usable and secure

