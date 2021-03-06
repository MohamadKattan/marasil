import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:marasil/widget/fullVideo.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marasil/enum/view_state.dart';
import 'package:marasil/model/messages.dart';
import 'package:marasil/model/user.dart';
import 'package:marasil/provider/image_upload_provider.dart';
import 'package:marasil/provider/userProvider.dart';
import 'package:marasil/resources/firebase_method.dart';
import 'package:marasil/resources/firebase_repository.dart';
import 'package:marasil/utils/call_utils.dart';
import 'package:marasil/utils/premission.dart';
import 'package:marasil/utils/universal_variables.dart';
import 'package:marasil/utils/utilities.dart';
import 'package:marasil/widget/cashed_image.dart';
import 'package:marasil/widget/customAppBar.dart';
import 'package:marasil/widget/customTile.dart';
import 'package:marasil/widget/fullImage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:marasil/widget/recordView.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;
  final String messageId;
  ChatScreen({Key key, this.receiver, this.messageId}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController chatEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  AudioPlayer audioPlayer = AudioPlayer();
  IconData playBtn = Icons.play_arrow;
  Duration duration = Duration();
  Duration position = Duration();
  bool isPlaying = false;

  // this bool if user start typing it will show icon send if not icon record and image
  bool isWritting = false;
  // id sender
  User sender;
  UserProvider _userProvider;
  // for show container emoji
  bool showEmojiPicker = false;
  String _currentUser;
  String messageId = Uuid().v4();
  String receiverId;
  String senderId;

  //for call
  ImageUploadProvider _imageUploadProvider;
  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUser = user.uid;
      setState(() {
        // for get id sender
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
        // this for update user sender chatingWith
        FirebaseMethods.firestore
            .collection('users')
            .document(_currentUser)
            .updateData({'chattingWith': widget.receiver.uid});
      });
    });
  }

  //for show or hide keypord if we want to send text or message
  showkeypord() => focusNode.requestFocus();
  hideKeyPord() => focusNode.unfocus();
  // show or hide
  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: customAppBar(context),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewStata == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 5.0),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            controlChats(),
            showEmojiPicker
                ? Container(
                    child: EmojiContainer(),
                  )
                : Container(),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

//customAppBar
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        title: Text(widget.receiver.name),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10, top: 4),
            child: IconButton(
                icon: Icon(
                  Icons.video_call,
                  color: UniversalVariables.blueColor,
                  size: 35,
                ),
                onPressed: () async {
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dial(
                          from: sender, to: widget.receiver, context: context)
                      : {};
                }),
          ),
          // IconButton(icon: Icon(Icons.call), onPressed: () {}),
        ],
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: UniversalVariables.blueColor,
          ),
        ));
  }

// text fiald + iconssend
  Widget controlChats() {
    setWritting(bool val) {
      setState(() {
        isWritting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              addMediaModal(context);
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  focusNode: focusNode,
                  onTap: () => hideEmojiContainer(),
                  controller: chatEditingController,
                  style: TextStyle(color: Colors.white),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != '')
                        ? setWritting(true)
                        : setWritting(false);
                  },
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(color: UniversalVariables.greyColor),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      hideKeyPord();
                      showEmojiContainer();
                    } else {
                      showkeypord();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(
                    Icons.face,
                    color: UniversalVariables.blueColor,
                  ),
                ),
              ],
            ),
          ),
          isWritting
              ? Container()
              : Expanded(
                  flex: 0,
                  child: featureButtonView(
                    receiver: widget.receiver.uid,
                  )),
          SizedBox(
            width: 10,
          ),
          isWritting
              ? Container()
              : GestureDetector(
                  // pickImage(source: ImageSource.camera);
                  onTap: () => buttonSheetToPickER(context),
                  child: Icon(Icons.camera_alt),
                ),
          isWritting
              ? Container(
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  margin: EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                  ))
              : Container(),
        ],
      ),
    );
  }

// this method will show messages in chat screen sender+receiver
  Widget messageList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_currentUser)
            .collection(widget.receiver.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.documents.length,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return chatMessageItem(snapshot.data.documents[index]);
                });
          }
        });
  }

// item chat messages
  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
          alignment: _message.senderId == _currentUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: _message.senderId == _currentUser
              ? senderLayout(_message)
              : receiverLayout(_message)),
    );
  }

// this method for sender side messages
  Widget senderLayout(
    Message message,
  ) {
    Radius messagesRadius = Radius.circular(10);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          margin: EdgeInsets.only(top: 12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.70),
          decoration: BoxDecoration(
              color: UniversalVariables.senderColor,
              borderRadius: BorderRadius.only(
                  topLeft: messagesRadius,
                  topRight: messagesRadius,
                  bottomLeft: messagesRadius)),
          padding: EdgeInsets.all(10),
          child: getMessage(message),
        ),

        // ignore: unrelated_type_equality_checks
        widget.receiver.state != '2'
            ? Icon(
                Icons.check,
                color: Colors.grey,
                size: 10.0,
              )
            // ignore: unrelated_type_equality_checks
            : widget.receiver.state != '1'
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : Text(''),
      ],
    );
  }

  // this method for receiver side messages
  Widget receiverLayout(Message message) {
    Radius messagesRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
              bottomRight: messagesRadius,
              topRight: messagesRadius,
              bottomLeft: messagesRadius)),
      padding: EdgeInsets.all(10),
      child: getMessage(message),
    );
  }

// this method for strat send message and upload
  void sendMessage() {
    var text = chatEditingController.text;
    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: text,
    );
    setState(() {
      isWritting = false;
    });
    //for clean textFialed after send
    chatEditingController.text = '';
    //for code add to fire store
    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  // for get message from snap shot
  getMessage(Message message) {
    // this type 'image 'from upload image in firebase method
    return message.type != 'image' &&
            message.type != 'video' &&
            message.type != 'reVoice'
        ? Text(
            message.message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        : message.photoUrl != null
            ? GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullPhoto(
                            url: message.photoUrl,
                            receiver: widget.receiver.uid,
                            id: messageId,
                            sender: _currentUser))),
                child: CashedImage(
                  imageUrl: message.photoUrl,
                  height: 225,
                  width: 225,
                  radius: 10,
                ),
              )
            : message.video != null
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullVideo(
                                    urlVideo: message.video,
                                    receiver: widget.receiver.uid,
                                    id: messageId,
                                    sender: _currentUser)));
                      },
                      child: Container(
                          color: Colors.green,
                          height:
                              MediaQuery.of(context).size.height * (30 / 100),
                          width: MediaQuery.of(context).size.width * (70 / 100),
                          child: Center(
                              child: Icon(
                            Icons.slow_motion_video_sharp,
                            size: 45.0,
                          ))),
                    ),
                  )
                : message.reVoice != null
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_circle_outline
                                    : Icons.play_arrow,
                                color: UniversalVariables.blueColor,
                              ),
                              onTap: () {
                                getAudio(reVoiceurl: message.reVoice);
                              },
                            ),
                            slider(),
                          ],
                        ),
                      )
                    : Text('');
  }

// this container inCload emoji
  EmojiContainer() {
    return EmojiPicker(
      bgColor: Theme.of(context).primaryColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 10,
      onEmojiSelected: (emoji, catogry) {
        setState(() {
          // for send
          isWritting = true;
        });
        // for send
        chatEditingController.text = chatEditingController.text + emoji.emoji;
      },
      recommendKeywords: ['face', 'happy', 'party', 'sad'],
      numRecommended: 50,
    );
  }

  // this methoed for show buttomSheet for pickImage or video by  camera
  void buttonSheetToPickER(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.close,
                            color: UniversalVariables.blueColor),
                        onPressed: () => Navigator.pop(context)),
                    Text('Share your media',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Flexible(
                  child: Column(
                children: [
                  ModalTile(
                      onTap: () => pickImage(source: ImageSource.camera),
                      title: 'Media',
                      icon: Icons.camera,
                      subTitle: 'Share Image'),
                  ModalTile(
                      onTap: () => pickVideo(source: ImageSource.camera),
                      title: 'Video',
                      icon: Icons.videocam,
                      subTitle: 'Share video'),
                ],
              ))
            ],
          );
        });
  }

  // this methoed for show buttomSheet
  void addMediaModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Share Center',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
              Flexible(
                  child: ListView(
                children: [
                  ModalTile(
                      onTap: () => pickImage(source: ImageSource.gallery),
                      title: 'gallery',
                      icon: Icons.image,
                      subTitle: 'Share Image '),
                  ModalTile(
                      onTap: () => pickVideo(source: ImageSource.gallery),
                      title: 'gallery',
                      icon: Icons.image,
                      subTitle: 'Share video '),
                 
                ],
              ))
            ],
          );
        });
  }

//this method for pick image from camera
  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);

    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid,
      senderId: _currentUser,
      imageProvide: _imageUploadProvider,
      messageId: messageId,
    );
  }

//this method for pick video from camera
  pickVideo({@required ImageSource source}) async {
    // ignore: deprecated_member_use
    File selectedVideo = await Utils.pickVideo(source: source);
    _repository.UploadVideo(
      video: selectedVideo,
      receiverId: widget.receiver.uid,
      senderId: _currentUser,
      imageProvide: _imageUploadProvider,
      messageId: messageId,
    );
  }

//this for delete
  void deleteItimefromFirebase() {
    _repository.deleteImage(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      messageId: messageId,
    );
  }

// for using when playing revoice
  Widget slider() {
    return Slider.adaptive(
      activeColor: UniversalVariables.blueColor,
      inactiveColor: Colors.grey,
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          audioPlayer.seek(value);
        });
      },
    );
  }

  void getAudio({@required String reVoiceurl}) async {
    if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      audioPlayer.play(reVoiceurl, isLocal: false);
      setState(() {
        isPlaying = true;
      });
    }

    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
      });
    });
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;
  ModalTile(
      {this.onTap,
      @required this.title,
      @required this.icon,
      @required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.blueColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//no1cheiwe for play video
class ChewieList extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  ChewieList({
    Key key,
    @required this.videoPlayerController,
    this.looping,
  }) : super(key: key);
  @override
  _ChewieListState createState() => _ChewieListState();
}

//no2cheiwe for play video
class _ChewieListState extends State<ChewieList> {
  ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
              child: Text(errorMessage, style: TextStyle(color: Colors.white)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
