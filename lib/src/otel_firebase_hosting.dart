// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_firebase_hosting_suppression.dart';

class FirebaseHostingResult {
  const FirebaseHostingResult({
    this.projectId,
    this.siteId,
    this.versionId,
    this.releaseId,
    this.channelId,
    this.fileCount,
    this.totalBytes,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? projectId;
  final String? siteId;
  final String? versionId;
  final String? releaseId;
  final String? channelId;
  final int? fileCount;
  final int? totalBytes;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class FirebaseHostingCallResult<T> {
  const FirebaseHostingCallResult({required this.value, this.result});
  final T value;
  final FirebaseHostingResult? result;
}

Future<T> tracedFirebaseHosting<T>({
  required String operation,
  required Future<FirebaseHostingCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (firebaseHostingInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_firebase_hosting');
  final span = t.startSpan('fbhosting $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'firebase')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.projectId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('gcp.project.id', res.projectId!)]));
      }
      if (res.siteId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('firebase.hosting.site.id', res.siteId!)]));
      }
      if (res.versionId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firebase.hosting.version.id', res.versionId!)
        ]));
      }
      if (res.releaseId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firebase.hosting.release.id', res.releaseId!)
        ]));
      }
      if (res.channelId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('firebase.hosting.channel.id', res.channelId!)
        ]));
      }
      if (res.fileCount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('firebase.hosting.file_count', res.fileCount!)
        ]));
      }
      if (res.totalBytes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('firebase.hosting.total_bytes', res.totalBytes!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fbhosting.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'fbhosting.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
