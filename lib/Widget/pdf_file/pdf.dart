// import 'package:flutter/material.dart';
//
// Widget getDocmessage(
//     BuildContext context, Map<String, dynamic> doc, String message,
//     {bool saved = false}) {
//  // final bool isMe = doc[Dbkeys.from] == currentUserNo;
//   return SizedBox(
//     width: 220,
//     height: 116,
//     child: Column(
//       children: [
//         Container(
//             margin: EdgeInsets.only(bottom: 10),
//             child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.share,
//                     size: 12,
//                     color: Color(0xff754abb).withOpacity(0.5),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text( 'forwarded',
//                       maxLines: 1,
//                       style: TextStyle(
//                           color: Color(0xff754abb).withOpacity(0.7),
//                           fontStyle: FontStyle.italic,
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: 13))
//                 ])),
//         ListTile(
//           contentPadding: EdgeInsets.all(4),
//           isThreeLine: false,
//           leading: Container(
//             decoration: BoxDecoration(
//               color: Colors.yellow[800],
//               borderRadius: BorderRadius.circular(7.0),
//             ),
//             padding: EdgeInsets.all(12),
//             child: Icon(
//               Icons.insert_drive_file,
//               size: 25,
//               color: Colors.white,
//             ),
//           ),
//           title: Text(
//             message.split('-BREAK-')[1],
//             overflow: TextOverflow.ellipsis,
//             maxLines: 2,
//             style: TextStyle(
//                 height: 1.4,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black87),
//           ),
//         ),
//         Divider(
//           height: 3,
//         ),
//         message.split('-BREAK-')[1].endsWith('.pdf')
//             ? Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // ignore: deprecated_member_use
//             FlatButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute<dynamic>(
//                       builder: (_) => PDFViewerCachedFromUrl(
//                         title: message.split('-BREAK-')[1],
//                         url: message.split('-BREAK-')[0],
//                         isregistered: true,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(getTranslated(this.context, 'preview'),
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Colors.blue[400]))),
//             // ignore: deprecated_member_use
//             FlatButton(
//                 onPressed: Platform.isIOS || Platform.isAndroid
//                     ? () {
//                   launch(message.split('-BREAK-')[0]);
//                 }
//                     : () async {
//                   await downloadFile(
//                     context: _scaffold.currentContext!,
//                     fileName: message.split('-BREAK-')[1],
//                     isonlyview: false,
//                     keyloader: _keyLoader,
//                     uri: message.split('-BREAK-')[0],
//                   );
//                 },
//                 child: Text(getTranslated(this.context, 'download'),
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Colors.blue[400]))),
//           ],
//         )
//         //ignore: deprecated_member_use
//             : FlatButton(
//             onPressed: Platform.isIOS || Platform.isAndroid
//                 ? () {
//               launch(message.split('-BREAK-')[0]);
//             }
//                 : () async {
//               await downloadFile(
//                 context: _scaffold.currentContext!,
//                 fileName: message.split('-BREAK-')[1],
//                 isonlyview: false,
//                 keyloader: _keyLoader,
//                 uri: message.split('-BREAK-')[0],
//               );
//             },
//             child: Text(getTranslated(this.context, 'download'),
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.blue[400]))),
//       ],
//     ),
//   );
// }