import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class PTTButton extends StatefulWidget {
  const PTTButton({super.key});

  @override
  State<PTTButton> createState() => _PTTButtonState();
}

class _PTTButtonState extends State<PTTButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isTransmitting = appState.isTransmitting;

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        appState.startTransmitting();
      },
      onTapUp: (_) {
        _controller.reverse();
        appState.stopTransmitting();
      },
      onTapCancel: () {
        _controller.reverse();
        appState.stopTransmitting();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTransmitting ? Colors.red.shade700 : Colors.orange,
                boxShadow: [
                  BoxShadow(
                    color: (isTransmitting ? Colors.red : Colors.orange).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
                gradient: RadialGradient(
                  colors: isTransmitting
                      ? [Colors.red.shade400, Colors.red.shade900]
                      : [Colors.orange.shade400, Colors.deepOrange.shade900],
                  center: const Alignment(-0.2, -0.2),
                  radius: 1.2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isTransmitting ? Icons.mic : Icons.mic_none,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isTransmitting ? 'TALKING' : 'HOLD TO TALK',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
