import 'package:flutter/material.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';
import 'package:nabatdex/core/model/plant_model.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_page.dart';

class EncyclopediaPage extends StatefulWidget {
  const EncyclopediaPage({super.key});

  @override
  State<EncyclopediaPage> createState() => _EncyclopediaPageState();
}

class _EncyclopediaPageState extends State<EncyclopediaPage> {
  late Future<List<PlantModel>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = PlantDatabaseHelper.instance.getAllPlants();
  }

  Future<Map<int, String?>> _getPlantImages(List<PlantModel> plants) async {
    Map<int, String?> plantImages = {};
    for (var plant in plants) {
      final imagePath = await PlantDatabaseHelper.instance.getPlantImagePath(plant.id);
      plantImages[plant.id] = imagePath;
    }
    return plantImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ensiklopedia", 
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Dapatkan informasi mengenai tanaman disini",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.bodyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PlantModel>>(
                future: _plantsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada tanaman ditemukan.',
                        style: TextStyle(color: AppTheme.bodyTextColor),
                      ),
                    );
                  }

                  final plants = snapshot.data!;

                  return FutureBuilder<Map<int, String?>>(
                    future: _getPlantImages(plants),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final plantImages = imageSnapshot.data ?? {};

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20, top: 8),
                        itemCount: plants.length,
                        itemBuilder: (context, index) {
                          final plant = plants[index];
                          return PlantCard(
                            plant: plant,
                            imagePath: plantImages[plant.id],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlantDetailPage(plantId: plant.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
