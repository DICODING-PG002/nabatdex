import 'package:nabatdex/common/shared_screen/main_screen.dart';
import 'package:nabatdex/core/constant/app_navigation_items.dart';
import 'package:nabatdex/features/journal/presentation/screen/plant_journal_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/image_loading_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/image_preview_screen.dart';

class AppRoutes {
  AppRoutes._();

  static get initialRoutes => '/';
  // Definisikan semua named routes di sini
  static get routes => {
    // Entry Point untuk Screen dengan navbar
    // Di dalam nya sudah terdapat main screen fitur Journal dan Ensiklopedia
    '/': (context) => MainScreen(navigationItems: AppNavigationItems.listItem),
    '/scanner/loading': (context) => const ImageLoadingScreen(),
    '/scanner/preview': (context) => const ImagePreviewScreen(),
    '/journal/plant': (context) => const PlantJournalScreen(),
  };
}
