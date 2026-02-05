import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Announcment extends StatelessWidget {
  final bool my;
  const Announcment({super.key,required this.my});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, my?"My Notifications":"Announcement"),
          SizedBox(height: 15,),
          Flexible(
            child:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No announcements yet'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isGame = data['game'] ?? false;
                    final String title = data['title'] ?? '';
                    final String desc = data['description'] ?? '';
                    final Timestamp time = data['time'];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isGame
                                        ? Colors.deepPurple.withOpacity(0.15)
                                        : Colors.blue.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isGame
                                            ? Icons.sports_esports
                                            : Icons.campaign,
                                        size: 16,
                                        color: isGame
                                            ? Colors.deepPurple
                                            : Colors.blue,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isGame ? 'Game' : 'System',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isGame
                                              ? Colors.deepPurple
                                              : Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  formatTime(time),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
  String formatTime(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('d MMM, h:mm a').format(dateTime).toLowerCase();
  }
}
