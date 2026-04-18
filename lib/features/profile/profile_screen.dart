import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/license_repository.dart';
import '../../widgets/glass_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _k = 'Loading...', _t = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = LicenseRepository();
    final k = await r.getActiveKey();
    final e = await r.getExpiresAt();
    setState(() {
      _k = k ?? 'Not Active';
      if (e != null) {
        final d = DateTime.fromMillisecondsSinceEpoch(e).difference(DateTime.now());
        _t = '${d.inDays}d ${d.inHours.remainder(24)}h ${d.inMinutes.remainder(60)}m';
      } else { _t = 'Expired'; }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: AppColors.textDark),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        GlassCard(child: Column(children: [
          const CircleAvatar(radius: 32, backgroundColor: AppColors.primaryGreen, child: Icon(Icons.person, size: 32, color: Colors.white)),
          const SizedBox(height: 12), const Text('Trader Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 16),
          _r('License Key', _k), const SizedBox(height: 12), _r('Time Remaining', _t),
        ])),
        const Spacer(),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _logout, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400), child: const Text('LOGOUT'))),
        const SizedBox(height: 20),
      ]))),
    );
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(context: context,
      builder: (c) => AlertDialog(title: const Text('Logout'), content: const Text('Are you sure? You will need to reactivate your license.'),
        actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Logout'))],
      ));
    if (ok == true) {
      await LicenseRepository().logout();
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Widget _r(String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: TextStyle(color: Colors.grey.shade600)), Text(v, style: const TextStyle(fontWeight: FontWeight.w600))]);
}
