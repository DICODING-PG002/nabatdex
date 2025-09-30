import 'package:nabatdex/common/shared_provider/navigation_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

/// Class provider to be used in main. Contains the globalProvider property.
class AppProvider {
  /// The location of all providers used in the application is here.
  static List<SingleChildWidget> get globalProviders {
    return [
      ChangeNotifierProvider<NavigationProvider>(
        create: (_) => NavigationProvider(),
      ),
    ];
  }
}
