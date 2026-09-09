import 'dart:async';
import 'dart:math' show pi, sin, cos;

import 'package:adhan_dart/adhan_dart.dart' show Coordinates, Qibla;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/location_service.dart';

enum _QiblaState { loading, serviceDisabled, permissionDenied, error, ready }

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _locationService = LocationService();

  _QiblaState _state = _QiblaState.loading;
  double? _qiblaBearing;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = _QiblaState.loading);
    try {
      final result = await _locationService.getCurrentLocation();
      switch (result.outcome) {
        case LocationOutcome.serviceDisabled:
          setState(() => _state = _QiblaState.serviceDisabled);
          return;
        case LocationOutcome.permissionDenied:
          setState(() => _state = _QiblaState.permissionDenied);
          return;
        case LocationOutcome.granted:
          final position = result.position!;
          final bearing = Qibla.qibla(Coordinates(position.latitude, position.longitude));
          setState(() {
            _qiblaBearing = bearing;
            _state = _QiblaState.ready;
          });
      }
    } catch (_) {
      setState(() => _state = _QiblaState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    switch (_state) {
      case _QiblaState.loading:
        return const Center(child: CircularProgressIndicator());
      case _QiblaState.serviceDisabled:
        return _Message(
          icon: Icons.location_off,
          text: l10n.prayerLocationServiceOff,
          actionLabel: l10n.prayerRefresh,
          onAction: _load,
        );
      case _QiblaState.permissionDenied:
        return _Message(
          icon: Icons.location_disabled,
          text: l10n.qiblaLocationRequired,
          actionLabel: l10n.prayerGrantPermission,
          onAction: _load,
        );
      case _QiblaState.error:
        return _Message(
          icon: Icons.error_outline,
          text: l10n.chatErrorGeneric,
          actionLabel: l10n.prayerRefresh,
          onAction: _load,
        );
      case _QiblaState.ready:
        return _QiblaCompass(qiblaBearing: _qiblaBearing!);
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.actionLabel, this.onAction});

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _QiblaCompass extends StatefulWidget {
  const _QiblaCompass({required this.qiblaBearing});

  /// Fixed compass bearing (degrees from true north) from the user's
  /// location to the Kaaba - computed once from GPS, doesn't change as the
  /// phone rotates.
  final double qiblaBearing;

  @override
  State<_QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<_QiblaCompass> {
  late Stream<CompassEvent> _stream = _createStream();

  Stream<CompassEvent> _createStream() {
    final events = FlutterCompass.events ?? const Stream.empty();
    return events.timeout(
      const Duration(seconds: 10),
      onTimeout: (sink) => sink.addError(TimeoutException('No compass data received')),
    );
  }

  void _retry() {
    setState(() => _stream = _createStream());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(l10n.qiblaInstructions, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            l10n.qiblaCalibrate,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Expanded(
            child: Center(
              child: StreamBuilder<CompassEvent>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _Message(
                      icon: Icons.explore_off,
                      text: l10n.qiblaNotSupported,
                      actionLabel: l10n.prayerRefresh,
                      onAction: _retry,
                    );
                  }
                  final heading = snapshot.data?.heading;
                  if (heading == null) {
                    return const CircularProgressIndicator();
                  }

                  // Same combination formula used by mainstream Qibla-compass
                  // implementations: the needle's on-screen angle needs both
                  // the device's live heading and the fixed bearing to Mecca.
                  final qiblahAngle = heading + (360 - widget.qiblaBearing);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: heading * (pi / 180) * -1,
                              child: _CompassDial(color: scheme.outlineVariant),
                            ),
                            Transform.rotate(
                              angle: qiblahAngle * (pi / 180) * -1,
                              child: Icon(
                                Icons.navigation,
                                size: 96,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.qiblaDegrees(widget.qiblaBearing.toStringAsFixed(0)),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassDial extends StatelessWidget {
  const _CompassDial({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(260, 260),
      painter: _DialPainter(color: color),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 2, paint);

    const labels = ['N', 'E', 'S', 'W'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < 4; i++) {
      final angle = (i * 90) * (pi / 180);
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      final offset = Offset(
        center.dx + (radius - 18) * sin(angle) - textPainter.width / 2,
        center.dy - (radius - 18) * cos(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) => oldDelegate.color != color;
}
