import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

class NotifyAllFunction {

  static Future<void> sendNotificationToToken(
      String title,
      String body,
      String token,
      ) async {
    try {
      var server = FirebaseCloudMessagingServer(serviceAccountFileContent);

      var result = await server.send(
        FirebaseSend(
          validateOnly: false,
          message: FirebaseMessage(
            token: token,
            notification: FirebaseNotification(
              title: title,
              body: body,
            ),
            android: FirebaseAndroidConfig(
              ttl: '60s',
              notification: FirebaseAndroidNotification(
                icon: 'ic_notification',
                color: '#009999',
              ),
            ),
          ),
        ),
      );

      print(result.toString());
    }catch(e){
      print(e);
    }
  }
  static Future<void> sendNotificationToUser(
      String userId,
      String title,
      String body,
      ) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get();

    if (!doc.exists) return;

    final token = doc.data()?['fcmToken'];

    if (token == null || token.toString().isEmpty) return;

    await sendNotificationToToken(title, body, token);
  }
  static Future<void> sendNotificationToAllUsers(
      String title,
      String body,
      ) async {
    final snapshot =
    await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snapshot.docs) {
      final token = doc.data()['fcmToken'];
      if (token != null && token.toString().isNotEmpty) {
        await sendNotificationToToken(title, body, token);
      }
    }
  }
  static final serviceAccountFileContent =<String,String>{
    "type": "service_account",
    "project_id": "funsbit",
    "private_key_id": "0dca65da7a93416b45a8f049fb8b3dcc65e0d8a4",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6Qz/I1vfjMIF6\niFzPiYHUa/S2rwZRAgEf57QNyLoL7PUo/ycfm0GJ2dyfx6DQbTuPeYU92HEE+ax6\nk85xNYT7ZbhoeEbimORt3/NmO/vQFuh4JFyFqixd4XNt6zlZmgn8uMO1QNUSpa8V\nwJm0Y1tARRkqcblSkatB1kX+xoapAogWBa44r/zFflxldeIOv1L0yX+F+khkTuaV\nH0oDuPLG+xaVbNThWZTTdahZoNl/QRKXK7eIsaFdgAzMM2SpaAZEvzpuJ9yG6mSt\nwD1/zQDIhIDzZY9Ydo4GodkN9+/bTCLjjM8xUkFNqYW/OiOgtRIEJbH92AgkeSs4\nazla5Vd3AgMBAAECggEAIwMHF1qJKBRzEjRVtdE0LVjJnBlUR5/n1DZ6muizSBCX\nmMg1c3R8okvoc8RTjzopKvP9vr1TqUrBSB1GffNAdv0M595L/MYekiS5nOsDj37u\n3b6AAcQWKON7DhtcIWKaI/4bE5QHOUUZny4f9k+C1Jbofxj3a/TjyzFa4OQyZcw4\nrr/w+bMOjRus793VRCE4j0/4ju5TYhu9/Wr7g7zTPBw1Aag7gBEXrq3vTXxNVRif\njQuJaPvUy0PrMctSgRcHb7twRLCGcPZqT3q7nilUzpEUCWDPF7wp3Gq8znz5mU+j\npGN2inos8735J3bYX8YF8iPIGIII+jJc2PWOUjTw2QKBgQDsCz3YJCfnx3GQE8hS\nV4Pew0aoCpF489laCkEu7a73bSgSX2J4HFJrynkYiywTGYQNArJ1XISko0TBBbe5\nQ++ZS6dfXVEUYLZq14wzMRAPqYa73bKDn00hEtzxJI6ykBvY6W+adXymkiCYcLYV\nU/wXgBj38w3ErroTOo3vW4IGhQKBgQDKApR4uBOe3spxmWB7dIPxsvHAir+Fww+I\nkemz9M2ieOdBL2K4MwzxTjHoHdjxV+DgTlDEj9tSp445GWiwun6rd1b89O88/Xm2\nApHSjfm0toyAWlI3vymEYYrRkU35GwjJEozc/3ttWUjHShGZFSAZaeRoKMuFZJhb\ncJZg9yc8ywKBgCSZsaM8J/vmjxNaHeu2qjn2aZRQ3zG0DfXKNUVDkafIAzimFayu\nJ5GTOae2nMTxZepmiqlsCR1GO7j6W/ycLiDE/FTrMVFJlb+HYLPnXagwDzY+MBn8\nr4b7V8sEciP5+Hdv6uA2a3egnPFGONWhyisSr8xyoaXnue6VW8DLnaPJAoGAQ3IT\nEi8bVeq6mq0D2pQvTW5aateoVEepEwbsiUnNslY9l7Tzd96LjrF11jLI8ONPUHS1\nYLtLFdCdmpDSNFc/3Y3NvE0m5y0WCt/Wwf7nBSABzwTY+IXZnbpXd9rUtrwA9ek8\noLioA/1QYEFpmLvF6NZDDUe5k8LfX4A6pQs/zXsCgYEAwFLLh6IrNvyqqYVakMlb\nXTyFIuD65IiulKrdO9fSBpqQqmNkcsITkAyJipXBEtWxK5MgHymSVpjEbrwnIXSH\n9J+IxcR+38AJVR8l9Vv4gU8kab3qqHCUzzR1fUeTxMZ5w6QDukZxqi02TJ8iOyph\nwHi+xbRVN4SzaQC9rpDi7E0=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-fbsvc@funsbit.iam.gserviceaccount.com",
    "client_id": "108599137568082819020",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40funsbit.iam.gserviceaccount.com",
  };
}