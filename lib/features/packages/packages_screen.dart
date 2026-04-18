import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/glass_card.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});
  final List<Map<String, dynamic>> _packages = const [
    {'name': 'Weekly', 'price': 10, 'duration': '7 Days'},
    {'name': 'Bi-Weekly', 'price': 15, 'duration': '14 Days'},
    {'name': 'Monthly', 'price': 30, 'duration': '30 Days'},
    {'name': 'Lifetime', 'price': 60, 'duration': 'Forever'},
    {'name': 'Mentorship', 'price': 80, 'duration': '1-on-1 Coaching'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Packages'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: AppColors.textDark),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _packages.length,
        itemBuilder: (ctx, i) {
          final p = _packages[i];
          return Padding(padding: const EdgeInsets.only(bottom: 12), child: GlassCard(onTap: () => _pay(ctx, p),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.card_giftcard, color: AppColors.primaryGreen)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(p['duration'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13))])),
              Text('\$${p['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
            ])),
          );
        }),
    );
  }

  void _pay(BuildContext ctx, Map<String, dynamic> p) {
    showModalBottomSheet(context: ctx, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Buy ${p['name']} (\$${p['price']})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _btn(c, 'EcoCash', 'ecocash_logo.png', p),
        _btn(c, 'InnBucks', 'innbucks_logo.png', p),
        _btn(c, 'Omari', 'omari_logo.png', p),
      ])),
    );
  }

  Widget _btn(BuildContext ctx, String method, String logo, Map<String, dynamic> p) {
    return ListTile(
      leading: Image.asset('assets/images/logos/$logo', height: 32, errorBuilder: (_,__,___) => const Icon(Icons.payment)),
      title: Text(method),
      onTap: () async {
        Navigator.pop(ctx);
        // ✅ FIXED: Use launchUrl with Uri.parse
        final msg = Uri.encodeComponent("Hi KimKayFX, I want to buy ${p['name']} (\$${p['price']}) using $method.");
        final url = Uri.parse("https://wa.me/263779894763?text=$msg");
        if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
      },
    );
  }
}
