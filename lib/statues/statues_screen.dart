// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:provider/provider.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Calling/voice_calling/Observer.dart';
// import '../Calling/voice_calling/optional_constants.dart';
// import '../ModelClasses/DataModel.dart';
// import '../constant/Dbkeys.dart';
// import '../constant/Dbpaths.dart';
// import '../constant/firebase_auth_constant.dart';
// import '../utils.dart';
// import 'AvailableContactsProvider.dart';
// import 'StatusProvider.dart';
// import 'StatusView.dart';
// import 'TextStatus/textStatus.dart';
// import 'VideoPicker/VideoPicker.dart';
// import 'components/ImagePicker/image_picker.dart';
// import 'components/circleBorder.dart';
// import 'components/formatStatusTime.dart';
// import 'components/showViewers.dart';
// class Status extends StatefulWidget {
//   const Status({
//     required this.currentUserNo,
//     required this.model,
//  //   required this.biometricEnabled,
//   //  required this.prefs,
//   //  required this.phoneNumberVariants,
//     required this.currentUserFullname,
//     required this.currentUserPhotourl,
//   });
//   final String? currentUserNo;
//   final String? currentUserFullname;
//   final String? currentUserPhotourl;
//   final DataModel? model;
//  // final SharedPreferences prefs;
//
//   //final bool biometricEnabled;
//  // final List phoneNumberVariants;
//
//   @override
//   _StatusState createState() => new _StatusState();
// }
// class _StatusState extends State<Status> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   loading() {
//     return Stack(children: [
//       Container(
//         child: Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue),
//             )),
//       )
//     ]);
//   }
//
//   late Stream myStatusUpdates;
//
//   @override
//   initState() {
//     super.initState();
//     myStatusUpdates = FirebaseFirestore.instance
//         .collection(DbPaths.collectionnstatus)
//         .doc(widget.currentUserNo)
//         .snapshots();
//
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       final observer = Provider.of<Observer>(this.context, listen: false);
//
//     });
//   }
//
//
//   uploadFile(
//       {required File file,
//         String? caption,
//         double? duration,
//         required String type,
//         required String filename}) async {
//     final observer = Provider.of<Observer>(context, listen: false);
//     final StatusProvider statusProvider =
//     Provider.of<StatusProvider>(context, listen: false);
//     statusProvider.setIsLoading(true);
//     int uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
//
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child('+00_STATUS_MEDIA/${widget.currentUserNo}/$filename');
//     await reference.putFile(file).then((uploadTask) async {
//       String url = await uploadTask.ref.getDownloadURL();
//       FirebaseFirestore.instance
//           .collection(DbPaths.collectionnstatus)
//           .doc(widget.currentUserNo)
//           .set({
//         Dbkeys.statusITEMSLIST: FieldValue.arrayUnion([
//           type == Dbkeys.statustypeVIDEO
//               ? {
//             Dbkeys.statusItemID: uploadTimestamp,
//             Dbkeys.statusItemURL: url,
//             Dbkeys.statusItemTYPE: type,
//             Dbkeys.statusItemCAPTION: caption,
//             Dbkeys.statusItemDURATION: duration,
//           }
//               : {
//             Dbkeys.statusItemID: uploadTimestamp,
//             Dbkeys.statusItemURL: url,
//             Dbkeys.statusItemTYPE: type,
//             Dbkeys.statusItemCAPTION: caption,
//           }
//         ]),
//         Dbkeys.statusPUBLISHERPHONE: widget.currentUserNo,
//        // Dbkeys.statusPUBLISHERPHONEVARIANTS: widget.phoneNumberVariants,
//         Dbkeys.statusVIEWERLIST: [],
//         Dbkeys.statusVIEWERLISTWITHTIME: [],
//         Dbkeys.statusPUBLISHEDON: DateTime.now(),
//         // uploadTimestamp,
//         Dbkeys.statusEXPIRININGON: DateTime.now()
//             .add(Duration(hours: observer.statusDeleteAfterInHours)),
//         // .millisecondsSinceEpoch,
//       }, SetOptions(merge: true)).then((value) {
//         statusProvider.setIsLoading(false);
//       });
//     }).onError((error, stackTrace) {
//       statusProvider.setIsLoading(false);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final observer = Provider.of<Observer>(context, listen: true);
//     final contactsProvider =
//     Provider.of<AvailableContactsProvider>(context, listen: true);
//     return Fiberchat.getNTPWrappedWidget(ScopedModel<DataModel>(
//         model: widget.model!,
//         child:
//         ScopedModelDescendant<DataModel>(builder: (context, child, model) {
//           return Scaffold(
//             backgroundColor: fiberchatWhite,
//             floatingActionButton: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 43,
//                   margin: EdgeInsets.only(bottom: 18),
//                   child: FloatingActionButton(
//                       backgroundColor: Color(0xffebecee),
//                       child: Icon(Icons.edit,
//                           size: 23.0, color: Colors.blueGrey[700]),
//                       onPressed: observer.isAllowCreatingStatus == false
//                           ? () {
//                         Text( 'disabled');
//                       }
//                           : () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => TextStatus(
//                                     currentuserNo:
//                                     widget.currentUserNo!,
//                                   //  phoneNumberVariants: widget.phoneNumberVariants
//                                 )));
//                       }),
//                 ),
//                 FloatingActionButton(
//                   backgroundColor: fiberchatLightGreen,
//                   child: Icon(
//                     Icons.camera_alt_rounded,
//                     size: 25,
//                   ),
//                   onPressed: observer.isAllowCreatingStatus == false
//                       ? () {
//                     Text( 'disabled');
//                   }
//                       : () async {
//                     showMediaOptions(
//                         ishideTextStatusbutton: true,
//                       //  phoneVariants: widget.phoneNumberVariants,
//                         context: context,
//                         pickVideoCallback: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       StatusVideoEditor(
//                                         callback: (v, d, t) async {
//                                           Navigator.of(context).pop();
//                                           await uploadFile(
//                                               filename: DateTime.now()
//                                                   .millisecondsSinceEpoch
//                                                   .toString(),
//                                               type: Dbkeys
//                                                   .statustypeVIDEO,
//                                               file: d,
//                                               caption: v,
//                                               duration: t);
//                                         },
//                                         title: 'createstatus',
//                                       )));
//                         },
//                         pickImageCallback: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       StatusImageEditor(
//                                         callback: (v, d) async {
//                                           Navigator.of(context).pop();
//                                           await uploadFile(
//                                               filename: DateTime.now()
//                                                   .millisecondsSinceEpoch
//                                                   .toString(),
//                                               type: Dbkeys
//                                                   .statustypeIMAGE,
//                                               file: d,
//                                               caption: v);
//                                         },
//                                         title:  'createstatus',
//                                       )));
//                         });
//                   },
//                 ),
//               ],
//             ),
//             body: RefreshIndicator(
//               onRefresh: () {
//                 final statusProvider =
//                 Provider.of<StatusProvider>(context, listen: false);
//                 final contactsProvider = Provider.of<AvailableContactsProvider>(
//                     context,
//                     listen: false);
//                 statusProvider.searchContactStatus(widget.currentUserNo!,
//                     contactsProvider.joinedUserPhoneStringAsInServer);
//                 return Future.value(true);
//               },
//               child: Consumer<StatusProvider>(
//                   builder: (context, statusProvider, _child) => Stack(
//                     children: [
//                       Container(
//                         color: Color(0xfff2f2f2),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             StreamBuilder(
//                                 stream: myStatusUpdates,
//                                 builder:
//                                     (context, AsyncSnapshot snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Card(
//                                       color: Colors.white,
//                                       elevation: 0.0,
//                                       child: Padding(
//                                           padding:
//                                           const EdgeInsets.fromLTRB(
//                                               0, 8, 8, 8),
//                                           child: InkWell(
//                                             onTap: () {},
//                                             child: ListTile(
//                                               leading: Stack(
//                                                 children: <Widget>[
//                                                   customCircleAvatar(
//                                                       radius: 35),
//                                                   Positioned(
//                                                     bottom: 1.0,
//                                                     right: 1.0,
//                                                     child: Container(
//                                                       height: 20,
//                                                       width: 20,
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         color:
//                                                         Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         color:
//                                                         Colors.green,
//                                                         shape: BoxShape
//                                                             .circle,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               title: Text( 'mystatus',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               ),
//                                               subtitle: Text('loading',
//                                               ),
//                                             ),
//                                           )),
//                                     );
//                                   } else if (snapshot.hasData &&
//                                       snapshot.data.exists) {
//                                     int seen = !snapshot.data
//                                         .data()
//                                         .containsKey(
//                                         widget.currentUserNo)
//                                         ? 0
//                                         : 0;
//                                     if (snapshot.data.data().containsKey(
//                                         widget.currentUserNo)) {
//                                       snapshot
//                                           .data[Dbkeys.statusITEMSLIST]
//                                           .forEach((status) {
//                                         if (snapshot
//                                             .data[widget.currentUserNo]
//                                             .contains(status[
//                                         Dbkeys.statusItemID])) {
//                                           seen = seen + 1;
//                                         }
//                                       });
//                                     }
//
//                                     return Card(
//                                       color: Colors.white,
//                                       elevation: 0.0,
//                                       child: Padding(
//                                         padding:
//                                         const EdgeInsets.fromLTRB(
//                                             3, 8, 8, 8),
//                                         child: ListTile(
//                                           leading: Stack(
//                                             children: <Widget>[
//                                               InkWell(
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder:
//                                                               (context) =>
//                                                               StatusView(
//                                                                 currentUserNo:
//                                                                 widget.currentUserNo!,
//                                                                 statusDoc:
//                                                                 snapshot.data,
//                                                                 postedbyFullname:
//                                                                 widget.currentUserFullname ?? '',
//                                                                 postedbyPhotourl:
//                                                                 widget.currentUserPhotourl,
//                                                               )));
//                                                 },
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(left: 0),
//                                                   child: CircularBorder(
//                                                     totalitems: snapshot
//                                                         .data[Dbkeys
//                                                         .statusITEMSLIST]
//                                                         .length,
//                                                     totalseen: seen,
//                                                     width: 2.5,
//                                                     size: 65,
//                                                     color: snapshot.data
//                                                         .data()
//                                                         .containsKey(
//                                                         widget
//                                                             .currentUserNo) ==
//                                                         true
//                                                         ? snapshot
//                                                         .data[Dbkeys
//                                                         .statusITEMSLIST]
//                                                         .length >
//                                                         0
//                                                         ? Colors.teal
//                                                         .withOpacity(
//                                                         0.8)
//                                                         : Colors.grey
//                                                         .withOpacity(
//                                                         0.8)
//                                                         : Colors.grey
//                                                         .withOpacity(
//                                                         0.8),
//                                                     icon: Padding(
//                                                       padding:
//                                                       const EdgeInsets
//                                                           .all(3.0),
//                                                       child:
//                                                       snapshot.data[Dbkeys.statusITEMSLIST]
//                                                       [
//                                                       snapshot.data[Dbkeys.statusITEMSLIST].length -
//                                                           1][Dbkeys
//                                                           .statusItemTYPE] ==
//                                                           Dbkeys
//                                                               .statustypeTEXT
//                                                           ? Container(
//                                                         width:
//                                                         50.0,
//                                                         height:
//                                                         50.0,
//                                                         child: Icon(
//                                                             Icons
//                                                                 .text_fields,
//                                                             color:
//                                                             Colors.white54),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Color(int.parse(
//                                                               snapshot.data[Dbkeys.statusITEMSLIST][snapshot.data[Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemBGCOLOR],
//                                                               radix: 16)),
//                                                           shape:
//                                                           BoxShape.circle,
//                                                         ),
//                                                       )
//                                                           : snapshot.data[Dbkeys.statusITEMSLIST][snapshot.data[Dbkeys.statusITEMSLIST].length -
//                                                           1][Dbkeys.statusItemTYPE] ==
//                                                           Dbkeys.statustypeVIDEO
//                                                           ? Container(
//                                                         width:
//                                                         50.0,
//                                                         height:
//                                                         50.0,
//                                                         child:
//                                                         Icon(Icons.play_circle_fill_rounded, color: Colors.white54),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors.black87,
//                                                           shape: BoxShape.circle,
//                                                         ),
//                                                       )
//                                                           : CachedNetworkImage(
//                                                         imageUrl:
//                                                         snapshot.data[Dbkeys.statusITEMSLIST][snapshot.data[Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemURL],
//                                                         imageBuilder: (context, imageProvider) =>
//                                                             Container(
//                                                               width: 50.0,
//                                                               height: 50.0,
//                                                               decoration: BoxDecoration(
//                                                                 shape: BoxShape.circle,
//                                                                 image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//                                                               ),
//                                                             ),
//                                                         placeholder: (context, url) =>
//                                                             Container(
//                                                               width: 50.0,
//                                                               height: 50.0,
//                                                               decoration: BoxDecoration(
//                                                                 color: Colors.grey[300],
//                                                                 shape: BoxShape.circle,
//                                                               ),
//                                                             ),
//                                                         errorWidget: (context, url, error) =>
//                                                             Container(
//                                                               width: 50.0,
//                                                               height: 50.0,
//                                                               decoration: BoxDecoration(
//                                                                 color: Colors.grey[300],
//                                                                 shape: BoxShape.circle,
//                                                               ),
//                                                             ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 bottom: 1.0,
//                                                 right: 1.0,
//                                                 child: InkWell(
//                                                   onTap:
//                                                   observer.isAllowCreatingStatus ==
//                                                       false
//                                                       ? () {
//                                                     Text(
//                                                         'disabled');
//                                                   }
//                                                       : () async {
//                                                     showMediaOptions(
//                                                         ishideTextStatusbutton:
//                                                         false,
//                                                         // phoneVariants: widget.phoneNumberVariants,
//                                                         context:
//                                                         context,
//                                                         pickVideoCallback:
//                                                             () {
//                                                           Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) => StatusVideoEditor(
//                                                                     callback: (v, d, t) async {
//                                                                       Navigator.of(context).pop();
//                                                                       await uploadFile(filename: DateTime.now().millisecondsSinceEpoch.toString(), type: Dbkeys.statustypeVIDEO, file: d, caption: v, duration: t);
//                                                                     },
//                                                                     title: 'createstatus',
//                                                                   )));
//                                                         },
//                                                         pickImageCallback:
//                                                             () {
//                                                           Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) => StatusImageEditor(
//                                                                     callback: (v, d) async {
//                                                                       Navigator.of(context).pop();
//                                                                       await uploadFile(filename: DateTime.now().millisecondsSinceEpoch.toString(), type: Dbkeys.statustypeIMAGE, file: d, caption: v);
//                                                                     },
//                                                                     title:  'createstatus',
//                                                                   )));
//                                                         });
//                                                   },
//                                                   child: Container(
//                                                     height: 20,
//                                                     width: 20,
//                                                     child: Icon(
//                                                       Icons.add,
//                                                       color: Colors.white,
//                                                       size: 15,
//                                                     ),
//                                                     decoration:
//                                                     BoxDecoration(
//                                                       color: Colors.green,
//                                                       shape:
//                                                       BoxShape.circle,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           title: InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder:
//                                                           (context) =>
//                                                           StatusView(
//                                                             currentUserNo:
//                                                             widget
//                                                                 .currentUserNo!,
//                                                             statusDoc:
//                                                             snapshot
//                                                                 .data,
//                                                             postedbyFullname:
//                                                             widget.currentUserFullname ??
//                                                                 '',
//                                                             postedbyPhotourl:
//                                                             widget
//                                                                 .currentUserPhotourl,
//                                                           )));
//                                             },
//                                             child: Text( 'mystatus',
//                                               style: TextStyle(
//                                                   fontWeight:
//                                                   FontWeight.bold),
//                                             ),
//                                           ),
//                                           subtitle: InkWell(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder:
//                                                             (context) =>
//                                                             StatusView(
//                                                               currentUserNo:
//                                                               widget.currentUserNo!,
//                                                               statusDoc:
//                                                               snapshot.data,
//                                                               postedbyFullname:
//                                                               widget.currentUserFullname ??
//                                                                   '',
//                                                               postedbyPhotourl:
//                                                               widget.currentUserPhotourl,
//                                                             )));
//                                               },
//                                               child: Text('taptoview',
//                                                 style: TextStyle(
//                                                     fontSize: 14),
//                                               )),
//                                           trailing: Container(
//                                             alignment:
//                                             Alignment.centerRight,
//                                             width: 90,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceBetween,
//                                               children: [
//                                                 InkWell(
//                                                   onTap: snapshot
//                                                       .data[Dbkeys
//                                                       .statusVIEWERLISTWITHTIME]
//                                                       .length >
//                                                       0
//                                                       ? () {
//                                                     showViewers(
//                                                         context,
//                                                         snapshot
//                                                             .data,
//                                                         contactsProvider
//                                                             .filtered);
//                                                   }
//                                                       : () {},
//                                                   child: Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .visibility),
//                                                       SizedBox(
//                                                         width: 2,
//                                                       ),
//                                                       Text(
//                                                         ' ${snapshot.data[Dbkeys.statusVIEWERLIST].length}',
//                                                         style: TextStyle(
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .normal),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     deleteOptions(context,
//                                                         snapshot.data);
//                                                   },
//                                                   child: SizedBox(
//                                                       width: 25,
//                                                       child: Icon(
//                                                           Icons.edit)),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   } else if (!snapshot.hasData ||
//                                       !snapshot.data.exists) {
//                                     return Card(
//                                       color: Colors.white,
//                                       elevation: 0.0,
//                                       child: Padding(
//                                           padding:
//                                           const EdgeInsets.fromLTRB(
//                                               0, 8, 8, 8),
//                                           child: InkWell(
//                                             onTap:
//                                             observer.isAllowCreatingStatus ==
//                                                 false
//                                                 ? () {
//                                               Fiberchat.showRationale(
//                                                       'disabled');
//                                             }
//                                                 : () {
//                                               showMediaOptions(
//                                                   ishideTextStatusbutton:
//                                                   false,
//                                                   // phoneVariants: widget.phoneNumberVariants,
//                                                   context:
//                                                   context,
//                                                   pickVideoCallback:
//                                                       () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) => StatusVideoEditor(
//                                                               callback: (v, d, t) async {
//                                                                 Navigator.of(context).pop();
//                                                                 await uploadFile(duration: t, filename: DateTime.now().millisecondsSinceEpoch.toString(), type: Dbkeys.statustypeVIDEO, file: d, caption: v);
//                                                               },
//                                                               title:'createstatus',
//                                                             )));
//                                                   },
//                                                   pickImageCallback:
//                                                       () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) => StatusImageEditor(
//                                                               callback: (v, d) async {
//                                                                 Navigator.of(context).pop();
//                                                                 await uploadFile(filename: DateTime.now().millisecondsSinceEpoch.toString(), type: Dbkeys.statustypeIMAGE, file: d, caption: v);
//                                                               },
//                                                               title:  'createstatus',
//                                                             )));
//                                                   });
//                                             },
//                                             child: ListTile(
//                                               leading: Stack(
//                                                 children: <Widget>[
//                                                   customCircleAvatar(
//                                                       radius: 35),
//                                                   Positioned(
//                                                     bottom: 1.0,
//                                                     right: 1.0,
//                                                     child: Container(
//                                                       height: 20,
//                                                       width: 20,
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         color:
//                                                         Colors.white,
//                                                         size: 15,
//                                                       ),
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         color:
//                                                         Colors.green,
//                                                         shape: BoxShape
//                                                             .circle,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               title: Text( 'mystatus',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               ),
//                                               subtitle: Text(
//                                                     'taptoupdtstatus',
//                                                 style: TextStyle(
//                                                     fontSize: 14),
//                                               ),
//                                             ),
//                                           )),
//                                     );
//                                   }
//                                   return Card(
//                                     color: Colors.white,
//                                     elevation: 0.0,
//                                     child: Padding(
//                                         padding:
//                                         const EdgeInsets.fromLTRB(
//                                             0, 8, 8, 8),
//                                         child: InkWell(
//                                           onTap: () {},
//                                           child: ListTile(
//                                             leading: Stack(
//                                               children: <Widget>[
//                                                 customCircleAvatar(
//                                                     radius: 35),
//                                                 Positioned(
//                                                   bottom: 1.0,
//                                                   right: 1.0,
//                                                   child: Container(
//                                                     height: 20,
//                                                     width: 20,
//                                                     child: Icon(
//                                                       Icons.add,
//                                                       color: Colors.white,
//                                                       size: 15,
//                                                     ),
//                                                     decoration:
//                                                     BoxDecoration(
//                                                       color: Colors.green,
//                                                       shape:
//                                                       BoxShape.circle,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             title: Text('mystatus',
//                                               style: TextStyle(
//                                                   fontWeight:
//                                                   FontWeight.bold),
//                                             ),
//                                             subtitle: Text('loading',
//                                             ),
//                                           ),
//                                         )),
//                                   );
//                                 }),
//                             Padding(
//                               padding:
//                               const EdgeInsets.fromLTRB(12, 8, 8, 8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                                 children: [
//                                   Text('rcntupdates',
//                                     style: TextStyle(
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     width: 13,
//                                   ),
//                                   statusProvider
//                                       .searchingcontactsstatus ==
//                                       true
//                                       ? Container(
//                                       margin:
//                                       EdgeInsets.only(right: 17),
//                                       height: 15,
//                                       width: 15,
//                                       child: Center(
//                                         child: Padding(
//                                           padding:
//                                           EdgeInsets.only(top: 0),
//                                           child: CircularProgressIndicator(
//                                               strokeWidth: 1.5,
//                                               valueColor:
//                                               AlwaysStoppedAnimation<
//                                                   Color>(
//                                                   fiberchatBlue)),
//                                         ),
//                                       ),
//                                       color: Colors.transparent)
//                                       : SizedBox()
//                                 ],
//                               ),
//                             ),
//                             statusProvider.searchingcontactsstatus == true
//                                 ? Expanded(
//                               child: Container(color: Colors.white),
//                             )
//                                 : statusProvider.contactsStatus.length ==
//                                 0
//                                 ? Expanded(
//                               child: Container(
//                                   child: Center(
//                                     child: Padding(
//                                         padding:
//                                         EdgeInsets.only(
//                                             top: 40,
//                                             left: 25,
//                                             right: 25,
//                                             bottom: 70),
//                                         child: Text(
//                                               'nostatus',
//                                           textAlign:
//                                           TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 15.0,
//                                               color: fiberchatGrey
//                                                   .withOpacity(
//                                                   0.8),
//                                               fontWeight:
//                                               FontWeight
//                                                   .w400),
//                                         )),
//                                   ),
//                                   color: Colors.white),
//                             )
//                                 : Expanded(
//                               child: Container(
//                                   padding:
//                                   const EdgeInsets.fromLTRB(
//                                       0, 8, 8, 8),
//                                   color: Colors.white,
//                                   child: ListView.builder(
//                                     padding: EdgeInsets.all(10),
//                                     itemCount: statusProvider
//                                         .contactsStatus.length,
//                                     itemBuilder:
//                                         (context, idx) {
//                                       int seen = !statusProvider
//                                           .contactsStatus[
//                                       idx]
//                                           .data()!
//                                           .containsKey(widget
//                                           .currentUserNo)
//                                           ? 0
//                                           : 0;
//                                       if (statusProvider
//                                           .contactsStatus[idx]
//                                           .data()
//                                           .containsKey(widget
//                                           .currentUserNo)) {
//                                         statusProvider
//                                             .contactsStatus[idx]
//                                         [Dbkeys
//                                             .statusITEMSLIST]
//                                             .forEach((status) {
//                                           if (statusProvider
//                                               .contactsStatus[
//                                           idx]
//                                               .data()[widget
//                                               .currentUserNo]
//                                               .contains(status[
//                                           Dbkeys
//                                               .statusItemID])) {
//                                             seen = seen + 1;
//                                           }
//                                         });
//                                       }
//                                       return Consumer<AvailableContactsProvider>(
//                                           builder: (context, contactsProvider, _child) =>
//                                               FutureBuilder<
//                                                   DocumentSnapshot>(
//                                                   future: contactsProvider.getUserDoc(
//                                                       statusProvider.contactsStatus[idx].data()[Dbkeys.statusPUBLISHERPHONE]),
//                                                   builder: (BuildContext
//                                                   context, AsyncSnapshot snapshot) {
//                                                     if (snapshot.hasData && snapshot.data.exists) {
//                                                       return InkWell(
//                                                         onTap:
//                                                             () {
//                                                           Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) => StatusView(
//                                                                     callback: (statuspublisherphone) {
//                                                                       FirebaseFirestore.instance.collection(DbPaths.collectionnstatus).doc(statuspublisherphone).get().then((doc) {
//                                                                         if (doc.exists) {
//                                                                           int i = statusProvider.contactsStatus.indexWhere((element) => element[Dbkeys.statusPUBLISHERPHONE] == statuspublisherphone);
//                                                                           statusProvider.contactsStatus.removeAt(i);
//                                                                           statusProvider.contactsStatus.insert(i, doc);
//                                                                           setState(() {});
//                                                                         }
//                                                                       });
//                                                                     },
//                                                                     currentUserNo: widget.currentUserNo!,
//                                                                     statusDoc: statusProvider.contactsStatus[idx],
//                                                                     postedbyFullname: statusProvider.joinedUserPhoneStringAsInServer.elementAt(statusProvider.joinedUserPhoneStringAsInServer.toList().indexWhere((element) => statusProvider.contactsStatus[idx][Dbkeys.statusPUBLISHERPHONEVARIANTS].contains(element.phone))).name.toString(),
//                                                                     postedbyPhotourl: snapshot.data![Dbkeys.photoUrl],
//                                                                   )));
//                                                         },
//                                                         child:
//                                                         ListTile(
//                                                           contentPadding: EdgeInsets.fromLTRB(
//                                                               5,
//                                                               6,
//                                                               10,
//                                                               6),
//                                                           leading:
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsets.only(left: 5),
//                                                             child:
//                                                             CircularBorder(
//                                                               totalitems: statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length,
//                                                               totalseen: seen,
//                                                               width: 2.5,
//                                                               size: 65,
//                                                               color: statusProvider.contactsStatus[idx].data().containsKey(widget.currentUserNo)
//                                                                   ? statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length > 0
//                                                                   ? Colors.teal.withOpacity(0.8)
//                                                                   : Colors.grey.withOpacity(0.8)
//                                                                   : Colors.grey.withOpacity(0.8),
//                                                               icon: Padding(
//                                                                 padding: const EdgeInsets.all(3.0),
//                                                                 child: statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemTYPE] == Dbkeys.statustypeTEXT
//                                                                     ? Container(
//                                                                   width: 50.0,
//                                                                   height: 50.0,
//                                                                   child: Icon(Icons.text_fields, color: Colors.white54),
//                                                                   decoration: BoxDecoration(
//                                                                     color: Color(int.parse(statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemBGCOLOR], radix: 16)),
//                                                                     shape: BoxShape.circle,
//                                                                   ),
//                                                                 )
//                                                                     : statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemTYPE] == Dbkeys.statustypeVIDEO
//                                                                     ? Container(
//                                                                   width: 50.0,
//                                                                   height: 50.0,
//                                                                   child: Icon(Icons.play_circle_fill_rounded, color: Colors.white54),
//                                                                   decoration: BoxDecoration(
//                                                                     color: Colors.black87,
//                                                                     shape: BoxShape.circle,
//                                                                   ),
//                                                                 )
//                                                                     : CachedNetworkImage(
//                                                                   imageUrl: statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemURL],
//                                                                   imageBuilder: (context, imageProvider) => Container(
//                                                                     width: 50.0,
//                                                                     height: 50.0,
//                                                                     decoration: BoxDecoration(
//                                                                       shape: BoxShape.circle,
//                                                                       image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//                                                                     ),
//                                                                   ),
//                                                                   placeholder: (context, url) => Container(
//                                                                     width: 50.0,
//                                                                     height: 50.0,
//                                                                     decoration: BoxDecoration(
//                                                                       color: Colors.grey[300],
//                                                                       shape: BoxShape.circle,
//                                                                     ),
//                                                                   ),
//                                                                   errorWidget: (context, url, error) => Container(
//                                                                     width: 50.0,
//                                                                     height: 50.0,
//                                                                     decoration: BoxDecoration(
//                                                                       color: Colors.grey[300],
//                                                                       shape: BoxShape.circle,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           title:
//                                                           Text(
//                                                             statusProvider.joinedUserPhoneStringAsInServer.elementAt(statusProvider.joinedUserPhoneStringAsInServer.toList().indexWhere((element) => statusProvider.contactsStatus[idx][Dbkeys.statusPUBLISHERPHONEVARIANTS].contains(element.phone.toString()))).name.toString(),
//                                                             style:
//                                                             TextStyle(fontWeight: FontWeight.bold),
//                                                           ),
//                                                           subtitle:
//                                                           Text(
//                                                             getStatusTime(statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemID],
//                                                                 this.context),
//                                                             style:
//                                                             TextStyle(height: 1.4),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                     return InkWell(
//                                                       onTap:
//                                                           () {
//                                                         Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                                 builder: (context) => StatusView(
//                                                                   callback: (statuspublisherphone) {
//                                                                     FirebaseFirestore.instance.collection(DbPaths.collectionnstatus).doc(statuspublisherphone).get().then((doc) {
//                                                                       if (doc.exists) {
//                                                                         int i = statusProvider.contactsStatus.indexWhere((element) => element[Dbkeys.statusPUBLISHERPHONE] == statuspublisherphone);
//                                                                         statusProvider.contactsStatus.removeAt(i);
//                                                                         statusProvider.contactsStatus.insert(i, doc);
//                                                                         setState(() {});
//                                                                       }
//                                                                     });
//                                                                   },
//                                                                   currentUserNo: widget.currentUserNo!,
//                                                                   statusDoc: statusProvider.contactsStatus[idx],
//                                                                   postedbyFullname: statusProvider.joinedUserPhoneStringAsInServer.elementAt(statusProvider.joinedUserPhoneStringAsInServer.toList().indexWhere((element) => statusProvider.contactsStatus[idx][Dbkeys.statusPUBLISHERPHONEVARIANTS].contains(element.phone.toString()))).name.toString(),
//                                                                   postedbyPhotourl: null,
//                                                                 )));
//                                                       },
//                                                       child:
//                                                       ListTile(
//                                                         contentPadding: EdgeInsets.fromLTRB(
//                                                             5,
//                                                             6,
//                                                             10,
//                                                             6),
//                                                         leading:
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(left: 5),
//                                                           child:
//                                                           CircularBorder(
//                                                             totalitems:
//                                                             statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length,
//                                                             totalseen:
//                                                             seen,
//                                                             width:
//                                                             2.5,
//                                                             size:
//                                                             65,
//                                                             color: statusProvider.contactsStatus[idx].data().containsKey(widget.currentUserNo)
//                                                                 ? statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length > 0
//                                                                 ? Colors.teal.withOpacity(0.8)
//                                                                 : Colors.grey.withOpacity(0.8)
//                                                                 : Colors.grey.withOpacity(0.8),
//                                                             icon:
//                                                             Padding(
//                                                               padding: const EdgeInsets.all(3.0),
//                                                               child: statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemTYPE] == Dbkeys.statustypeTEXT
//                                                                   ? Container(
//                                                                 width: 50.0,
//                                                                 height: 50.0,
//                                                                 child: Icon(Icons.text_fields, color: Colors.white54),
//                                                                 decoration: BoxDecoration(
//                                                                   color: Color(int.parse(statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemBGCOLOR], radix: 16)),
//                                                                   shape: BoxShape.circle,
//                                                                 ),
//                                                               )
//                                                                   : statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemTYPE] == Dbkeys.statustypeVIDEO
//                                                                   ? Container(
//                                                                 width: 50.0,
//                                                                 height: 50.0,
//                                                                 child: Icon(Icons.play_circle_fill_rounded, color: Colors.white54),
//                                                                 decoration: BoxDecoration(
//                                                                   color: Colors.black87,
//                                                                   shape: BoxShape.circle,
//                                                                 ),
//                                                               )
//                                                                   : CachedNetworkImage(
//                                                                 imageUrl: statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemURL],
//                                                                 imageBuilder: (context, imageProvider) => Container(
//                                                                   width: 50.0,
//                                                                   height: 50.0,
//                                                                   decoration: BoxDecoration(
//                                                                     shape: BoxShape.circle,
//                                                                     image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
//                                                                   ),
//                                                                 ),
//                                                                 placeholder: (context, url) => Container(
//                                                                   width: 50.0,
//                                                                   height: 50.0,
//                                                                   decoration: BoxDecoration(
//                                                                     color: Colors.grey[300],
//                                                                     shape: BoxShape.circle,
//                                                                   ),
//                                                                 ),
//                                                                 errorWidget: (context, url, error) => Container(
//                                                                   width: 50.0,
//                                                                   height: 50.0,
//                                                                   decoration: BoxDecoration(
//                                                                     color: Colors.grey[300],
//                                                                     shape: BoxShape.circle,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         title:
//                                                         Text(
//                                                           statusProvider
//                                                               .joinedUserPhoneStringAsInServer
//                                                               .elementAt(statusProvider.joinedUserPhoneStringAsInServer.toList().indexWhere((element) => statusProvider.contactsStatus[idx][Dbkeys.statusPUBLISHERPHONEVARIANTS].contains(element.phone)))
//                                                               .name
//                                                               .toString(),
//                                                           style:
//                                                           TextStyle(fontWeight: FontWeight.bold),
//                                                         ),
//                                                         subtitle:
//                                                         Text(
//                                                           getStatusTime(
//                                                               statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST][statusProvider.contactsStatus[idx][Dbkeys.statusITEMSLIST].length - 1][Dbkeys.statusItemID],
//                                                               this.context),
//                                                           style:
//                                                           TextStyle(height: 1.4),
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }));
//                                     },
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         child: statusProvider.isLoading
//                             ? Container(
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                   valueColor:
//                                   AlwaysStoppedAnimation<Color>(
//                                       fiberchatBlue)),
//                             ),
//                             color: Colors.black12)
//                             : Container(),
//                       )
//                     ],
//                   )),
//             ),
//           );
//         })));
//   }
//
//   showMediaOptions(
//       {required BuildContext context,
//         required Function pickImageCallback,
//         required Function pickVideoCallback,
//       //  required List<dynamic> phoneVariants,
//         required bool ishideTextStatusbutton}) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         builder: (BuildContext context) {
//           // return your layout
//           return Consumer<StatusProvider>(
//               builder: (context, statusProvider, _child) => Container(
//                   padding: EdgeInsets.all(12),
//                   height: 100,
//                   child: ishideTextStatusbutton == true
//                       ? Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             pickImageCallback();
//                           },
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width / 4,
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.image,
//                                   size: 39,
//                                   color: fiberchatLightGreen,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text('image',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 15,
//                                       color: fiberchatBlack),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                               pickVideoCallback();
//                             },
//                             child: SizedBox(
//                               width:
//                               MediaQuery.of(context).size.width / 4,
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.video_camera_back,
//                                     size: 39,
//                                     color: fiberchatLightGreen,
//                                   ),
//                                   SizedBox(height: 3),
//                                   Text( 'video',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.normal,
//                                         fontSize: 15,
//                                         color: fiberchatBlack),
//                                   ),
//                                 ],
//                               ),
//                             ))
//                       ])
//                       : Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             // createTextCallback();
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => TextStatus(
//                                         currentuserNo:
//                                         widget.currentUserNo!,
//                                        // phoneNumberVariants: phoneVariants
//                                     )));
//                           },
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width / 4,
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.text_fields,
//                                   size: 39,
//                                   color: fiberchatLightGreen,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text( 'text',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 15,
//                                       color: fiberchatBlack),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             pickImageCallback();
//                           },
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width / 4,
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.image,
//                                   size: 39,
//                                   color: fiberchatLightGreen,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text( 'image',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 15,
//                                       color: fiberchatBlack),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                               pickVideoCallback();
//                             },
//                             child: SizedBox(
//                               width:
//                               MediaQuery.of(context).size.width / 4,
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.video_camera_back,
//                                     size: 39,
//                                     color: fiberchatLightGreen,
//                                   ),
//                                   SizedBox(height: 3),
//                                   Text( 'video',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.normal,
//                                         fontSize: 15,
//                                         color: fiberchatBlack),
//                                   ),
//                                 ],
//                               ),
//                             ))
//                       ])));
//         });
//   }
//
//   deleteOptions(BuildContext context, DocumentSnapshot myStatusDoc) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         builder: (BuildContext context) {
//           // return your layout
//           return Consumer<StatusProvider>(
//               builder: (context, statusProvider, _child) => Container(
//                   padding: EdgeInsets.all(12),
//                   height: 170,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Text( 'myactstatus',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                       Container(
//                         height: 96,
//                         child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             shrinkWrap: true,
//                             physics: ScrollPhysics(),
//                             itemCount:
//                             myStatusDoc[Dbkeys.statusITEMSLIST].length,
//                             itemBuilder: (context, int i) {
//                               return Container(
//                                 height: 40,
//                                 margin: EdgeInsets.all(10),
//                                 child: Stack(
//                                   children: [
//                                     myStatusDoc[Dbkeys.statusITEMSLIST][i]
//                                     [Dbkeys.statusItemTYPE] ==
//                                         Dbkeys.statustypeTEXT
//                                         ? Container(
//                                       width: 70.0,
//                                       height: 70.0,
//                                       child: Icon(Icons.text_fields,
//                                           color: Colors.white54),
//                                       decoration: BoxDecoration(
//                                         color: Color(int.parse(
//                                             myStatusDoc[Dbkeys
//                                                 .statusITEMSLIST][i][
//                                             Dbkeys.statusItemBGCOLOR],
//                                             radix: 16)),
//                                         shape: BoxShape.circle,
//                                       ),
//                                     )
//                                         : myStatusDoc[Dbkeys.statusITEMSLIST][i]
//                                     [Dbkeys.statusItemTYPE] ==
//                                         Dbkeys.statustypeVIDEO
//                                         ? Container(
//                                       width: 70.0,
//                                       height: 70.0,
//                                       decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                           Icons.play_circle_fill,
//                                           size: 29,
//                                           color: Colors.white54),
//                                     )
//                                         : CachedNetworkImage(
//                                       imageUrl: myStatusDoc[
//                                       Dbkeys.statusITEMSLIST]
//                                       [i][Dbkeys.statusItemURL],
//                                       imageBuilder:
//                                           (context, imageProvider) =>
//                                           Container(
//                                             width: 70.0,
//                                             height: 70.0,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                   image: imageProvider,
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                       placeholder: (context, url) =>
//                                           Container(
//                                             width: 70.0,
//                                             height: 70.0,
//                                             decoration: BoxDecoration(
//                                               color: Colors.grey[300],
//                                               shape: BoxShape.circle,
//                                             ),
//                                           ),
//                                       errorWidget:
//                                           (context, url, error) =>
//                                           Container(
//                                             width: 70.0,
//                                             height: 70.0,
//                                             decoration: BoxDecoration(
//                                               color: Colors.grey[300],
//                                               shape: BoxShape.circle,
//                                             ),
//                                           ),
//                                     ),
//                                     Positioned(
//                                       top: 45.0,
//                                       left: 45.0,
//                                       child: InkWell(
//                                         onTap: () async {
//                                           Navigator.of(context).pop();
//                                           showDialog(
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title: new Text( 'dltstatus'),
//                                                 actions: [
//                                                   // ignore: deprecated_member_use
//                                                   FlatButton(
//                                                     child: Text('cancel',
//                                                       style: TextStyle(
//                                                           color: fiberchatgreen,
//                                                           fontSize: 18),
//                                                     ),
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                   ),
//                                                   // ignore: deprecated_member_use
//                                                   FlatButton(
//                                                     child: Text( 'delete',
//                                                       style: TextStyle(
//                                                           color: Colors.red,
//                                                           fontSize: 18),
//                                                     ),
//                                                     onPressed: () async {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                       Fiberchat.toast(
//                                                               'plswait');
//                                                       statusProvider
//                                                           .setIsLoading(true);
//
//                                                       if (myStatusDoc[Dbkeys
//                                                           .statusITEMSLIST][i]
//                                                       [Dbkeys
//                                                           .statusItemTYPE] ==
//                                                           Dbkeys
//                                                               .statustypeTEXT) {
//                                                         if (myStatusDoc[Dbkeys
//                                                             .statusITEMSLIST]
//                                                             .length <
//                                                             2) {
//                                                           await FirebaseFirestore
//                                                               .instance
//                                                               .collection(DbPaths
//                                                               .collectionnstatus)
//                                                               .doc(widget
//                                                               .currentUserNo)
//                                                               .delete();
//                                                         } else {
//                                                           await FirebaseFirestore
//                                                               .instance
//                                                               .collection(DbPaths
//                                                               .collectionnstatus)
//                                                               .doc(widget
//                                                               .currentUserNo)
//                                                               .update({
//                                                             Dbkeys.statusITEMSLIST:
//                                                             FieldValue
//                                                                 .arrayRemove([
//                                                               myStatusDoc[Dbkeys
//                                                                   .statusITEMSLIST][i]
//                                                             ])
//                                                           });
//                                                         }
//
//                                                         statusProvider
//                                                             .setIsLoading(
//                                                             false);
//                                                         Fiberchat.toast(
//                                                                 'dltscs');
//                                                       } else {
//                                                         FirebaseStorage.instance
//                                                             .refFromURL(myStatusDoc[
//                                                         Dbkeys
//                                                             .statusITEMSLIST][i][Dbkeys
//                                                             .statusItemURL])
//                                                             .delete()
//                                                             .then(
//                                                                 (value) async {
//                                                               if (myStatusDoc[Dbkeys
//                                                                   .statusITEMSLIST]
//                                                                   .length <
//                                                                   2) {
//                                                                 await FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(DbPaths
//                                                                     .collectionnstatus)
//                                                                     .doc(widget
//                                                                     .currentUserNo)
//                                                                     .delete();
//                                                               } else {
//                                                                 await FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(DbPaths
//                                                                     .collectionnstatus)
//                                                                     .doc(widget
//                                                                     .currentUserNo)
//                                                                     .update({
//                                                                   Dbkeys.statusITEMSLIST:
//                                                                   FieldValue
//                                                                       .arrayRemove([
//                                                                     myStatusDoc[Dbkeys
//                                                                         .statusITEMSLIST][i]
//                                                                   ])
//                                                                 });
//                                                               }
//                                                             }).then((value) {
//                                                           statusProvider
//                                                               .setIsLoading(
//                                                               false);
//                                                           Fiberchat.toast(
//                                                                   'dltscs');
//                                                         }).catchError(
//                                                                 (onError) async {
//                                                               statusProvider
//                                                                   .setIsLoading(
//                                                                   false);
//                                                               print('ERROR DELETING STATUS: ' +
//                                                                   onError
//                                                                       .toString());
//
//                                                               if (onError.toString().contains(Dbkeys.firebaseStorageNoObjectFound1) ||
//                                                                   onError
//                                                                       .toString()
//                                                                       .contains(Dbkeys
//                                                                       .firebaseStorageNoObjectFound2) ||
//                                                                   onError
//                                                                       .toString()
//                                                                       .contains(Dbkeys
//                                                                       .firebaseStorageNoObjectFound3) ||
//                                                                   onError
//                                                                       .toString()
//                                                                       .contains(Dbkeys
//                                                                       .firebaseStorageNoObjectFound4)) {
//                                                                 if (myStatusDoc[Dbkeys
//                                                                     .statusITEMSLIST]
//                                                                     .length <
//                                                                     2) {
//                                                                   await FirebaseFirestore
//                                                                       .instance
//                                                                       .collection(
//                                                                       DbPaths
//                                                                           .collectionnstatus)
//                                                                       .doc(widget
//                                                                       .currentUserNo)
//                                                                       .delete();
//                                                                 } else {
//                                                                   await FirebaseFirestore
//                                                                       .instance
//                                                                       .collection(
//                                                                       DbPaths
//                                                                           .collectionnstatus)
//                                                                       .doc(widget
//                                                                       .currentUserNo)
//                                                                       .update({
//                                                                     Dbkeys.statusITEMSLIST:
//                                                                     FieldValue
//                                                                         .arrayRemove([
//                                                                       myStatusDoc[Dbkeys
//                                                                           .statusITEMSLIST][i]
//                                                                     ])
//                                                                   });
//                                                                 }
//                                                               }
//                                                             });
//                                                       }
//                                                     },
//                                                   )
//                                                 ],
//                                               );
//                                             },
//                                             context: context,
//                                           );
//                                         },
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           child: Icon(
//                                             Icons.delete,
//                                             color: Colors.white,
//                                             size: 15,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                       ),
//                     ],
//                   )));
//         });
//   }
//   Widget customCircleAvatar({String? name, String? url, double? radius}) {
//     if (url == null || url == '') {
//       return IsShowInitialsWhenNoDP == false || name == null
//           ? CircleAvatar(
//         backgroundColor: Color(0xffE6E6E6),
//         radius: radius ?? 30,
//         child: Icon(
//           Icons.person,
//           color: Color(0xffCCCCCC),
//         ),
//       )
//           : CircleAvatar(
//         backgroundColor: fiberchatgreen,
//         foregroundColor: Colors.white,
//         child: Text(Fiberchat.getInitials(name)),
//         radius: radius ?? 30,
//       );
//     } else {
//       return CachedNetworkImage(
//           imageUrl: url,
//           imageBuilder: (context, imageProvider) => CircleAvatar(
//             backgroundColor: Color(0xffE6E6E6),
//             radius: radius ?? 30,
//             backgroundImage: NetworkImage('$url'),
//           ),
//           placeholder: (context, url) => CircleAvatar(
//             backgroundColor: Color(0xffE6E6E6),
//             radius: radius ?? 30,
//             child: Icon(
//               Icons.person,
//               color: Color(0xffCCCCCC),
//             ),
//           ),
//           errorWidget: (context, url, error) => CircleAvatar(
//             backgroundColor: Color(0xffE6E6E6),
//             radius: radius ?? 30,
//             child: Icon(
//               Icons.person,
//               color: Color(0xffCCCCCC),
//             ),
//           ));
//     }
//   }
// }
