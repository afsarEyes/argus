import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _digestFrequency = 'daily';
  String _digestRecipientGroup = 'supervisors';
  bool _includeSlaMetrics = true;

  void _simulateExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting filtered ticket logs to $format format... (Downloaded successfully)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveDigestConfig() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Digest scheduling rule saved. Resend SMTP updates registered.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REPORTS & DIGEST GENERATOR',
                  style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900, fontSize: 16, color: colors.textPrimary),
                ),
                Text(
                  'Export analytical summaries or configure automated shift digest emails to plant general management.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Two Column Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Col 1: Export Panel
                Expanded(
                  child: ArgusPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.download, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'EXPORT QC LOGS',
                                style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Compile and download raw ticket event records for internal audits or external compliance reporting.',
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                          ),
                          const SizedBox(height: 24),

                          // PDF button
                          ElevatedButton.icon(
                            onPressed: () => _simulateExport('PDF'),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text(
                              'GENERATE PDF REPORT',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // CSV button
                          OutlinedButton.icon(
                            onPressed: () => _simulateExport('CSV'),
                            icon: const Icon(Icons.table_view),
                            label: const Text(
                              'EXPORT RAW CSV SPREADSHEET',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Col 2: Email Digest configuration
                Expanded(
                  child: ArgusPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.mail_outline, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'EMAIL DIGEST SCHEDULER',
                                style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Schedule automated Resend/SMTP digests containing summaries of closed work, breaches, and MTTR performance.',
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                          ),
                          const SizedBox(height: 20),

                          // Frequency Dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Dispatch Frequency'),
                            value: _digestFrequency,
                            items: const [
                              DropdownMenuItem(value: 'shift', child: Text('AT THE END OF EVERY SHIFT (8H)')),
                              DropdownMenuItem(value: 'daily', child: Text('DAILY METRIC DIGEST (24H)')),
                              DropdownMenuItem(value: 'weekly', child: Text('WEEKLY PERFORMANCE SUMMARY (7D)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _digestFrequency = val);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Target recipient dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Target Recipient Group'),
                            value: _digestRecipientGroup,
                            items: const [
                              DropdownMenuItem(value: 'supervisors', child: Text('LINE SUPERVISORS & ENGINEERS')),
                              DropdownMenuItem(value: 'leadership', child: Text('PLANT DIRECTORS & QUALITY MANAGERS')),
                              DropdownMenuItem(value: 'all', child: Text('FULL QC WORKFORCE')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _digestRecipientGroup = val);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Include SLA Switch
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Include SLA compliance charts',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text('Embeds compliance line graphs in HTML email digests'),
                            value: _includeSlaMetrics,
                            onChanged: (val) => setState(() => _includeSlaMetrics = val),
                          ),
                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: _saveDigestConfig,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.brandAccent,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text(
                              'SAVE SCHEDULE CONFIG',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
