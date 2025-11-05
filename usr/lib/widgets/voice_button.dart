import 'package:flutter/material.dart';

class VoiceButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isListening;
  
  const VoiceButton({
    super.key,
    required this.onTap,
    required this.isListening,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: widget.isListening
                    ? const LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                      )
                    : LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.isListening
                        ? Colors.red.withOpacity(0.5)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    blurRadius: 16,
                    spreadRadius: widget.isListening ? 4 : 0,
                  ),
                ],
              ),
              child: Icon(
                widget.isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}