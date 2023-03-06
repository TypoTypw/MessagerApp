import 'package:flutter/material.dart';
import 'package:chatterbug/model/profileModel.dart';
import 'package:provider/provider.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';
import '../providers/userProvider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String screenID = 'chatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = AuthenticationService();
  final _firestoreServices = firestoreServices();
  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _userProvider.fetchUser();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/icons/defualtIMG.png',
              image: getImgURL(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Center(
          child: (_userProvider.user != null)
              ? Text('${_userProvider.user.name} ${_userProvider.user.surname}')
              : const Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.orangeAccent,
                iconTheme: const IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              onSelected: (itemNumber) => onSelected(context, itemNumber),
              color: Colors.blueGrey,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset('images/close.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(_userProvider.user.name),
      ),
    );
  }

  void onSelected(BuildContext context, int itemNumber) {
    switch (itemNumber) {
      case 0:
        _userProvider.logout();
        Navigator.of(context).pop();
        break;
    }
  }

  String getImgURL() {
    String img = _userProvider.user.imgURL;
    return img;
  }
}
