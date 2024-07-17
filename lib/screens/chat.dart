import 'package:chat_application/widgets/chat_messages.dart';
import 'package:chat_application/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 void setupPushNotifications() async{
 final fcm = FirebaseMessaging.instance;
  NotificationSettings settings= await fcm.requestPermission(
    alert: true,
      badge: true,
      sound: true,
      provisional: false,
  );
 if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    try {
      // Get the token
      final token = await fcm.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('Error getting FCM token: $e');
    }
     // Handle token refresh
    fcm.onTokenRefresh.listen((newToken) {
      print('FCM Token Refreshed: $newToken');
    });
    fcm.subscribeToTopic('chat');
 }
  @override
  void initState() 
  {
    super.initState();
  
   setupPushNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          },
           icon: Icon(Icons.exit_to_app,
           color: Theme.of(context).colorScheme.primary,)),
        ],
      ),
      body: const  Column (children:
       [
        Expanded(child: ChatMessages(),),
        NewMessage(),
      ],),
    );
  }
}