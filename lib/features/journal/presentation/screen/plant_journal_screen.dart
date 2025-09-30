import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class PlantJournalScreen extends StatelessWidget {
  const PlantJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Jurnal Tanaman"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Image Gallery
            Image.asset(
              'assets/image/image_not_found.png',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            //Plant Information
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Ikon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Padi',
                              style: TextTheme.of(context).headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Terindikasi penyakit kresek (70%)',
                              style: TextTheme.of(context).titleMedium,
                            ),
                          ],
                        ),
                      ),
                      //Icon Sakit
                      Icon(Symbols.syringe),
                      //Icon Sehat
                      // Icon(Symbols.check_circle),
                    ],
                  ),

                  // Indikasi Penyakit
                  const SizedBox(height: 16),

                  // Deskripsi Penyebab
                  Text(
                    'Disebabkan oleh bakteri Xanthomonas oryzae pv. oryzae. Bakteri ini masuk ke tanaman padi melalui luka pada daun atau melalui pori-pori alami daun (hidatoda). Penyakit ini menyebar sangat cepat melalui percikan air hujan, irigasi, dan angin. Kondisi lembap dan hangat, serta pemupukan Nitrogen (N) yang berlebihan, akan memperparah serangan.',
                    textAlign: TextAlign.justify,
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Solusi & Pengendalian
                  Text(
                    'Solusi & Pengendalian',
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras velit eros,',
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Aktivitas Perawatan Anda
                  Text(
                    'Aktivitas Perawatan Anda',
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai lakukan pencatatan aktivitas anda merawat tanaman ini dengan menyimpan hasil prediksi ke jurnal anda',
                    style: TextTheme.of(context).bodyMedium,
                  ),

                  // Memberi ruang agar tidak tertutup FAB
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Tombol plus ditekan!');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, size: 32, color: AppTheme.accentColor),
      ),
    );
  }
}
