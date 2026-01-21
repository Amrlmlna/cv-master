import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/faq_item.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@cvmaster.id',
      query: 'subject=Bantuan Aplikasi CV Master&body=Halo tim support, saya butuh bantuan...',
    );

    if (!await launchUrl(emailLaunchUri)) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Tidak bisa membuka aplikasi email.')),
         );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Cards
            Row(
              children: [
                Expanded(
                  child: _SupportCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'Hubungi kami',
                    onTap: _contactSupport,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SupportCard(
                    icon: Icons.feedback_outlined,
                    title: 'Masukan',
                    subtitle: 'Lapor bug/saran',
                    onTap: () => context.push('/support/feedback'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Pertanyaan Umum (FAQ)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const FAQItem(
              question: 'Apakah CV Master gratis?',
              answer: 'Ya, fitur dasar CV Master gratis untuk digunakan. Kami mungkin menambahkan fitur premium di masa mendatang.',
            ),
            const FAQItem(
              question: 'Bagaimana cara mengubah profil?',
              answer: 'Pergi ke menu Profile di navigasi bawah, lalu edit bagian yang ingin Anda ubah dan tekan simpan.',
            ),
             const FAQItem(
              question: 'Apakah data saya aman?',
              answer: 'Data Anda disimpan secara lokal di perangkat Anda (hanya Master Profile). Data yang dikirim ke AI diproses sesaat dan tidak disimpan oleh pihak ketiga untuk tujuan lain.',
            ),
            const FAQItem(
              question: 'Bisa export ke PDF?',
              answer: 'Tentu! Setelah selesai membuat CV, Anda bisa melihat preview dan menekan tombol Download/Print PDF di pojok kanan atas.',
            ),

            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Image.asset('assets/icon/icon.png', width: 48, height: 48, errorBuilder: (context, error, stackTrace) => const Icon(Icons.description, size: 48, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    'CV Master $_appVersion',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.push('/legal/privacy'),
                        child: Text('Privacy Policy', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      TextButton(
                        onPressed: () => context.push('/legal/terms'),
                        child: Text('Terms of Service', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            ),
             const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
           border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
