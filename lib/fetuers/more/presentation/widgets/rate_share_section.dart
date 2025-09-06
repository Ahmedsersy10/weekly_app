import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'dart:io' show Platform;

class RateShareSection extends StatelessWidget {
  const RateShareSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).tr('more.rateShare'),
            style: AppStyles.styleSemiBold20(
              context,
            ).copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),

          // Rate the App
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).tr('more.rateApp'),
                      style: AppStyles.styleSemiBold16(
                        context,
                      ).copyWith(color: Colors.amber[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) =>
                          Icon(Icons.star, color: Colors.amber[600], size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '5.0',
                      style: AppStyles.styleSemiBold16(
                        context,
                      ).copyWith(color: Colors.amber[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _rateApp(),
                    icon: const Icon(Icons.rate_review, size: 18),
                    label: Text(
                      AppLocalizations.of(context).tr('more.rateOnStore'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[600],
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Share the App
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.share, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).tr('more.shareAppTitle'),
                      style: AppStyles.styleSemiBold16(
                        context,
                      ).copyWith(color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).tr('more.shareAppSubtitle'),
                  style: AppStyles.styleRegular14(
                    context,
                  ).copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _shareApp(),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(
                      AppLocalizations.of(context).tr('more.shareApp'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Benefits of Sharing
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).tr('more.sharingBenefits'),
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: Colors.blue[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _rateApp() async {
    // Try to open the app store for rating
    String url;

    // You can customize these URLs based on your app's actual store listings
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.example.weekly';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/weekly-app/id123456789';
    } else {
      url = 'https://weeklyapp.com';
    }

    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch app store');
      }
    } catch (e) {
      print('Error launching app store: $e');
    }
  }

  Future<void> _shareApp() async {
    try {
      await Share.share(
        'Check out Weekly App - Your Personal Task Manager! 📱✨\n\n'
        'Stay organized and productive with this amazing app!\n\n'
        'Download now: https://weeklyapp.com',
        subject: 'Weekly App - Task Management Made Simple',
      );
    } catch (e) {
      print('Error sharing app: $e');
    }
  }
}
