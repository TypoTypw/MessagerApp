import 'package:chatterbug/providers/messageProvider.dart';
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
  late MessageProvider _messageProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _userProvider.fetchUser();

    _messageProvider = Provider.of<MessageProvider>(context);

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
                ? Text(
                    '${_userProvider.user.name} ${_userProvider.user.surname}',
                    style: const TextStyle(color: Colors.white),
                  )
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
                          child: Image.asset('assets/icons/close.png'),
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
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _buildFriendsCards(context),
          ],
        ));
  }

  void onSelected(BuildContext context, int itemNumber) {
    switch (itemNumber) {
      case 0:
        _userProvider.logout();
        Navigator.of(context).pop();
        break;
    }
  }

  Widget _buildFriendsCards(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _userProvider.friendsList.length,
        itemBuilder: (context, i) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            height: 80,
                            width: 80,
                            placeholder: 'assets/icons/defualtIMG.png',
                            image:
                                _userProvider.friendsList.elementAt(i).imgURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          _messageProvider.getMessages(
                              _userProvider.friendsList.elementAt(i).id);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: Colors.black87,
                                    insetPadding: const EdgeInsets.all(10),
                                    content: Builder(builder: (context) {
                                      return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                right: -40.0,
                                                top: -40.0,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 201, 0, 118),
                                                    child: Icon(Icons.close),
                                                  ),
                                                ),
                                              ),
                                              ListView(
                                                children: [
                                                  for (String text
                                                      in allMessages()) ...[
                                                    Text(text),
                                                  ]
                                                ],
                                              ),
                                            ],
                                          ));
                                    }));
                              });
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                          '${_userProvider.friendsList.elementAt(i).name} ${_userProvider.friendsList.elementAt(i).surname}')
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> allMessages() {
    List<String> messages = [];
    _messageProvider.messages.forEach((key, value) {
      messages.add(value);
    });
    print(messages);
    return messages;
  }

  String getImgURL() {
    String img = _userProvider.user.imgURL;
    return img;
  }
}
