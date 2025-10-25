import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_screen/main_screen.dart';
import 'package:nabatdex/core/constant/app_navigation_items.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
import 'package:nabatdex/core/model/prediction_result_model.dart';
import 'package:nabatdex/features/journal/presentation/screen/plant_journal_screen.dart';
import 'package:nabatdex/features/ensiklopedia/presentation/screen/encyclopedia_page.dart';
import 'package:nabatdex/features/scanner/presentation/providers/prediction_provider.dart';
import 'package:nabatdex/features/scanner/presentation/screen/image_loading_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/image_preview_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_error_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_loading_screen.dart';
import 'package:nabatdex/features/scanner/presentation/screen/prediction_result_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String scannerLoading = '/scanner/loading';
  static const String scannerPreview = '/scanner/preview';
  static const String predictionLoading = '/scanner/prediction/loading';
  static const String predictionResult = '/scanner/prediction/result';
  static const String predictionError = '/scanner/prediction/error';
  static const String journalPlant = '/journal/plant';
  static const String encyclopedia = '/encyclopedia';

  static String get initialRoutes => home;

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => MainScreen(navigationItems: AppNavigationItems.listItem),
    scannerLoading: (context) => const ImageLoadingScreen(),
    scannerPreview: (context) => const ImagePreviewScreen(),
    predictionLoading: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return PredictionLoadingScreen(
        imagePath: args['imagePath'] as String,
        predictionProvider: args['predictionProvider'] as PredictionProvider,
      );
    },
    predictionResult: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as PredictionResultModel;
      return PredictionResultScreen(result: args);
    },
    predictionError: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String?;
      return PredictionErrorScreen(errorMessage: args);
    },
    journalPlant: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as JournalEntryModel;
      return PlantJournalScreen(journalEntry: args);
    },
    encyclopedia: (context) => const EncyclopediaPage(),
  };
}
