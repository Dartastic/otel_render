// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_render/otel_render.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_render-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('services.create records type + plan + region', () async {
    await tracedRender<String>(
      operation: 'services.create',
      invoke: () async => const RenderCallResult(
        value: 'ok',
        result: RenderResult(
          serviceName: 'web',
          serviceType: 'web_service',
          serviceStatus: 'live',
          region: 'oregon',
          runtime: 'node',
          plan: 'standard',
          autoscaling: 'enabled',
          instances: 2,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('render services.create')!);
    expect(a['render.service.type'], 'web_service');
    expect(a['render.region'], 'oregon');
    expect(a['render.instances'], 2);
  });

  test('build_failed deploy sets span error', () async {
    await tracedRender<String>(
      operation: 'deploys.create',
      invoke: () async => const RenderCallResult(
        value: 'ok',
        result: RenderResult(
          deployId: 'dep_1',
          deployStatus: 'build_failed',
          deployTrigger: 'github_push',
        ),
      ),
    );
    expect(
      spans.findSpanByName('render deploys.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('postgres records engine + plan', () async {
    await tracedRender<String>(
      operation: 'postgres.create',
      invoke: () async => const RenderCallResult(
        value: 'ok',
        result: RenderResult(
          databaseEngine: 'postgres',
          databasePlan: 'standard',
          databaseStatus: 'available',
          diskSizeGb: 50,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('render postgres.create')!);
    expect(a['render.database.engine'], 'postgres');
    expect(a['render.disk.size_gb'], 50);
  });

  test('suppression skips spans', () async {
    await runWithoutRenderInstrumentationAsync(() async {
      await tracedRender<String>(
        operation: 'services.list',
        invoke: () async => const RenderCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('render '), isEmpty);
  });
}
