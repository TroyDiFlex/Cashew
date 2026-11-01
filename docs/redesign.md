# Charcoal and coral UI

The visual refresh uses `#080808` for the dark background and `#fb7185`
as the default accent. Dark controls and chart lines preserve the selected
accent instead of generating a pastel replacement. Account, category and
budget colors remain part of their existing data.

New installations start with the dark theme, coral accent and the already
bundled Inter font. Existing saved preferences are not rewritten.

The change covers the shared theme, buttons, bottom navigation, budget and
chart containers, line charts, progress bars and popup surfaces. Financial
calculations, database schema, migrations, cloud configuration, imports,
exports and purchase access are outside this change.

## Independent commits

Motion timings and animation lifecycle fixes are committed before the
visual refresh. The visual commit can be reverted while keeping the motion
changes. `lib/motion.dart` has no dependency on `lib/visuals.dart`.

Main transition timings, in milliseconds:

| Component | Before | After |
| --- | ---: | ---: |
| Chart updates | 2000 | 280 |
| Bottom navigation | 1000 | 160 |
| Container navigation on Android | 400 | 220 |
| Expanding sections | 425 | 220 |
| CountNumber default | 1000 | 360 |
| CountUp default | 3000 | 520 |

These are durations found in the code, not measured frame-time gains.
Device profiling has not been performed. Battery saver, the application's
animation settings and the system's reduced-motion preference are respected
by the changed transitions.

## Preview and validation status

`preview/cashew-charcoal-coral.html` is an interactive design proposal with
fictional data. It is not a screenshot of a compiled Android build. Its demo
transactions remain in page memory; presentation preferences may be passed
to the conversation host. It makes no network requests and reads no app data.

The proposal includes navigation, chart filters, accounts, detail sheets,
demo transaction entry, and motion/glow switches. The preview can be adjusted
before the native UI is built and checked.

Dart formatting and preview interaction checks have run. Android compilation,
Flutter runtime tests and phone performance measurements are deliberately
postponed until the design is reviewed.

The downloaded SDKs live in the sibling `Cashew-tools` directory. No installer
was run and no system PATH was changed. Tool invocations use configuration,
cache and temporary directories inside that folder. Delete the folder to
remove the downloaded tools; the source repository remains separate.
