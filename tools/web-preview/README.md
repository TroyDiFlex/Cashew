# Local preview of Cashew

This launches the existing Flutter application, including its original navigation,
transaction editor, account controls and budget screens. It does not replace
those pages with an HTML mockup. `index.html` only supplies a narrow frame around
the compiled application.

The separate entry point is `budget/lib/preview_main.dart`. It uses the original
sample-data generator, an in-memory Drift database, and in-memory preferences.
Refreshing the page recreates the sample data. Normal Android startup in
`budget/lib/main.dart`, database code and cloud configuration are unchanged.

The preview skips Firebase initialization and startup sync. The local server's
Content Security Policy blocks external connections and scripts. Cloud access
and native-only integrations are unavailable in this local preview.

The preview enables existing home-screen sections corresponding to the supplied
screenshots: account list, income/expense summary and category chart. They remain
customizable with Cashew's existing home-screen settings.

Build dependencies remain locked to `budget/pubspec.lock`. The portable SDKs and
dependency caches live in the sibling `Cashew-tools` folder.

Build from `budget` through the portable runner:

```powershell
python ..\..\Cashew-tools\run.py flutter --suppress-analytics build web --release --no-pub --target lib/preview_main.dart --web-renderer html --pwa-strategy none --no-web-resources-cdn --base-href /app/ --output C:\path-without-cyrillic\cashew-preview
```

Flutter 3.19's shader tool requires an ASCII output path on this Windows setup.
Copy the generated files into `Cashew-tools/web-preview/app` afterwards and
remove only the generated temporary build directory. The server replaces only
the generated `app/index.html` with the local-only bootstrap.

Start or restart the local server from the repository:

```powershell
python tools/web-preview/serve.py --port 8765
```

Open `http://127.0.0.1:8765/` on the same computer. The server listens only on
loopback and serves only generated preview files. It does not serve repository
source or read the user's installed Cashew data.

Validation: web release build succeeded; the main script, SQL WebAssembly,
asset manifest, fonts and Russian translations are checked over HTTP. This
does not establish Android frame-rate performance. No Android APK was built.
