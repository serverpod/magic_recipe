import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:magic_recipe_flutter/main.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

typedef AdminUser = ({AuthUserModel authUser, UserProfileModel userProfile});

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Admin Dashboard'),
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

  List<AdminUser> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      users = await client.admin.listUsers();
      isLoading = false;
      log('Users loaded: $users');
      setState(() {});
    } catch (e) {
      log('Error loading users: $e');
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
          key: ValueKey(user.authUser.id),
          title: Text(user.userProfile.email ?? 'Unknown'),
          subtitle: Text(user.authUser.id.uuid),
          trailing: client.auth.authInfo?.authUserId == user.authUser.id
              ? null
              : BlockUnblockButton(user: user.authUser),
        );
      },
    );
  }
}

class BlockUnblockButton extends StatelessWidget {
  final AuthUserModel user;

  const BlockUnblockButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(user.blocked == true ? Icons.lock : Icons.lock_open),
      onPressed: () async {
        try {
          if (user.blocked == true) {
            await client.admin.unblockUser(user.id);
          } else {
            await client.admin.blockUser(user.id);
          }
          // Reload the user list after blocking/unblocking
          if (context.mounted) {
            (context.findAncestorStateOfType<_UserListState>()
                    as _UserListState)
                .loadUsers();
          }
        } catch (e) {
          log('Error loading users: $e');
          // Always assume that a network call could fail and handle the error
        }
      },
    );
  }
}
