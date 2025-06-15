import 'package:fluent_ui/fluent_ui.dart';

class NavItem {
  final String label;
  final String route;
  final IconData icon;
  const NavItem(this.label, this.route, this.icon);
}

final List<NavItem> navItems = [
  NavItem('Docker Images', '/docker-images', FluentIcons.database),
];