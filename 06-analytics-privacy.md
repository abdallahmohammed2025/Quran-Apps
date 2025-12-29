# Analytics & Privacy

## Analytics Events

### App Lifecycle Events

**app_open**
- **Trigger**: App launches (cold or warm start)
- **Data**:
  - Timestamp
  - App version
  - Platform (iOS/Android)
  - OS version
  - Device type
  - Previous session duration (if available)
- **Purpose**: Track app usage, session starts

**app_background**
- **Trigger**: App goes to background
- **Data**:
  - Session duration
  - Last active screen
- **Purpose**: Track session length

**app_foreground**
- **Trigger**: App returns to foreground
- **Data**:
  - Time in background
- **Purpose**: Track app resume behavior

### Quran Reading Events

**resume_reading_tap**
- **Trigger**: User taps "Resume Reading" on home screen
- **Data**:
  - Last read surah number
  - Last read ayah number
- **Purpose**: Track resume reading usage

**surah_open**
- **Trigger**: User opens a surah in reading view
- **Data**:
  - Surah number
  - Entry point (browse, search, bookmark, etc.)
- **Purpose**: Track popular surahs, navigation patterns

**ayah_tap**
- **Trigger**: User taps an ayah (opens actions)
- **Data**:
  - Surah number
  - Ayah number
  - Action taken (bookmark, note, highlight, etc.)
- **Purpose**: Track user interactions

**bookmark_created**
- **Trigger**: User creates a bookmark
- **Data**:
  - Surah number
  - Ayah number
  - Folder ID (if any)
- **Purpose**: Track bookmark usage

**note_created**
- **Trigger**: User creates a note
- **Data**:
  - Surah number
  - Ayah number
  - Note length (characters, not content)
- **Purpose**: Track note-taking usage

**highlight_created**
- **Trigger**: User creates a highlight
- **Data**:
  - Surah number
  - Ayah number
  - Color used
- **Purpose**: Track highlighting usage

### Search Events

**search_query**
- **Trigger**: User performs a search
- **Data**:
  - Query length (characters)
  - Query hash (optional, for privacy)
  - Search type (Arabic, translation, surah name)
  - Result count
  - Filters used
- **Purpose**: Track search usage, popular queries (anonymized)
- **Privacy**: Never log full query text, only length/hash

**search_result_tap**
- **Trigger**: User taps a search result
- **Data**:
  - Result position
  - Surah number
  - Ayah number
- **Purpose**: Track search effectiveness

### Audio Events

**audio_play_start**
- **Trigger**: Audio playback starts
- **Data**:
  - Reciter ID
  - Starting surah number
  - Starting ayah number
  - Source (online/offline)
- **Purpose**: Track audio usage

**audio_play_stop**
- **Trigger**: Audio playback stops
- **Data**:
  - Duration played
  - Reason (user stopped, completed, error)
- **Purpose**: Track listening patterns

**reciter_selected**
- **Trigger**: User selects a reciter
- **Data**:
  - Reciter ID
  - Context (default, temporary)
- **Purpose**: Track popular reciters

**audio_download_start**
- **Trigger**: User starts downloading audio
- **Data**:
  - Reciter ID
  - Download type (surah, juz, full)
  - Size estimate
- **Purpose**: Track download behavior

**audio_download_complete**
- **Trigger**: Audio download completes
- **Data**:
  - Reciter ID
  - Download type
  - Actual size
  - Duration
- **Purpose**: Track download success

### Azkar Events

**azkar_session_start**
- **Trigger**: User starts an azkar session
- **Data**:
  - Category ID
  - Time of day (morning/evening)
- **Purpose**: Track azkar usage

**azkar_session_complete**
- **Trigger**: User completes an azkar session
- **Data**:
  - Category ID
  - Items completed
  - Total items
  - Duration
  - Streak (if applicable)
- **Purpose**: Track completion rates, engagement

**azkar_counter_increment**
- **Trigger**: User increments azkar counter
- **Data**:
  - Azkar ID
  - Current count
  - Target count
- **Purpose**: Track counter usage (aggregated, not per-user)

**reminder_created**
- **Trigger**: User creates a reminder
- **Data**:
  - Reminder type
  - Time (hour only, not exact time for privacy)
- **Purpose**: Track reminder usage

**reminder_triggered**
- **Trigger**: Reminder notification is sent
- **Data**:
  - Reminder type
  - Time of day
- **Purpose**: Track reminder delivery

**reminder_snoozed**
- **Trigger**: User snoozes a reminder
- **Data**:
  - Reminder type
  - Snooze duration
- **Purpose**: Track reminder interaction

### Settings Events

**theme_changed**
- **Trigger**: User changes theme
- **Data**:
  - New theme
- **Purpose**: Track theme preferences

**font_size_changed**
- **Trigger**: User changes font size
- **Data**:
  - Font type (Arabic/translation)
  - New size
- **Purpose**: Track accessibility usage

**translation_selected**
- **Trigger**: User selects a translation
- **Data**:
  - Translator ID
  - Language code
- **Purpose**: Track translation preferences

### Error Events

**crash**
- **Trigger**: App crashes
- **Data**:
  - Crash report (stack trace, etc.)
  - App version
  - OS version
  - Device type
  - Last user action (if available)
- **Purpose**: Track crashes, fix bugs
- **Privacy**: No user content in crash reports

**anr** (Android)
- **Trigger**: App Not Responding detected
- **Data**:
  - Duration
  - Last known state
- **Purpose**: Track performance issues

**error**
- **Trigger**: Non-fatal error occurs
- **Data**:
  - Error type
  - Error message (sanitized)
  - Context (screen, action)
- **Purpose**: Track errors, improve reliability

## Privacy Requirements

### Data Collection Principles

**Minimal Collection**
- Collect only necessary data
- No personal identification without consent
- Anonymize where possible
- Aggregate sensitive data

**User Consent**
- Clear opt-in for analytics
- Explain what data is collected
- Explain how data is used
- Easy opt-out mechanism

**Data Retention**
- Retain data only as long as necessary
- Automatic deletion of old data
- User can request data deletion

### Privacy Controls

**Analytics Opt-In/Out**
- **Location**: Settings → Privacy → Analytics
- **Default**: Opt-in (or opt-out, depending on policy)
- **Implementation**:
  - Clear explanation of what's collected
  - Toggle to enable/disable
  - Immediate effect (no restart required)
  - Respects user choice

**Crash Reports Opt-In/Out**
- **Location**: Settings → Privacy → Crash Reports
- **Default**: Opt-in (helps improve app)
- **Implementation**:
  - Separate from analytics
  - Clear explanation
  - Toggle to enable/disable

**Data Export**
- **Location**: Settings → Privacy → Export Data
- **Functionality**:
  - Export all user data (bookmarks, notes, highlights, settings)
  - Format: JSON or PDF
  - Share or save file
  - Complete export (no data omitted)

**Data Deletion**
- **Location**: Settings → Privacy → Delete Data
- **Functionality**:
  - Delete local data (with confirmation)
  - Delete cloud data (if sync enabled, with confirmation)
  - Clear all user content
  - Cannot be undone (clear warning)

### Data Never Collected

**Sensitive Content**
- Full note text (only length)
- Full search queries (only length/hash)
- Personal information (name, email, unless user signs in)
- Location (unless user explicitly enables for prayer times)
- Device identifiers (unless necessary for functionality)

**User Content**
- Never log full ayah text from user actions
- Never log user notes
- Never log bookmarks content
- Never log highlights content

### GDPR Compliance

**Right to Access**
- User can export their data
- Clear data export functionality
- Complete data export

**Right to Erasure**
- User can delete their data
- Clear deletion functionality
- Deletion from all systems (local + cloud)

**Right to Portability**
- Data export in machine-readable format (JSON)
- Easy to import into other systems

**Right to Object**
- User can opt-out of analytics
- User can opt-out of crash reports
- Respects user choices immediately

**Consent Management**
- Clear consent screens
- Granular consent (analytics, crash reports, etc.)
- Easy to withdraw consent
- Consent history (optional)

### Privacy Policy Requirements

**Must Include**
- What data is collected
- How data is used
- Who data is shared with (if anyone)
- Data retention policies
- User rights (access, deletion, etc.)
- Contact information for privacy concerns
- How to opt-out

**Accessibility**
- Privacy policy accessible from app
- Link in app settings
- Link in app store listings
- Clear, understandable language

## Analytics Implementation

### Analytics Service

**Recommended Services**
- Firebase Analytics (Google)
- Mixpanel
- Amplitude
- Custom analytics (self-hosted)

**Requirements**
- Privacy-compliant
- Configurable (can disable)
- Efficient (minimal battery/data usage)
- Reliable (offline queue, retry)

### Event Tracking

**Implementation**
- Event tracking library/module
- Queue events when offline
- Batch send events
- Respect opt-out setting

**Event Validation**
- Validate event structure
- Sanitize event data
- Remove sensitive information
- Test event tracking

### Analytics Dashboard

**Metrics to Track**
- Daily/Monthly active users
- Session duration
- Feature adoption
- Crash rate
- Error rate
- User retention (1-day, 7-day, 30-day)

**Reports**
- Regular reports (weekly/monthly)
- Alert on anomalies (high crash rate, etc.)
- User feedback integration

## Security

### Data Transmission

**Encryption**
- All analytics data transmitted over HTTPS
- Encrypted payloads (if sensitive)
- Certificate pinning (optional)

**Data Storage**
- Encrypted storage (if stored)
- Secure transmission
- No plaintext sensitive data

### Access Control

**Analytics Access**
- Limited access to analytics data
- Role-based access control
- Audit logs for access
- Regular access reviews

## Testing

### Privacy Testing

**Test Cases**
- Verify opt-out works
- Verify no data sent when opted out
- Verify data export is complete
- Verify data deletion works
- Verify no sensitive data in logs

### Analytics Testing

**Test Cases**
- Verify events are tracked correctly
- Verify events respect opt-out
- Verify offline queue works
- Verify event batching
- Verify no sensitive data in events

## Compliance

### Regional Requirements

**GDPR (Europe)**
- Full compliance required
- Consent management
- Data export/deletion
- Privacy policy

**CCPA (California)**
- Similar to GDPR
- Right to know
- Right to delete
- Opt-out mechanisms

**Other Regions**
- Research local requirements
- Adapt privacy controls as needed
- Legal review recommended

### App Store Requirements

**iOS App Store**
- Privacy policy URL required
- App Tracking Transparency (ATT) if using tracking IDs
- Privacy nutrition labels
- Data collection disclosure

**Google Play Store**
- Privacy policy URL required
- Data safety form
- Permissions justification
- Data collection disclosure

