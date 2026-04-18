import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/glass_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final List<String> _texts = ["Loading signals...", "Connecting to server...", "Decrypting data...", "Securing session..."];
  int _idx = 0;
  late AnimationController _ctrl;
  late Animation<double> _fade, _bar;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    _bar = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 1100));
      if (_idx < _texts.length - 1) { setState(() { _idx++; _ctrl.reset(); _ctrl.forward(); }); return true; }
      return false;
    });
    Future.delayed(const Duration(milliseconds: 4500), () => mounted ? Navigator.pushReplacementNamed(context, '/login') : null);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassCard(isDarkMode: true, width: 120, padding: EdgeInsets.zero, borderRadius: 28,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset('assets/images/logos/kimkay_logo.png', height: 120, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.trending_up, size: 56, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(opacity: _fade, child: Text(_texts[_idx], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))),
                const SizedBox(height: 24),
                SizedBox(width: 180, child: AnimatedBuilder(animation: _bar, builder: (_, __) => LinearProgressIndicator(minHeight: 5, backgroundColor: Colors.white.withOpacity(0.2), value: _bar.value, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), borderRadius: BorderRadius.circular(3)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
