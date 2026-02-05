import 'package:earning_app/global/widget.dart';
import 'package:earning_app/model/notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

import '../model/usermodel.dart';
class NotifyAllUsersPage extends StatefulWidget {
  const NotifyAllUsersPage({Key? key}) : super(key: key);

  @override
  State<NotifyAllUsersPage> createState() => _NotifyAllUsersPageState();
}

class _NotifyAllUsersPageState extends State<NotifyAllUsersPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isYes = false;

  bool _isLoading = false;

  Future<void> _sendNotification() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      print(":wekbcdjukbibc");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Description are required')),
      );
      return ;
    }
    print("oghehiogfewibufcea");

    setState(() => _isLoading = true);

    try {
      await NotifyAll.sendNotificationsCustomer(title, description, "svyuhjavdxayvcvyua");
      NotifyAll.FirebaseSave(title, description,isYes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );

      _titleController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Send Announcements"),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Notification Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Notification Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                SwitchListTile(
              title: const Text('Is it an Game Announcement ?'),
              subtitle: Text(isYes ? 'Yes' : 'No'),
              value: isYes,
              onChanged: (value) {
                setState(() {
                  isYes = value;
                });
              },
            ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendNotification,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send Notification'),
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





class NotifyAll{

  static FirebaseSave(String title, String desc, bool game) async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    final notification = NotificationFunction(
      game: game,
      id: id,
      title: title,
      description: desc,
      notification: false,
      userId: "",
      time: DateTime.now(),
      coins: 0,
    );

    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  static  sendNotificationsCustomer(String name, String desc,String id) async {
    try{
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      print("gewts");

      List<String> tokens = [];
      print(tokens);

      // Extract tokens from the fetched documents
      // Extract tokens from the fetched documents
      usersSnapshot.docs.forEach((doc) {
        // Explicitly cast doc.data() to Map<String, dynamic>
        var data = doc.data() as Map<String, dynamic>;

        var user = UserModel.fromMap(data); // Assuming UserModel.fromJson correctly initializes from Map
        print(data);
        if (user.tokens.isNotEmpty) {
          print(user.tokens);

          tokens.add(user.tokens);
        }
      });
      await sendNotificationsCompany(name, desc, tokens);
    }catch(e){
      print(e);
    }
  }

  static Future<void> sendNotificationsCompany(
      String title,
      String body,
      List<String> tokens,
      ) async {
    final server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );

    for (final token in tokens) {
      try {
        final result = await server.send(
          FirebaseSend(
            validateOnly: false,
            message: FirebaseMessage(
              token: token,
              notification: FirebaseNotification(
                title: title,
                body: body,
              ),
              android: FirebaseAndroidConfig(
                priority: AndroidMessagePriority.high
              ),
            ),
          ),
        );

        print('✅ Sent → ${result.statusCode}');
      } catch (e) {
        print('❌ Error → $e');
      }
    }
  }





  static final serviceAccountFileContent = <String, String>{
    'type': 'service_account',
    'project_id': 'funsbit',
    'private_key_id': '0dca65da7a93416b45a8f049fb8b3dcc65e0d8a4',
    'private_key': '-----BEGIN PRIVATE KEY-----\n'
        'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6Qz/I1vfjMIF6\n'
        'iFzPiYHUa/S2rwZRAgEf57QNyLoL7PUo/ycfm0GJ2dyfx6DQbTuPeYU92HEE+ax6\n'
        'k85xNYT7ZbhoeEbimORt3/NmO/vQFuh4JFyFqixd4XNt6zlZmgn8uMO1QNUSpa8V\n'
        'wJm0Y1tARRkqcblSkatB1kX+xoapAogWBa44r/zFflxldeIOv1L0yX+F+khkTuaV\n'
        'H0oDuPLG+xaVbNThWZTTdahZoNl/QRKXK7eIsaFdgAzMM2SpaAZEvzpuJ9yG6mSt\n'
        'wD1/zQDIhIDzZY9Ydo4GodkN9+/bTCLjjM8xUkFNqYW/OiOgtRIEJbH92AgkeSs4\n'
        'azla5Vd3AgMBAAECggEAIwMHF1qJKBRzEjRVtdE0LVjJnBlUR5/n1DZ6muizSBCX\n'
        'mMg1c3R8okvoc8RTjzopKvP9vr1TqUrBSB1GffNAdv0M595L/MYekiS5nOsDj37u\n'
        '3b6AAcQWKON7DhtcIWKaI/4bE5QHOUUZny4f9k+C1Jbofxj3a/TjyzFa4OQyZcw4\n'
        'rr/w+bMOjRus793VRCE4j0/4ju5TYhu9/Wr7g7zTPBw1Aag7gBEXrq3vTXxNVRif\n'
        'jQuJaPvUy0PrMctSgRcHb7twRLCGcPZqT3q7nilUzpEUCWDPF7wp3Gq8znz5mU+j\n'
        'pGN2inos8735J3bYX8YF8iPIGIII+jJc2PWOUjTw2QKBgQDsCz3YJCfnx3GQE8hS\n'
        'V4Pew0aoCpF489laCkEu7a73bSgSX2J4HFJrynkYiywTGYQNArJ1XISko0TBBbe5\n'
        'Q++ZS6dfXVEUYLZq14wzMRAPqYa73bKDn00hEtzxJI6ykBvY6W+adXymkiCYcLYV\n'
        'U/wXgBj38w3ErroTOo3vW4IGhQKBgQDKApR4uBOe3spxmWB7dIPxsvHAir+Fww+I\n'
        'kemz9M2ieOdBL2K4MwzxTjHoHdjxV+DgTlDEj9tSp445GWiwun6rd1b89O88/Xm2\n'
        'ApHSjfm0toyAWlI3vymEYYrRkU35GwjJEozc/3ttWUjHShGZFSAZaeRoKMuFZJhb\n'
        'cJZg9yc8ywKBgCSZsaM8J/vmjxNaHeu2qjn2aZRQ3zG0DfXKNUVDkafIAzimFayu\n'
        'J5GTOae2nMTxZepmiqlsCR1GO7j6W/ycLiDE/FTrMVFJlb+HYLPnXagwDzY+MBn8\n'
        'r4b7V8sEciP5+Hdv6uA2a3egnPFGONWhyisSr8xyoaXnue6VW8DLnaPJAoGAQ3IT\n'
        'Ei8bVeq6mq0D2pQvTW5aateoVEepEwbsiUnNslY9l7Tzd96LjrF11jLI8ONPUHS1\n'
        'YLtLFdCdmpDSNFc/3Y3NvE0m5y0WCt/Wwf7nBSABzwTY+IXZnbpXd9rUtrwA9ek8\n'
        'oLioA/1QYEFpmLvF6NZDDUe5k8LfX4A6pQs/zXsCgYEAwFLLh6IrNvyqqYVakMlb\n'
        'XTyFIuD65IiulKrdO9fSBpqQqmNkcsITkAyJipXBEtWxK5MgHymSVpjEbrwnIXSH\n'
        '9J+IxcR+38AJVR8l9Vv4gU8kab3qqHCUzzR1fUeTxMZ5w6QDukZxqi02TJ8iOyph\n'
        'wHi+xbRVN4SzaQC9rpDi7E0=\n'
        '-----END PRIVATE KEY-----\n',
    'client_email': 'firebase-adminsdk-fbsvc@funsbit.iam.gserviceaccount.com',
    'client_id': '108599137568082819020',
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url':
    'https://www.googleapis.com/oauth2/v1/certs',
    'client_x509_cert_url':
    'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40funsbit.iam.gserviceaccount.com',
  };

}