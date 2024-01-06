import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_application/chat/screen/chat_screen.dart';
import 'package:doctor_application/features/auth/repository/auth_repository.dart';
import 'package:doctor_application/features/group/screens/create_group_screen.dart';
import 'package:doctor_application/model/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthRepository>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text("Create Group"),
                  onTap: () => Future(() =>
                      Navigator.pushNamed(context, CreateGroupScreen.routeName)),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Groups'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _UserList(_auth), // Pass _auth to _UserList
            _GroupList(),
          ],
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final FirebaseAuth _auth;

  _UserList(this._auth); // Receive _auth in the constructor

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(context, doc)) // Pass context
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

class _GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildGroupListItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildGroupListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    Group group = Group.fromMap(data);

    return ListTile(
      title: Text(group.name),
      onTap: () {
        // Handle group item click
        // You can navigate to a group chat screen or perform other actions
      },
    );
  }
}
