// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_render_suppression.dart';

class RenderResult {
  /// Creates a result.
  const RenderResult({
    this.ownerId,
    this.serviceId,
    this.serviceName,
    this.serviceType,
    this.serviceStatus,
    this.region,
    this.runtime,
    this.plan,
    this.autoscaling,
    this.instances,
    this.deployId,
    this.deployStatus,
    this.deployTrigger,
    this.gitProvider,
    this.gitBranch,
    this.gitCommit,
    this.buildDurationMs,
    this.databaseEngine,
    this.databasePlan,
    this.databaseStatus,
    this.diskSizeGb,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? ownerId;
  final String? serviceId;
  final String? serviceName;
  final String? serviceType;
  final String? serviceStatus;
  final String? region;
  final String? runtime;
  final String? plan;
  final String? autoscaling;
  final int? instances;
  final String? deployId;
  final String? deployStatus;
  final String? deployTrigger;
  final String? gitProvider;
  final String? gitBranch;
  final String? gitCommit;
  final int? buildDurationMs;
  final String? databaseEngine;
  final String? databasePlan;
  final String? databaseStatus;
  final int? diskSizeGb;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class RenderCallResult<T> {
  /// Creates a call result.
  const RenderCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final RenderResult? result;
}

Future<T> tracedRender<T>({
  required String operation,
  required Future<RenderCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (renderInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_render');
  final span = t.startSpan('render $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'render')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.ownerId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.owner.id', res.ownerId!)]));
      }
      if (res.serviceId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.service.id', res.serviceId!)]));
      }
      if (res.serviceName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.service.name', res.serviceName!)
        ]));
      }
      if (res.serviceType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.service.type', res.serviceType!)
        ]));
      }
      if (res.serviceStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.service.status', res.serviceStatus!)
        ]));
      }
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.region', res.region!)]));
      }
      if (res.runtime != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.runtime', res.runtime!)]));
      }
      if (res.plan != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.plan', res.plan!)]));
      }
      if (res.autoscaling != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.autoscaling', res.autoscaling!)]));
      }
      if (res.instances != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('render.instances', res.instances!)]));
      }
      if (res.deployId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.deploy.id', res.deployId!)]));
      }
      if (res.deployStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.deploy.status', res.deployStatus!)
        ]));
      }
      if (res.deployTrigger != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.deploy.trigger', res.deployTrigger!)
        ]));
      }
      if (res.gitProvider != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.git.provider', res.gitProvider!)
        ]));
      }
      if (res.gitBranch != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.git.branch', res.gitBranch!)]));
      }
      if (res.gitCommit != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.git.commit', res.gitCommit!)]));
      }
      if (res.buildDurationMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('render.build.duration_ms', res.buildDurationMs!)
        ]));
      }
      if (res.databaseEngine != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.database.engine', res.databaseEngine!)
        ]));
      }
      if (res.databasePlan != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.database.plan', res.databasePlan!)
        ]));
      }
      if (res.databaseStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('render.database.status', res.databaseStatus!)
        ]));
      }
      if (res.diskSizeGb != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('render.disk.size_gb', res.diskSizeGb!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('render.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.deployStatus == 'build_failed' ||
          res.deployStatus == 'update_failed' ||
          res.deployStatus == 'canceled' ||
          res.deployStatus == 'deactivated';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'render.error')
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
