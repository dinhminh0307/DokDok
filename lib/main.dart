import 'package:dokdok/src/docker_image/data/repos/docker_image_repos_impl.dart';
import 'package:dokdok/src/docker_image/domain/repos/docker_image_repos.dart';
import 'package:dokdok/src/docker_image/domain/usecases/docker_image_usecase.dart';
import 'package:dokdok/src/docker_image/presentation/docker_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'shared/ui/navbar.dart';
import 'shared/ui/sidebar.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'DokDok',
      theme: FluentThemeData(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

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
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Center(
              child: DockerImageApp(DockerImageUsecase(DockerImageInterfaceImpl())),
            ),
          ),
        ],
      ),
    );
  }
}