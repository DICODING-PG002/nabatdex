import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class PredictionResultScreen extends StatelessWidget {
  const PredictionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          "Hasil Prediksi",
          style: TextTheme.of(
            context,
          ).titleMedium?.copyWith(color: AppTheme.textColor),
        ),
        centerTitle: true,
      ),
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
                      Column(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              print('Simpan Ke Jurnal ditekan!');
            },
            label: Text(
              'Simpan Ke Jurnal',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.whiteColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ), // Atur radius sesuai desain
            ),
          ),
        ),
      ),
    );
  }
}
