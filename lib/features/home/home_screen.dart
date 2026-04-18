import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: AppColors.textDark),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        GlassCard(child: Column(children: [
          Image.asset('assets/images/logos/kimkay_logo.png', height: 80, errorBuilder: (_,__,___) => const Icon(Icons.trending_up, size: 60, color: AppColors.primaryGreen)),
          const SizedBox(height: 16),
          const Text("Welcome back, Trader 👋", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Access premium signals & grow your portfolio", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ])),
        const SizedBox(height: 24),
        GlassCard(backgroundColor: const Color(0xFFFFF3E0), child: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Text("⚠️ Trading is risky. Use proper risk management. Past performance does not guarantee future results.", style: TextStyle(fontSize: 14, color: Colors.brown.shade800))),
        ])),
      ]))),
    );
  }
}
