import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/glass_card.dart';

class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  Color _color(String s) => s == 'Active' ? Colors.green : s == 'Add More' ? Colors.orange : s == 'TP Hit' ? Colors.blue : s == 'SL Hit' ? Colors.red : Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Live Signals'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: AppColors.textDark),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('signals').orderBy('createdAt', descending: true).snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
          if (!snap.hasData || snap.data!.docs.isEmpty) return const Center(child: Text('No active signals', style: TextStyle(color: Colors.grey)));
          
          return ListView.builder(padding: const EdgeInsets.all(16), itemCount: snap.data!.docs.length,
            itemBuilder: (ctx, i) {
              final d = snap.data!.docs[i].data() as Map<String, dynamic>;
              final status = d['status'] ?? 'Active';
              final col = _color(status);
              return Padding(padding: const EdgeInsets.only(bottom: 12), child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(d['pair'] ?? 'UNKNOWN', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: col.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(color: col, fontWeight: FontWeight.w600, fontSize: 12))),
                ]),
                const Divider(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _blk('Type', d['type'] ?? '-', d['type']?.toString().toUpperCase() == 'BUY' ? Colors.green : Colors.red),
                  _blk('Entry', d['entry']?.toString() ?? '-', Colors.black87),
                  _blk('TP', d['tp']?.toString() ?? '-', Colors.blue),
                  _blk('SL', d['sl']?.toString() ?? '-', Colors.red),
                ]),
              ])));
            });
        },
      ),
    );
  }

  Widget _blk(String l, String v, Color c) => Column(children: [Text(l, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), const SizedBox(height: 4), Text(v, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14))]);
}
