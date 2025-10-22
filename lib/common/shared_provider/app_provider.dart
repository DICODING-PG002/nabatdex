import 'package:nabatdex/common/shared_provider/journal_refresh_provider.dart';
import 'package:nabatdex/common/shared_provider/navigation_provider.dart';
import 'package:nabatdex/common/shared_provider/plant_database_provider.dart';
import 'package:nabatdex/features/scanner/presentation/providers/image_scan_provider.dart';
import 'package:nabatdex/features/scanner/presentation/providers/prediction_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

class AppProvider {
  static List<SingleChildWidget> get globalProviders {
    return [
      ChangeNotifierProvider<NavigationProvider>(
        create: (_) => NavigationProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ImageScanProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PredictionProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => JournalRefreshProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PlantDatabaseProvider(),
      ),
    ];
  }
}
