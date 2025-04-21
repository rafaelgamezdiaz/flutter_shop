import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/presentation/screens/screens.dart';
import '../../features/products/presentation/screens/screens.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable:
        goRouterNotifier, // Espera un Listenable, estará pendiente de cuando el estado de la autenticación cambie se vuelve a ejecutar el redirect
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(path: '/', builder: (context, state) => const ProductsScreen()),
    ],
    redirect: (context, state) {
      final isGoingTo = state.subloc; // Ruta actual o a la que se intenta ir
      final authStatus =
          goRouterNotifier.authStatus; // Estado de autenticación actual

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
        return null;
      }

      // Aqui podemos hacer otro tipo de verificaciones, ejemplo
      // if (user.role != 'isAdmin' && isGoingTo == '/removeUser') return '/'  .....

      return null;
    },
  );
});
