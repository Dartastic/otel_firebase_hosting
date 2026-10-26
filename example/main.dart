// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_firebase_hosting/otel_firebase_hosting.dart';

/// Traces Firebase Hosting calls with OpenTelemetry.
///
/// `otel_firebase_hosting` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Firebase Hosting call in
/// [tracedFirebaseHosting]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'firebase-hosting-example');

  // Traces a Firebase Hosting call.
  final firebaseHostingId = await tracedFirebaseHosting<String>(
    operation: 'create',
    invoke: () async {
      // Make the Firebase Hosting call here, then report what it returned.
      const id = 'firebase_hosting_8f3a2c';
      return const FirebaseHostingCallResult(
          value: id,
          result: FirebaseHostingResult(
              projectId: 'project_8f3a2c',
              siteId: 'site_8f3a2c',
              versionId: 'version_8f3a2c',
              releaseId: 'release_8f3a2c',
              channelId: 'channel_8f3a2c',
              fileCount: 3,
              totalBytes: 512,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedFirebaseHosting create returned $firebaseHostingId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutFirebaseHostingInstrumentationAsync.
  await runWithoutFirebaseHostingInstrumentationAsync(
    () => tracedFirebaseHosting<String>(
      operation: 'create',
      invoke: () async {
        const id = 'firebase_hosting_8f3a2c';
        return const FirebaseHostingCallResult(
            value: id,
            result: FirebaseHostingResult(
                projectId: 'project_8f3a2c',
                siteId: 'site_8f3a2c',
                versionId: 'version_8f3a2c',
                releaseId: 'release_8f3a2c',
                channelId: 'channel_8f3a2c',
                fileCount: 3,
                totalBytes: 512,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
