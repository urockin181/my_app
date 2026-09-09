import 'dart:async';
import 'dart:math' show pi, sin, cos;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

import '../../l10n/generated/app_localizations.dart';

enum _QiblaState { loading, notSupported, serviceDisabled, permissionDenied, ready }

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  _QiblaState _state = _QiblaState.loading;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void dispose() {
    FlutterQiblah().dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() => _state = _QiblaState.loading);

    final supported = await FlutterQiblah.androidDeviceSensorSupport();
    if (supported == false) {
      setState(() => _state = _QiblaState.notSupported);
      return;
    }

    var status = await FlutterQiblah.checkLocationStatus();
    if (!status.enabled) {
      setState(() => _state = _QiblaState.serviceDisabled);
      return;
    }
    if (status.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      status = await FlutterQiblah.checkLocationStatus();
    }
    if (status.status == LocationPermission.denied ||
        status.status == LocationPermission.deniedForever) {
      setState(() => _state = _QiblaState.permissionDenied);
      return;
    }

    setState(() => _state = _QiblaState.ready);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    switch (_state) {
      case _QiblaState.loading:
        return const Center(child: CircularProgressIndicator());
      case _QiblaState.notSupported:
        return _Message(icon: Icons.explore_off, text: l10n.qiblaNotSupported);
      case _QiblaState.serviceDisabled:
        return _Message(
          icon: Icons.location_off,
          text: l10n.prayerLocationServiceOff,
          actionLabel: l10n.prayerRefresh,
          onAction: _check,
        );
      case _QiblaState.permissionDenied:
        return _Message(
          icon: Icons.location_disabled,
          text: l10n.qiblaLocationRequired,
          actionLabel: l10n.prayerGrantPermission,
          onAction: _check,
        );
      case _QiblaState.ready:
        return const _QiblaCompass();
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

class _QiblaCompass extends StatelessWidget {
  const _QiblaCompass();

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
              child: StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final qiblah = snapshot.data!;
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
                              angle: qiblah.direction * (pi / 180) * -1,
                              child: _CompassDial(color: scheme.outlineVariant),
                            ),
                            Transform.rotate(
                              angle: qiblah.qiblah * (pi / 180) * -1,
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
                        l10n.qiblaDegrees(qiblah.qiblah.toStringAsFixed(0)),
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
