import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_card.dart';

class LicenseLoginScreen extends StatelessWidget {
  const LicenseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Top Brand Logo
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logos/kimkay_logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.shield, size: 48, color: Colors.white);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "KimKayFX Academy",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                
                // Glass Activation Card
                GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "🔑 Activate License",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your key to unlock premium signals",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "KMK-ELIT-XXXX",
                            hintStyle: TextStyle(color: Colors.white60),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Firebase validation logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.darkGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text("ACTIVATE NOW"),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // Payment Logos Preview (Will be fully integrated in Packages tab later)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPaymentLogo('omari_logo.png'),
                    const SizedBox(width: 16),
                    _buildPaymentLogo('ecocash_logo.png'),
                    const SizedBox(width: 16),
                    _buildPaymentLogo('innbucks_logo.png'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "v1.0.0 • KimKayFX Academy",
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String assetName) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          'assets/images/logos/$assetName',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.payment, color: Colors.white.withOpacity(0.6));
          },
        ),
      ),
    );
  }
}
