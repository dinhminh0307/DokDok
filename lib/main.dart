import 'package:dokdok/shared/constant/nav_items.dart';
import 'package:dokdok/src/docker_image/data/repos/docker_image_repos_impl.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/src/docker_image/presentation/docker_image.dart';
import 'package:dokdok/src/docker_template/presentation/docker_template.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'shared/ui/navbar.dart';
import 'shared/ui/sidebar.dart';
import 'package:go_router/go_router.dart';

void main() {
  registerDependencies();
  runApp(const MyApp());
}

void registerDependencies() {
  GetIt.I.registerSingleton<DockerImageInterface>(DockerImageInterfaceImpl());
  GetIt.I.registerFactory(() => DockerImageUsecase(GetIt.I<DockerImageInterface>()));
}

// Define your routes
final GoRouter _router = GoRouter(
  initialLocation: '/docker-images',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/docker-images',
          builder: (context, state) => DockerImageApp(GetIt.I<DockerImageUsecase>()),
        ),
        // Add more routes here, e.g.:
        GoRoute(
          path: '/templates',
          builder: (context, state) {
          final folder = state.uri.queryParameters['folder'];
          return DockerTemplateApp(folder: folder);
        },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'DokDok',
      theme: FluentThemeData(),
      routerConfig: _router,
    );
  }
}

// MainScreen is now a layout widget that always shows Navbar and Sidebar
class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<String> routePaths = [
    '/docker-images',
    // '/tasks',
  ];

  void _onSidebarItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    print('Selected route: ${navItems[index].route}');
    GoRouter.of(context).go(navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Navbar(
        userName: 'John Doe',
        userEmail: 'john@example.com',
        notificationCount: 3,
      ),
      content: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: _onSidebarItemSelected,
            items: navItems,
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}