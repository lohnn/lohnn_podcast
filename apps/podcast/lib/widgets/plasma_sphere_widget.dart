import 'dart:math' as math;
import 'dart:ui' show lerpDouble; // For interpolation

import 'package:flutter/material.dart';
// import 'package:fast_noise/fast_noise.dart'; // Import if using fast_noise

// Data class to hold particle state
class Particle {
  double theta; // Angle around Y axis (0 to 2*pi)
  double phi; // Angle from Y axis (0 to pi)
  double originalRadius;
  double pointSize;

  // Calculated values per frame
  late double x;
  late double y;
  late double z;
  late double projectedX;
  late double projectedY;
  late double scale; // For perspective

  Particle(this.theta, this.phi, this.originalRadius, this.pointSize);
}

class ParticleSphereWidget extends StatefulWidget {
  final double size;
  final int particleCount;
  final Color particleColor;
  final double baseRadius;
  final double noiseFrequency;
  final double noiseAmplitude;
  final double rotationSpeed;
  final double animationSpeed;
  final double pointSize;

  const ParticleSphereWidget({
    super.key,
    this.size = 300.0,
    this.particleCount = 3000, // More particles = denser look
    this.particleColor = const Color(
      0xFF80D8FF,
    ), // Light blue, similar to video
    this.baseRadius = 100.0,
    this.noiseFrequency = 3.0, // How detailed the noise is
    this.noiseAmplitude = 15.0, // How much deformation
    this.rotationSpeed = 0.2, // Radians per second
    this.animationSpeed = 0.5, // Speed of noise evolution
    this.pointSize = 1.2,
  });

  @override
  _ParticleSphereWidgetState createState() => _ParticleSphereWidgetState();
}

class _ParticleSphereWidgetState extends State<ParticleSphereWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  final math.Random _random = math.Random();

  // Optional: Noise generator if using fast_noise
  // late NoiseGenerator _noise;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 10,
      ), // Loop duration doesn't matter much here
    )..repeat();

    // Initialize noise generator (if using fast_noise)
    // _noise = PerlinNoise(seed: _random.nextInt(1000), frequency: widget.noiseFrequency / 1000);

    // Initialize particles
    _createParticles();
  }

  static const randomPercentageAmount = 0.1;

  void _createParticles() {
    _particles.clear();
    final goldenRatio = (1 + math.sqrt(5)) / 2;
    final angleIncrement = math.pi * 2 * goldenRatio;

    for (var i = 0; i < widget.particleCount; i++) {
      // Use Fibonacci sphere (Sunflower) distribution for more even points
      final t = i / widget.particleCount;
      final inclination = math.acos(1 - 2 * t); // phi
      final azimuth = angleIncrement * i; // theta

      // Randomize radius +/-% for more organic look
      final randomFactor =
          1 + (_random.nextDouble() - 0.5) * randomPercentageAmount;
      final randomSize = widget.pointSize * randomFactor;

      _particles.add(
        Particle(azimuth, inclination, widget.baseRadius, randomSize),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ParticleSphereWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.particleCount != widget.particleCount ||
        oldWidget.baseRadius != widget.baseRadius) {
      // Recreate particles if count or radius changes
      _createParticles();
    }
    // Could also update noise parameters here if needed
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Use elapsed time for continuous animation
          final time = _controller.lastElapsedDuration!.inMilliseconds;
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: ParticleSpherePainter(
              particles: _particles,
              deltaTime: time / 1000,
              // Time in seconds
              particleColor: widget.particleColor,
              noiseFrequency: widget.noiseFrequency,
              noiseAmplitude: widget.noiseAmplitude,
              rotationSpeed: widget.rotationSpeed,
              animationSpeed: widget.animationSpeed,
              // noiseGenerator: _noise, // Pass if using fast_noise
            ),
          );
        },
      ),
    );
  }
}

class ParticleSpherePainter extends CustomPainter {
  final List<Particle> particles;
  final double deltaTime; // Current animation time in seconds
  final Color particleColor;
  final double noiseFrequency;
  final double noiseAmplitude;
  final double rotationSpeed;
  final double animationSpeed;

  // Optional: Noise generator
  // final NoiseGenerator? noiseGenerator;

  final Paint particlePaint;
  final Paint glowPaint;

  // Perspective settings
  final double perspectiveFactor = 500.0; // Adjust for more/less perspective

  ParticleSpherePainter({
    required this.particles,
    required this.deltaTime,
    required this.particleColor,
    required this.noiseFrequency,
    required this.noiseAmplitude,
    required this.rotationSpeed,
    required this.animationSpeed,
    // this.noiseGenerator, // Receive if using fast_noise
  }) : particlePaint = Paint()..color = particleColor,
       glowPaint =
           Paint() // Paint for the overall subtle glow
             ..color = particleColor.withValues(alpha: 0.1)
             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30.0);

  // Simple 3D noise simulation using sin/cos
  double _simulateNoise(double x, double y, double z, double time) {
    final freq = noiseFrequency;
    final speed = animationSpeed;

    // Combine multiple sine waves based on position and time
    var noise =
        math.sin(freq * x + speed * time) +
        math.sin(freq * y + speed * time * 0.7) +
        math.sin(freq * z + speed * time * 1.3);
    // Add cross-axis interaction
    noise += math.sin(freq * (x + y) * 0.5 + speed * time * 1.1);
    noise += math.cos(freq * (y + z) * 0.5 + speed * time * 0.9);

    // Normalize roughly to -1 to 1 (or a similar range)
    return noise / 5.0; // Adjust divisor based on number of terms
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rotation = deltaTime * rotationSpeed;

    // --- Optional: Draw overall background glow ---
    // canvas.drawCircle(center, size.width * 0.4, glowPaint);

    // --- Update and draw particles ---
    // Sort particles by Z for correct layering (optional but better for opacity)
    // particles.sort((a, b) => a.z.compareTo(b.z));

    for (final particle in particles) {
      // 1. Calculate original 3D position (before noise)
      final originalX =
          particle.originalRadius *
          math.sin(particle.phi) *
          math.cos(particle.theta);
      final originalY =
          particle.originalRadius * math.cos(particle.phi); // Use Y as up-axis
      final originalZ =
          particle.originalRadius *
          math.sin(particle.phi) *
          math.sin(particle.theta);

      // 2. Calculate noise displacement
      double noiseValue;
      // if (noiseGenerator != null) {
      //   // Use fast_noise if available
      //   noiseValue = noiseGenerator!.getPerlin3(
      //       originalX * noiseFrequency / 100, // Adjust frequency scaling for fast_noise
      //       originalY * noiseFrequency / 100,
      //       originalZ * noiseFrequency / 100 + time * animationSpeed
      //    );
      // } else {
      // Use simulation
      noiseValue = _simulateNoise(
        originalX / 50.0, // Scale input coords for noise function
        originalY / 50.0,
        originalZ / 50.0,
        deltaTime * animationSpeed,
      );
      // }

      final currentRadius =
          particle.originalRadius + noiseValue * noiseAmplitude;

      // 3. Calculate current 3D position (with noise)
      final currentX =
          currentRadius * math.sin(particle.phi) * math.cos(particle.theta);
      final currentY = currentRadius * math.cos(particle.phi);
      final currentZ =
          currentRadius * math.sin(particle.phi) * math.sin(particle.theta);

      // 4. Apply rotation around Y axis
      final rotatedX =
          currentX * math.cos(rotation) - currentZ * math.sin(rotation);
      final rotatedZ =
          currentX * math.sin(rotation) + currentZ * math.cos(rotation);
      particle.x = rotatedX;
      particle.y = currentY; // Y is rotation axis
      particle.z = rotatedZ;

      // 5. Simple perspective projection
      // Scale based on distance (Z). Add baseRadius to avoid division by zero/extreme values near camera
      particle.scale =
          perspectiveFactor /
          (perspectiveFactor + particle.z + particle.originalRadius);
      particle.projectedX = center.dx + particle.x * particle.scale;
      particle.projectedY =
          center.dy + particle.y * particle.scale; // Add Y to center

      // 6. Calculate Alpha/Size based on depth (and maybe noise)
      // Map Z from roughly -radius to +radius -> 0.1 to 1.0 opacity
      final depthOpacity =
          lerpDouble(
            0.1,
            1.0,
            (particle.z + particle.originalRadius) /
                (2 * particle.originalRadius),
          ) ??
          1.0;
      // Fade slightly based on how much it's displaced (optional)
      // final double displacementFactor = 1.0 - (noiseValue.abs() * 0.3).clamp(0.0, 0.5);

      final finalOpacity = depthOpacity.clamp(0.0, 1.0);
      final finalSize = (particle.pointSize *
              particle.scale *
              (0.5 + depthOpacity * 0.5))
          .clamp(0.5, particle.pointSize * 1.5); // Size also affected by depth

      // 7. Draw particle if it's roughly in front
      if (particle.z > -particle.originalRadius * 0.8) {
        // Basic culling
        particlePaint.color = particleColor.withValues(alpha: finalOpacity);
        // Additive blending can look nice for bright points
        // particlePaint.blendMode = BlendMode.plus;
        canvas.drawCircle(
          Offset(particle.projectedX, particle.projectedY),
          finalSize,
          particlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticleSpherePainter oldDelegate) {
    // Repaint continuously because of the time-based animation
    return true; // Or compare time if needed, but true is fine for continuous animation
  }
}

class ParticleApp extends StatefulWidget {
  const ParticleApp({super.key});

  @override
  State<ParticleApp> createState() => _ParticleAppState();
}

// @TODO: Animate in nicely with some kind of grow animation
class ParticleLoading extends StatelessWidget {
  const ParticleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParticleSphereWidget(
      size: 400,
      baseRadius: 150,
      particleCount: 1500,
      // Increase for density, watch performance
      noiseAmplitude: 40,
      // More wobble
      noiseFrequency: 3.5,
      pointSize: 2,
      animationSpeed: 3,
      rotationSpeed: 0.6,
      // particleColor: Colors.cyanAccent,
    );
  }
}

class _ParticleAppState extends State<ParticleApp> {
  double noiseAmplitude = 40;
  double noiseFrequency = 3.5;
  double animationSpeed = 3;
  double rotationSpeed = 0.6;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        // Match widget background or set to black
        body: Column(
          children: [
            Center(
              child: ParticleSphereWidget(
                size: 400,
                baseRadius: 150,
                particleCount: 1500,
                // Increase for density, watch performance
                noiseAmplitude: noiseAmplitude,
                // More wobble
                noiseFrequency: noiseFrequency,
                pointSize: 2,
                animationSpeed: animationSpeed,
                rotationSpeed: rotationSpeed,
                // particleColor: Colors.cyanAccent,
              ),
            ),
            Text('Noise Amplitude: $noiseAmplitude'),
            Slider(
              label: 'Noise Amplitude',
              value: noiseAmplitude,
              max: 100,
              onChanged: (newAmplitude) {
                setState(() {
                  noiseAmplitude = newAmplitude;
                });
              },
            ),
            Text('Noise Frequency: $noiseFrequency'),
            Slider(
              label: 'Noise Frequency',
              value: noiseFrequency,
              max: 5,
              onChanged: (newFrequency) {
                setState(() {
                  noiseFrequency = newFrequency;
                });
              },
            ),
            Text('Animation Speed: $animationSpeed'),
            Slider(
              label: 'Animation Speed',
              value: animationSpeed,
              min: 0.5,
              max: 10,
              onChanged: (newSpeed) {
                setState(() {
                  animationSpeed = newSpeed;
                });
              },
            ),
            Text('Rotation speed: $rotationSpeed'),
            Slider(
              label: 'Rotation Speed',
              value: rotationSpeed,
              min: 0.1,
              max: 1,
              onChanged: (newSpeed) {
                setState(() {
                  rotationSpeed = newSpeed;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
