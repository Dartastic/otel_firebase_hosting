# otel_firebase_hosting

Dartastic OpenTelemetry bridge for Firebase Hosting (static + dynamic site hosting).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_firebase_hosting/otel_firebase_hosting.dart';

await tracedFirebaseHosting<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return FirebaseHostingCallResult(value: r, result: FirebaseHostingResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutFirebaseHostingInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
