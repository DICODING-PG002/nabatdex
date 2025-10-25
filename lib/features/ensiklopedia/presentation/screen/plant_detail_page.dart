import 'package:flutter/material.dart';
import 'package:nabatdex/core/model/plant_model.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/ensiklopedia/presentation/screen/disease_detail_screen.dart';

class PlantDetailPage extends StatefulWidget {
  final int plantId;

  const PlantDetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late Future<PlantModel?> _plantFuture;
  late Future<List<Map<String, dynamic>>> _imagesFuture;
  late Future<List<Map<String, dynamic>>> _diseasesFuture;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _plantFuture = PlantDatabaseHelper.instance.getPlantById(widget.plantId);
    _imagesFuture = PlantDatabaseHelper.instance.getPlantImages(widget.plantId);
    _diseasesFuture = PlantDatabaseHelper.instance.getPlantDiseases(widget.plantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlantModel?>(
      future: _plantFuture,
      builder: (context, plantSnapshot) {
        if (!plantSnapshot.hasData || plantSnapshot.data == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final plant = plantSnapshot.data!;

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppTheme.whiteColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Ensiklopedia',
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _imagesFuture,
                  builder: (context, imageSnapshot) {
                    final images = imageSnapshot.data ?? [];
                    
                    // Debug: Print number of images
                    print('Number of images loaded: ${images.length}');
                    
                    if (images.isEmpty) {
                      return Container(
                        height: 250,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200,
                        ),
                        child: Center(
                          child: Text(
                            'Tidak ada gambar tersedia',
                            style: TextStyle(color: AppTheme.bodyTextColor),
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: 250,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          // Main carousel container
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                physics: const BouncingScrollPhysics(),
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Stack(
                                      children: [
                                        // Image
                                        Image.asset(
                                          images[index]['image_path'] ?? 'assets/image/image_not_found.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        // Image label badge
                                        Positioned(
                                          right: 16,
                                          bottom: 16,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              _getImageLabel(index),
                                              style: const TextStyle(
                                                color: AppTheme.whiteColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Navigation arrows
                          if (images.length > 1) ...[
                            // Left arrow
                            Positioned(
                              left: 8,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: _currentPage > 0
                                        ? () {
                                            _pageController.previousPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            // Right arrow
                            Positioned(
                              right: 8,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: _currentPage < images.length - 1
                                        ? () {
                                            _pageController.nextPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          // Page indicator
                          if (images.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  images.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? AppTheme.whiteColor
                                          : AppTheme.whiteColor.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
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
                      Text(
                        plant.commonName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plant.scientificName,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.bodyTextColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        plant.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildInfoGrid(plant),
                      const SizedBox(height: 24),

                      _buildExpansionTile(
                        "Tips Pro",
                        plant.irqTips,
                      ),
                      const SizedBox(height: 16),

                      _buildExpansionTile(
                        "Panduan Budidaya",
                        plant.cultivationGuide,
                      ),
                      
                      const SizedBox(height: 24),
                      const Text(
                        "Hama & Penyakit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _diseasesFuture,
                        builder: (context, diseaseSnapshot) {
                          if (diseaseSnapshot.hasData && diseaseSnapshot.data!.isNotEmpty) {
                            return Column(
                              children: diseaseSnapshot.data!.map((disease) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildDiseaseItem(
                                    context,
                                    diseaseId: disease['pest_disease_id'],
                                    title: disease['name'],
                                    subtitle: disease['type'],
                                    color: AppTheme.primaryColor,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DiseaseDetailPage(
                                            diseaseId: disease['pest_disease_id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                          return Text(
                            'Tidak ada data hama dan penyakit',
                            style: TextStyle(color: AppTheme.bodyTextColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getImageLabel(int index) {
    final labels = ['Hasil Panen', 'Saat Berbunga', 'Bibit'];
    return labels[index % labels.length];
  }

  Widget _buildInfoGrid(PlantModel plant) {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoItem("Tipe tanaman", plant.plantType),
            _buildInfoItem("Siklus Hidup", plant.lifeCycle),
            _buildInfoItem("Suhu Optimal", plant.optimalTemperature),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildInfoItem("Sinar Matahari", "Minimal 6-8 jam/hari"),
            _buildInfoItem("Tingkat Kesulitan", "Pemula hingga Menengah"),
            _buildInfoItem("Air & Penyiraman", "Konsisten dan jaga kelembapan tanah"),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseItem(BuildContext context,
      {required int diseaseId,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Disease image
            FutureBuilder<List<Map<String, dynamic>>>(
              future: PlantDatabaseHelper.instance.getDiseaseImages(diseaseId),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.hasData && imageSnapshot.data!.isNotEmpty) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.whiteColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        imageSnapshot.data!.first['image_path'] ?? 'assets/image/image_not_found.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                // Fallback icon if no image
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    color: AppTheme.whiteColor,
                    size: 24,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.whiteColor.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.whiteColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
