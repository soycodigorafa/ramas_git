import 'package:go_router/go_router.dart';
import 'package:ramas_git/presentation/git_module/main_view.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const GitMainView()),
    // Puedes agregar más rutas aquí, por ejemplo para settings o auth
  ],
);
