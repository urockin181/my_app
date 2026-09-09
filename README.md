# Muslim Guide (دليل المسلم)

A Flutter app centered on a Quran/Hadith-grounded chatbot, with prayer
times, Qibla direction, and morning/evening Athkar. Supports Arabic and
English with full RTL support.

## Features

- **Chat** (home screen): ask a question in Arabic or English. The app
  searches the Quran and Hadith for relevant text, then asks Gemini to
  compose an answer using only that retrieved text - never from the
  model's own general knowledge. If nothing relevant is found, it says so
  instead of guessing. Hadith answers include the source's authenticity
  grade (Sahih/Hasan/Da'if) when available.
- **Prayer Times**: calculated on-device from your GPS location (no
  network call, no API key).
- **Qibla**: a compass pointing toward the Kaaba, using your location and
  the device's magnetometer.
- **Athkar**: morning and evening remembrance lists with tap-to-count
  repetition counters.

## Why nothing religious is hardcoded

No Quran verse, Hadith, or Athkar text is written into this app's source
code. Every word shown to the user is fetched live from a real source at
request time (see `lib/services/`). This is deliberate: it means the app
can never serve fabricated scripture, even if a bug exists elsewhere - the
worst case of a wrong API detail is an empty/error result, not incorrect
"religious" text.

## One-time setup

### 1. Install Flutter

If you haven't already: https://docs.flutter.dev/get-started/install

### 2. Get a free Gemini API key (powers the chatbot's language understanding)

1. Go to https://aistudio.google.com/apikey
2. Sign in with a Google account and click "Create API key" - it's free,
   no credit card required for the free tier.
3. Copy the key.

### 3. Get a free Hadith API key (powers Hadith search + grading)

1. Go to https://hadithapi.com/register and create a free account.
2. Copy your API key from the dashboard.

If you skip this step, the chatbot still works using only the Quran as a
source - Hadith search is simply skipped.

### 4. Run the app with your keys

Keys are never committed to source control - they're passed in at
run/build time:

```bash
flutter pub get

flutter run \
  --dart-define=GEMINI_API_KEY=your_gemini_key \
  --dart-define=HADITH_API_KEY=your_hadithapi_key
```

To build a release APK with the keys baked in:

```bash
flutter build apk --release \
  --dart-define=GEMINI_API_KEY=your_gemini_key \
  --dart-define=HADITH_API_KEY=your_hadithapi_key
```

### 5. Set the same keys in Codemagic for cloud/iOS builds

In your Codemagic app settings, add `GEMINI_API_KEY` and `HADITH_API_KEY`
as environment variables (mark them "Secure"), then reference them in
`codemagic.yaml`'s build step as:

```yaml
scripts:
  - name: Build iOS
    script: |
      flutter build ipa \
        --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
        --dart-define=HADITH_API_KEY=$HADITH_API_KEY
```

## Architecture

```
lib/
  main.dart                 - entry point
  app.dart                  - MaterialApp, theme, localization wiring
  config/api_keys.dart      - reads --dart-define API keys
  state/locale_controller.dart - persisted Arabic/English language choice
  theme/app_theme.dart      - shared light/dark theme
  l10n/                     - app_en.arb / app_ar.arb + generated classes
  models/                   - plain data classes
  services/
    quran_service.dart      - api.alquran.cloud (free, no key)
    hadith_service.dart     - hadithapi.com (free, requires key)
    gemini_service.dart     - orchestrates retrieval + Gemini answer
    prayer_times_service.dart - local calculation via adhan_dart
    location_service.dart   - shared location-permission flow
    athkar_service.dart     - hisnmuslim.com Athkar text
  screens/                  - one folder per tab (chat, prayer_times,
                               qibla, athkar) plus the home_shell that
                               hosts the bottom navigation
```

## Notes on third-party APIs

`hadithapi.com` and `hisnmuslim.com` are free public sources whose exact
response shape can change over time. Both services are called
defensively in this app (see the comments at the top of
`hadith_service.dart` and `athkar_service.dart`) - if either stops
returning results, check that service's current API docs and adjust the
field names read there.
