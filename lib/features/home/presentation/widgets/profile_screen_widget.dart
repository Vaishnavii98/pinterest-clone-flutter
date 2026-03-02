import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Your account",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ClerkAuthBuilder(
        builder: (context, authState) {
          final user = authState.user;

          final name = user?.firstName ?? "User";
          final email = user?.emailAddresses?.isNotEmpty == true
              ? user!.emailAddresses!.first.emailAddress
              : "No email";

          final initial = name.isNotEmpty ? name[0].toUpperCase() : "U";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFE60023),
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Settings",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              _buildTile("Account management"),
              _buildTile("Privacy and data"),
              _buildTile("Notifications"),
              _buildTile("Security"),
              _buildTile("Help Centre"),
              _buildTile("About"),

              const SizedBox(height: 30),

              ListTile(
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  authState.signOut();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}