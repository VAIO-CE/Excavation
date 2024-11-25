import 'package:go_router/go_router.dart';
import 'package:excavator/pages/instance.dart';
// import 'package:excavator/pages/controller_change_page.dart';
// import 'package:excavator/pages/firmware_update_page.dart';
// import 'package:excavator/pages/home_page.dart';

class AppRouter {
  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyAppInstance(),
    ),
    // GoRoute(
    //   path: '/controller',
    //   builder: (context, state) => const MyControllerChangePage(),
    // ),
    // GoRoute(
    //   path: '/firmware',
    //   builder: (context, state) => const MyFirmwarePage(),
    // ),
  ]);
}
