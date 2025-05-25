import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/dashboard/users'));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedUsers = json.decode(response.body);

      fetchedUsers.sort((a, b) =>
          DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF00131F),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFf25C0FF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final rank = index + 1;

                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    collapsedBackgroundColor: Colors.white.withOpacity(0.05),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(user['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        if (!isMobile)
                          Expanded(
                              child: Text(user['email'],
                                  style: const TextStyle(color: Colors.white70))),
                        if (!isMobile)
                          Expanded(
                              child: Text("Age: ${user['age'] ?? 'N/A'}",
                                  style: const TextStyle(color: Colors.white70))),
                        if (!isMobile)
                          Expanded(
                              child: Text("$rank",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70))),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade800,
                                  backgroundImage: user['image'] != null
                                      ? MemoryImage(base64Decode(user['image']))
                                      : null,
                                  child: user['image'] == null
                                      ? const Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    user['name'],
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text("Email: ${user['email']}",
                                style: const TextStyle(fontSize: 14, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text("Age: ${user['age'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text("Chatbot Messages: ${user['chatbot_messages']}",
                                style: const TextStyle(fontSize: 14, color: Colors.white)),
                            Text("Fluency Analyses: ${user['fluency_analyses']}",
                                style: const TextStyle(fontSize: 14, color: Colors.white)),
                            const SizedBox(height: 8),
                            const Text("Challenges:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            Wrap(
                              spacing: 8,
                              children: List<Widget>.from(
                                user['challenges'].map(
                                  (title) => Chip(
                                    label: Text(title),
                                    backgroundColor: const Color(0xFf25C0FF).withOpacity(0.2),
                                    labelStyle: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
    );
  }
}
