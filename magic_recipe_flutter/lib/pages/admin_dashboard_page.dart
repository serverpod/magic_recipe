import 'package:flutter/material.dart';
import 'package:magic_recipe_client/magic_recipe_client.dart';
import 'package:magic_recipe_flutter/main.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<AdminUser> _users = [];
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final users = await client.authAdmin.listUsers();
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
        _loading = false;
      });
    }
  }

  Future<void> _blockUser(UuidValue userId, bool block) async {
    try {
      if (block) {
        await client.authAdmin.blockUser(userId);
      } else {
        await client.authAdmin.unblockUser(userId);
      }
      await _loadUsers();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to ${block ? 'block' : 'unblock'} user: $e';
      });
    }
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final (authUser, userProfile) = _users[index];
                    return ListTile(
                      title: Text(userProfile.email ?? 'No email'),
                      subtitle: Text('ID: ${authUser.id}'),
                      trailing: authUser.blocked == true
                          ? ElevatedButton(
                              onPressed: () => _blockUser(authUser.id, false),
                              child: const Text('Unblock'),
                            )
                          : ElevatedButton(
                              onPressed: () => _blockUser(authUser.id, true),
                              child: const Text('Block'),
                            ),
                    );
                  },
                ),
    );
  }
}

