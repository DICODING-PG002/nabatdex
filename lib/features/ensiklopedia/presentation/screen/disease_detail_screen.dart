import 'package:flutter/material.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';

class DiseaseDetailPage extends StatefulWidget {
  final int diseaseId; // ID penyakit/hama
  const DiseaseDetailPage({Key? key, required this.diseaseId}) : super(key: key);

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  Map<String, dynamic>? diseaseData;
  List<String> diseaseImages = [];

  @override
  void initState() {
    super.initState();
    _loadDiseaseDetail();
  }

  Future<void> _loadDiseaseDetail() async {
    final db = await PlantDatabaseHelper.instance.database;

    // Ambil data penyakit berdasarkan ID
    final diseaseResult = await db.query(
      'pest_disease_master',
      where: 'pest_disease_id = ?',
      whereArgs: [widget.diseaseId],
    );

    if (diseaseResult.isNotEmpty) {
      // Ambil gambar terkait penyakit
      final imageResult = await db.query(
        'pest_disease_image',
        where: 'pest_disease_id = ?',
        whereArgs: [widget.diseaseId],
        orderBy: 'display_order ASC',
      );

      setState(() {
        diseaseData = diseaseResult.first;
        diseaseImages = imageResult.map((img) => img['image_path'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (diseaseData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          diseaseData!['name'],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar utama (carousel kalau lebih dari satu)
            if (diseaseImages.isNotEmpty)
              Container(
                height: 250,
                margin: const EdgeInsets.all(16),
                child: PageView.builder(
                  itemCount: diseaseImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          diseaseImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 250,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text("Tidak ada gambar tersedia"),
                ),
              ),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDiseaseHeader(),
                  const SizedBox(height: 24),

                  _buildSectionCard(
                    "Deskripsi",
                    diseaseData!['description'],
                    Icons.description,
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    "Penyebab",
                    diseaseData!['cause'],
                    Icons.warning,
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    "Solusi & Pengendalian",
                    diseaseData!['control_solution'],
                    Icons.build,
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    "Pencegahan",
                    diseaseData!['prevention_guide'],
                    Icons.shield,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              diseaseData!['type'] == 'Penyakit' ? Icons.medical_services : Icons.bug_report,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diseaseData!['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  diseaseData!['type'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.green.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
