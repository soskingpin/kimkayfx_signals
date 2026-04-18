import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/license_repository.dart';
import '../../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _keyCtrl = TextEditingController();
  final _repo = LicenseRepository();
  bool _loading = false;

  Future<void> _activate() async {
    final key = _keyCtrl.text.trim().toUpperCase();
    if (key.isEmpty) return;
    setState(() => _loading = true);
    final res = await _repo.validateLicense(key);
    setState(() => _loading = false);
    if (!mounted) return;

    if (res['status'] == 'valid') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showError(res['message'], res['status']);
    }
  }

  void _showError(String msg, String status) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Activation Failed'),
      content: Text(msg),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
        if (status != 'used') ElevatedButton(onPressed: () { Navigator.pop(ctx); _showPayment(); }, child: const Text('Buy License')),
      ],
    ));
  }

  void _showPayment() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Choose Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _payBtn('EcoCash', 'ecocash_logo.png'),
        _payBtn('InnBucks', 'innbucks_logo.png'),
        _payBtn('Omari', 'omari_logo.png'),
      ])),
    );
  }

  Widget _payBtn(String name, String logo) {
    return ListTile(
      leading: Image.asset('assets/images/logos/$logo', height: 32, errorBuilder: (_,__,___) => const Icon(Icons.payment)),
      title: Text(name),
      onTap: () async {
        Navigator.pop(context);
        // ✅ FIXED: Use launchUrl with Uri.parse
        final msg = Uri.encodeComponent("Hi KimKayFX, I want to buy a license using $name.");
        final url = Uri.parse("https://wa.me/263779894763?text=$msg");
        if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
          const Spacer(),
          Image.asset('assets/images/logos/kimkay_logo.png', height: 70, errorBuilder: (_,__,___) => const Icon(Icons.shield, size: 48, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("KimKayFX Academy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          GlassCard(isDarkMode: true, child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("🔑 Activate License", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text("Enter your key to unlock premium signals", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
            const SizedBox(height: 28),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.3))),
              child: TextField(controller: _keyCtrl, decoration: const InputDecoration(hintText: "KMK-ELIT-XXXX", hintStyle: TextStyle(color: Colors.white60), border: InputBorder.none), style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 54, child: ElevatedButton(onPressed: _loading ? null : _activate, child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.darkGreen, strokeWidth: 2)) : const Text("ACTIVATE NOW"))),
          ])),
          const Spacer(),
          Text("v1.0.0 • KimKayFX Academy", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const SizedBox(height: 20),
        ]))),
      ),
    );
  }
}
