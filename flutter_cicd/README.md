# flutter_cicd 🧱

> A Mason brick that generates production-ready GitHub Actions CI/CD workflows for Flutter projects.

[![Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

---

## What does it generate?

Running this brick creates two GitHub Actions workflow files in your project:

```
.github/
  workflows/
    build.yml   → Runs on push/PR: lint, test, build Android & iOS
    deploy.yml  → Runs after build: deploy to Firebase / Play Store / App Store
```

---

## Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Mason CLI](https://pub.dev/packages/mason_cli)

```bash
dart pub global activate mason_cli
```

---

## Step 1 — Initialize Mason in Your Project

Navigate to your Flutter project root and run:

```bash
mason init
```

> This creates a `mason.yaml` file in your project. You only need to do this once per project.

---

## Step 2 — Add the Brick

```bash
mason add flutter_cicd --git-url https://github.com/jayc2709/flutter_cicd_mason --git-path flutter_cicd
```

---

## Step 3 — Generate the Workflows

```bash
mason make flutter_cicd
```

You will be prompted with questions. Most have sensible defaults — just press **Enter** to accept them.

| Prompt | Default | Notes |
|---|---|---|
| App name | `my_app` | Your Flutter app name |
| Package name | `com.example.app` | Android package ID |
| Flutter channel | `stable` | `stable`, `beta`, or `master` |
| Flutter version | _(empty)_ | Leave empty to use channel latest |
| Run tests? | `yes` | Runs `flutter test` |
| Run analyze? | `yes` | Runs `flutter analyze` |
| Check formatting? | `no` | Runs `dart format --check` |
| Build branches | `main,develop` | Comma-separated |
| Deploy branches | `main` | Comma-separated |
| Trigger on PRs? | `yes` | |
| PR target branches | `main,develop` | Comma-separated |
| Platform | `both` | `android`, `ios`, or `both` |
| Build mode | `release` | `release`, `debug`, or `profile` |
| Android build type | `appbundle` | `apk`, `appbundle`, or `both` |
| Sign with keystore? | `yes` | Requires secrets (see below) |
| Keystore secret name | `KEYSTORE_BASE64` | |
| Auto build number? | `yes` | Uses `GITHUB_RUN_NUMBER` |
| Use flavors? | `no` | |
| Flavor list | `dev,prod` | Only asked if flavors enabled |
| iOS build method | `simulator` | `simulator`, `device_unsigned`, or `fastlane_placeholder` |
| Deploy target | `none` | `firebase`, `playstore`, `appstore`, or `none` |
| Firebase App ID secret | `FIREBASE_APP_ID` | Only if deploying to Firebase |
| Firebase Token secret | `FIREBASE_TOKEN` | Only if deploying to Firebase |
| Firebase tester groups | `testers` | Only if deploying to Firebase |
| Play Store track | `internal` | Only if deploying to Play Store |
| Slack notifications? | `no` | |
| Slack webhook secret | `SLACK_WEBHOOK_URL` | Only if Slack enabled |
| Create GitHub Release? | `no` | |

---

## Step 4 — Add GitHub Secrets

Go to your GitHub repository → **Settings → Secrets and variables → Actions → New repository secret**.

Add only the secrets relevant to your configuration:

### 🔑 Android Signing (if `use_keystore: yes`)

| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Your `.jks` keystore file encoded as Base64 |
| `KEY_ALIAS` | Key alias inside the keystore |
| `KEY_PASSWORD` | Password for the key |
| `STORE_PASSWORD` | Password for the keystore |

**Generate `KEYSTORE_BASE64`:**
```bash
# macOS
base64 -i android/app/upload-keystore.jks | pbcopy

# Linux
base64 android/app/upload-keystore.jks
```

---

### 🔥 Firebase App Distribution (if `deploy_target: firebase`)

| Secret | Description |
|---|---|
| `FIREBASE_APP_ID` | Found in Firebase Console → Project Settings → Your Apps |
| `FIREBASE_TOKEN` | Firebase CI token |

**Generate `FIREBASE_TOKEN`:**
```bash
firebase login:ci
```

---

### 🛒 Google Play Store (if `deploy_target: playstore`)

| Secret | Description |
|---|---|
| `PLAY_STORE_SERVICE_ACCOUNT` | Full JSON content of your Google Play Service Account |

> Create a service account in [Google Play Console](https://play.google.com/console) → Setup → API access.

---

### 💬 Slack (if `notify_slack: yes`)

| Secret | Description |
|---|---|
| `SLACK_WEBHOOK_URL` | Incoming Webhook URL from your Slack app |

---

## Step 5 — Commit & Push

```bash
git add .github/
git commit -m "chore: add CI/CD workflows"
git push
```

Your workflows will now run automatically on every push to the configured branches! 🚀

---

## Branch Strategy 🌿

| Workflow | Trigger |
|---|---|
| **build.yml** | Push to `build_branches` + PRs targeting `pr_target_branches` |
| **deploy.yml** | Push to `deploy_branches` (only after build succeeds) + manual dispatch |

---

## Customization 🛠️

The generated files are plain GitHub Actions YAML. You can edit `.github/workflows/build.yml` and `.github/workflows/deploy.yml` directly to add any custom steps.

---

## Troubleshooting

**Build fails with "keystore not found"**
→ Make sure `KEYSTORE_BASE64`, `KEY_ALIAS`, `KEY_PASSWORD`, and `STORE_PASSWORD` secrets are all set.

**Deploy workflow doesn't trigger**
→ The deploy workflow only runs after the **Build** workflow succeeds. Check the Build workflow logs first.

**iOS build fails**
→ iOS builds on `ubuntu-latest` are limited. Use `macos-latest` runner for device builds (edit the generated `build.yml`).

---

## License

MIT
