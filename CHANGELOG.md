# Changelog

## [0.1.0-beta.3-wip]

## [0.1.0-beta.2] - 2026-06-10

## [0.1.0-beta.1] - 2026-06-04

### Added

- Initial release.
- `tracedFirebaseHosting<T>(...)` — wraps a otel_firebase_hosting call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutFirebaseHostingInstrumentation()` / `Async()`.
