import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/services/db/languages.dart';
import 'package:dokdok/services/db/templates.dart';
import 'package:dokdok/services/log/console.dart';
import 'package:dokdok/services/log/interface.dart';
import 'package:dokdok/services/process_run/create_file.dart';
import 'package:dokdok/services/process_run/docker_process.dart';
import 'package:dokdok/services/process_run/tokei_process.dart';
import 'package:dokdok/shared/constant/nav_items.dart';
import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:dokdok/src/docker_image/data/repos/docker_image_repos_impl.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/src/docker_image/presentation/docker_image.dart';
import 'package:dokdok/src/docker_template/data/templates.dart';
import 'package:dokdok/src/docker_template/presentation/docker_template.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:process_run/cmd_run.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'shared/ui/navbar.dart';
import 'shared/ui/sidebar.dart';
import 'package:go_router/go_router.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  registerDependencies();
  checkInstalled();
  runApp(const MyApp());
}

void sqfliteFfiInit() {
}

Future<void> checkInstalled() async {
  var dockerProcess = GetIt.I<DockerProcess>();
  var dockerRes = await dockerProcess.isInstalled();
  if(!dockerRes) {
    var res = await dockerProcess.install();
    if(!res) {
      throw Exception('Error while installing Docker. Please check your installation method.');
    }
  }
  var tokeiProcess = GetIt.I<TokeiProcess>();
  var tokeiRes = await tokeiProcess.isInstalled();
  if(!tokeiRes) {
    var res = await tokeiProcess.install();
    if(!res) {
      throw Exception('Error while installing Tokei. Please check your installation method.');
    }
  }
  print('Docker and Tokei are installed and available in PATH');
}


void registerDependencies() {
 GetIt.I.registerSingleton<Log>(ConsoleLog());  GetIt.I.registerSingleton<DockerImageInterface>(DockerImageInterfaceImpl());
  GetIt.I.registerFactory(() => DockerImageUsecase(GetIt.I<DockerImageInterface>()));
  GetIt.I.registerSingleton<DockerProcess>(DockerProcess(GetIt.I<Log>()));
  GetIt.I.registerSingleton<TokeiProcess>(TokeiProcess(GetIt.I<Log>()));
  GetIt.I.registerSingleton<DbManager<Languages>>(LanguagesDbManager());
  GetIt.I.registerSingleton<DbManager<Templates>>(TemplatesDbManager());
  GetIt.I.registerSingleton<TemplatesDbManager>(TemplatesDbManager());
  GetIt.I.registerSingleton<CreateFileProcess>(CreateFileProcess(GetIt.I<Log>()));
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