// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_render/otel_render.dart';

/// Traces Render calls with OpenTelemetry.
///
/// `otel_render` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Render call in
/// [tracedRender]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'render-example');

  // Traces a Render call.
  final renderId = await tracedRender<String>(
    operation: 'create',
    invoke: () async {
      // Make the Render call here, then report what it returned.
      const id = 'render_8f3a2c';
      return const RenderCallResult(
          value: id,
          result: RenderResult(
              ownerId: 'owner_8f3a2c',
              serviceId: 'service_8f3a2c',
              serviceName: 'example',
              serviceType: 'standard',
              serviceStatus: 'succeeded',
              region: 'us-east-1',
              runtime: 'example',
              plan: 'example',
              autoscaling: 'example',
              instances: 1,
              deployId: 'deploy_8f3a2c',
              deployStatus: 'succeeded',
              deployTrigger: 'example',
              gitProvider: 'example',
              gitBranch: 'example',
              gitCommit: 'example',
              buildDurationMs: 120,
              databaseEngine: 'example',
              databasePlan: 'example',
              databaseStatus: 'succeeded',
              diskSizeGb: 512,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedRender create returned $renderId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutRenderInstrumentationAsync.
  await runWithoutRenderInstrumentationAsync(
    () => tracedRender<String>(
      operation: 'create',
      invoke: () async {
        const id = 'render_8f3a2c';
        return const RenderCallResult(
            value: id,
            result: RenderResult(
                ownerId: 'owner_8f3a2c',
                serviceId: 'service_8f3a2c',
                serviceName: 'example',
                serviceType: 'standard',
                serviceStatus: 'succeeded',
                region: 'us-east-1',
                runtime: 'example',
                plan: 'example',
                autoscaling: 'example',
                instances: 1,
                deployId: 'deploy_8f3a2c',
                deployStatus: 'succeeded',
                deployTrigger: 'example',
                gitProvider: 'example',
                gitBranch: 'example',
                gitCommit: 'example',
                buildDurationMs: 120,
                databaseEngine: 'example',
                databasePlan: 'example',
                databaseStatus: 'succeeded',
                diskSizeGb: 512,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
