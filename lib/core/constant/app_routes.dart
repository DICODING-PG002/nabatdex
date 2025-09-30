import 'package:nabatdex/common/shared_screen/main_screen.dart';
import 'package:nabatdex/core/constant/app_navigation_items.dart';
import 'package:nabatdex/features/journal/presentation/screen/plant_journal_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_error_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_loading_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_result_screen.dart';

class AppRoutes {
  AppRoutes._();

  static get initialRoutes => '/';

  // Definisikan semua named routes di sini
  static get routes => {
    // Entry Point untuk Screen dengan navbar
    // Di dalam nya sudah terdapat main screen fitur Journal dan Ensiklopedia
    '/': (context) => MainScreen(navigationItems: AppNavigationItems.listItem),

    // Di bawah ini named route untuk semua screen
    // kecuali main screen journal dan ensiklopedia sudah ada di routes '/'
    '/scanner/prediction/result': (context) => PredictionResultScreen(),
    '/scanner/prediction/loading': (context) => PredictionLoadingScreen(),
    '/scanner/prediction/error': (context) => PredictionErrorScreen(),

    '/journal/plant': (context) => PlantJournalScreen(),
  };
}
