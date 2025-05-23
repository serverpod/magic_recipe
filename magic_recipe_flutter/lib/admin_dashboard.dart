// magic_recipe/magic_recipe_flutter/lib/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:magic_recipe_client/magic_recipe_client.dart';
import 'package:magic_recipe_flutter/main.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Admin Dashboard'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await client.admin.triggerDeletedRecipeCleanup();
                  },
                  child: const Text('Trigger deleted recipe cleanup'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await client.admin.scheduleDeletedRecipeCleanup();
                  },
                  child: const Text('Schedule deleted recipe cleanup'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await client.admin.stopCleanupTask();
                  },
                  child: const Text('Stop scheduled recipe cleanup'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('List of users'),
            const SizedBox(height: 20),
            Expanded(child: UserList()),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isLoading = true;

  List<UserInfo> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      users = await client.admin.listUsers();
      isLoading = false;
      print('Users loaded: $users');
      setState(() {});
    } catch (e) {
      print('Error loading users: $e');
      // Always assume that a network call could fail and handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          key: ValueKey(user.id),
          title: Text(user.userName ?? 'Unknown'),
          subtitle: Text(user.id?.toString() ?? 'Unknown'),
          trailing: sessionManager.signedInUser?.id == user.id
              ? null
              : BlockUnblockButton(user: user),
        );
      },
    );
  }
}

class BlockUnblockButton extends StatelessWidget {
  final UserInfo user;

  const BlockUnblockButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(user.blocked == true ? Icons.lock : Icons.lock_open),
      onPressed: () async {
        try {
          if (user.blocked == true) {
            await client.admin.unblockUser(user.id!);
          } else {
            await client.admin.blockUser(user.id!);
          }
          // Reload the user list after blocking/unblocking
          if (context.mounted) {
            (context.findAncestorStateOfType<_UserListState>()
                    as _UserListState)
                .loadUsers();
          }
        } catch (e) {
          print('Error loading users: $e');
          // Always assume that a network call could fail and handle the error
        }
      },
    );
  }
}
