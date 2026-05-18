// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_render_suppression.dart';

class RenderResult {
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

class RenderCallResult<T> {
  const RenderCallResult({required this.value, this.result});
  final T value;
  final RenderResult? result;
}

Future<T> tracedRender<T>({
  required String operation,
  required Future<RenderCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (renderInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_render');
  final span = t.startSpan('render $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'render');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.ownerId != null) {
        span.setStringAttribute('render.owner.id', res.ownerId!);
      }
      if (res.serviceId != null) {
        span.setStringAttribute('render.service.id', res.serviceId!);
      }
      if (res.serviceName != null) {
        span.setStringAttribute('render.service.name', res.serviceName!);
      }
      if (res.serviceType != null) {
        span.setStringAttribute('render.service.type', res.serviceType!);
      }
      if (res.serviceStatus != null) {
        span.setStringAttribute('render.service.status', res.serviceStatus!);
      }
      if (res.region != null) {
        span.setStringAttribute('render.region', res.region!);
      }
      if (res.runtime != null) {
        span.setStringAttribute('render.runtime', res.runtime!);
      }
      if (res.plan != null) {
        span.setStringAttribute('render.plan', res.plan!);
      }
      if (res.autoscaling != null) {
        span.setStringAttribute('render.autoscaling', res.autoscaling!);
      }
      if (res.instances != null) {
        span.setIntAttribute('render.instances', res.instances!);
      }
      if (res.deployId != null) {
        span.setStringAttribute('render.deploy.id', res.deployId!);
      }
      if (res.deployStatus != null) {
        span.setStringAttribute('render.deploy.status', res.deployStatus!);
      }
      if (res.deployTrigger != null) {
        span.setStringAttribute('render.deploy.trigger', res.deployTrigger!);
      }
      if (res.gitProvider != null) {
        span.setStringAttribute('render.git.provider', res.gitProvider!);
      }
      if (res.gitBranch != null) {
        span.setStringAttribute('render.git.branch', res.gitBranch!);
      }
      if (res.gitCommit != null) {
        span.setStringAttribute('render.git.commit', res.gitCommit!);
      }
      if (res.buildDurationMs != null) {
        span.setIntAttribute('render.build.duration_ms', res.buildDurationMs!);
      }
      if (res.databaseEngine != null) {
        span.setStringAttribute('render.database.engine', res.databaseEngine!);
      }
      if (res.databasePlan != null) {
        span.setStringAttribute('render.database.plan', res.databasePlan!);
      }
      if (res.databaseStatus != null) {
        span.setStringAttribute('render.database.status', res.databaseStatus!);
      }
      if (res.diskSizeGb != null) {
        span.setIntAttribute('render.disk.size_gb', res.diskSizeGb!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('render.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.deployStatus == 'build_failed' ||
          res.deployStatus == 'update_failed' ||
          res.deployStatus == 'canceled' ||
          res.deployStatus == 'deactivated';
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'render.error');
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
