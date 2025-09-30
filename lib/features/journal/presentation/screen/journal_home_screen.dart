import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jurnal Tanaman", style: TextTheme.of(context).displaySmall),
              Text(
                "Lihat tanaman yang anda sudah scan disini",
                style: TextTheme.of(
                  context,
                ).titleSmall?.copyWith(color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 32),

              //Card Tanaman
              GestureDetector(
                onTap: () => {Navigator.pushNamed(context, "/journal/plant")},
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 12,
                    children: [
                      // Image
                      SizedBox(
                        width: screenWidth * 0.2,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/image/image_not_found.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Information Text
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              "Padi",
                              style: TextTheme.of(context).titleLarge?.copyWith(
                                color: AppTheme.whiteColor,
                              ),
                            ),
                            Text(
                              "Terindikasi Penyakit kresek",
                              style: TextTheme.of(
                                context,
                              ).bodySmall?.copyWith(color: AppTheme.whiteColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Symbols.schedule,
                                  color: AppTheme.whiteColor.withValues(
                                    alpha: 0.4,
                                  ),
                                  size: 14,
                                ),
                                Text(
                                  "21 Sep ‘25, 15:10 WIB",
                                  style: TextTheme.of(context).bodySmall
                                      ?.copyWith(
                                        color: AppTheme.whiteColor.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Icon Sakit
                      Icon(Symbols.syringe),
                      // Icon Sehat
                      // Icon(Symbols.check_circle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
