import 'dart:collection';

import 'package:chatterbug/providers/messageProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
        shrinkWrap: true,
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
                            image: _userProvider.friendsList
                                        .elementAt(i)
                                        .imgURL !=
                                    "null"
                                ? _userProvider.friendsList.elementAt(i).imgURL
                                : 'assets/icons/defualtIMG.png',
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
                                              150,
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
                                              Column(
                                                children: [
                                                  for (int i = 0;
                                                      i < allMessages().length;
                                                      i++) ...[
                                                    buildChatCard(
                                                        allMessages())[i],
                                                  ],
                                                ],
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              110,
                                                      height: 50,
                                                      child: TextFormField(
                                                        controller:
                                                            _textController,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                        textAlign:
                                                            TextAlign.left,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'Type here',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        201,
                                                                        0,
                                                                        118),
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .indigo,
                                                                    width: 2.0),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Material(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    30.0)),
                                                        elevation: 5.0,
                                                        child: MaterialButton(
                                                          onPressed: () async {
                                                            _firestoreServices
                                                                .sendMessages(
                                                                    _userProvider
                                                                        .friendsList
                                                                        .elementAt(
                                                                            i)
                                                                        .id,
                                                                    _textController
                                                                        .text);
                                                            _textController
                                                                .clear();
                                                          },
                                                          minWidth: 150.0,
                                                          height: 30.0,
                                                          child: const Text(
                                                            'Send',
                                                            style: TextStyle(
                                                                fontSize: 30),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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

  List<List<String>> allMessages() {
    List<List<String>> chatData = [];
    for (Timestamp time in _messageProvider.messages.keys) {
      chatData.add(_messageProvider.messages[time]!);
    }

    return chatData;
  }

  List<Padding> buildChatCard(List<List<String>> messages) {
    List<Padding> chatCards = [];
    for (var element in messages) {
      chatCards.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width - 80,
          child: Align(
            alignment: element[1] == _userProvider.user.id
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              width: 200,
              height: 35,
              child: Card(
                color: element[1] == _userProvider.user.id
                    ? Colors.indigoAccent
                    : const Color.fromARGB(255, 201, 0, 118),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Align(
                    alignment: element[1] == _userProvider.user.id
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      element[0],
                      style: const TextStyle(
                        fontFamily: 'Ariel',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return chatCards;
  }

  String getImgURL() {
    String img = _userProvider.user.imgURL;
    return img;
  }
}
