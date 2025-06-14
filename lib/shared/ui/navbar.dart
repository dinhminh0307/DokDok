import 'package:fluent_ui/fluent_ui.dart';

class Navbar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int notificationCount;

  const Navbar({
    super.key,
    required this.userName,
    required this.userEmail,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: FluentTheme.of(context).micaBackgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [

          const SizedBox(width: 16),
          // Dashboard title
          const Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(width: 32),
          // Search box
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextBox(
                placeholder: 'Search...',
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(FluentIcons.search),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Notification bell with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.ringer),
                onPressed: () {},
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // User avatar and info
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.purple,
            child: Text(
              userName.isNotEmpty
                  ? userName.trim().split(' ').map((e) => e[0]).take(2).join()
                  : '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  color: Colors.grey[90],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Dropdown arrow
          const Icon(FluentIcons.chevron_down, size: 18),
        ],
      ),
    );
  }
}