// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:otel_firebase_hosting/otel_firebase_hosting.dart';
import 'package:test/test.dart';

void main() {
  group('otel_firebase_hosting', () {
    test('suppression toggles in zone', () async {
      expect(firebaseHostingInstrumentationSuppressed(), isFalse);
      await runWithoutFirebaseHostingInstrumentationAsync(() async {
        expect(firebaseHostingInstrumentationSuppressed(), isTrue);
      });
      expect(firebaseHostingInstrumentationSuppressed(), isFalse);
    });

    test('FirebaseHostingResult fields default null', () {
      const r = FirebaseHostingResult();
      expect(r.statusCode, isNull);
    });
  });
}
