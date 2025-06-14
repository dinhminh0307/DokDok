import 'package:dokdok/shared/constant/nav_items.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<NavItem> items; // received from parent

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF9B5DE5), // Purple background
      child: Column(
        children: [
          // Header
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(FluentIcons.table, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'AppName',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(FluentIcons.global_nav_button, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Dynamically generate navigation items
          for (int i = 0; i < items.length; i++)
            _SidebarItem(
              icon: items[i].icon,
              label: items[i].label,
              selected: selectedIndex == i,
              onTap: () => onItemSelected(i),
            ),
          const Spacer(),
          // Help at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 16.0),
            child: Row(
              children: const [
                Icon(FluentIcons.info, color: Colors.black, size: 20),
                SizedBox(width: 8),
                Text(
                  'Help',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF8F5FE8).withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(icon, color: selected ? Colors.black : Colors.black, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.black : Colors.black.withOpacity(0.7),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}