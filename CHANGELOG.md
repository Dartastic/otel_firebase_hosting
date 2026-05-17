# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedFirebaseHosting<T>(...)` — wraps a otel_firebase_hosting call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutFirebaseHostingInstrumentation()` / `Async()`.
