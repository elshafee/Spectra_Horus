// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image/image.dart' as imgLib;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
//
// class HomeScreen extends StatefulWidget {
//   String? title = 'Home Screen';
//   HomeScreen({required this.title, Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   //define variables
//
//   File? _image;
//   double _height = 70.0;
//   double _rotation = 0;
//   var imageData;
//   int? _width, _heigh;
//   bool dataLoaded = false;
//
//   //define controllers
//
//   final picker = ImagePicker();
//   final controller = CropController(aspectRatio: 1000 / 667.0);
//   BoxShape shape = BoxShape.rectangle;
//
//   // get image from camera
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   // get image from gallery
//
//   Future getImag() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   // crop the image
//
//   void _cropImage() async {
//     final pixelRatio = MediaQuery.of(context).devicePixelRatio;
//     final cropped = await controller.crop(pixelRatio: pixelRatio);
//
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Crop Result'),
//             centerTitle: true,
//           ),
//           body: Center(
//             child: RawImage(
//               image: cropped,
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () async {
//               var byteData =
//                   await cropped.toByteData(format: ui.ImageByteFormat.png);
//               var buffer = byteData!.buffer.asUint8List();
//               print(byteData);
//               var buf = imgLib.PngDecoder().decodeImage(buffer);
//               imgLib.Image imag = imgLib.grayscale(buf!);
//               var ah = imgLib.encodePng(imag);
//
//               setState(() {
//                 imageData = ah as Uint8List;
//                 print(imageData);
//                 dataLoaded = true;
//                 _width = cropped.width;
//                 _heigh = cropped.height;
//               });
//
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Saved to gallery. ${byteData.lengthInBytes}'),
//                 ),
//               );
//               // Navigator.push(
//               //     context,
//               //     Transition(
//               //         child: BlankSelection(
//               //           height: _heigh,
//               //           width: _width,
//               //           imageData: imageData,
//               //         ),
//               //         transitionEffect: TransitionEffect.FADE));
//             },
//             child: const Icon(Icons.navigate_next),
//           ),
//         ),
//         fullscreenDialog: true,
//       ),
//     );
//   }
//
//   //save the cropped image
//
//   Future<dynamic> _saveScreenShot(ui.Image img) async {
//     var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//     var buffer = byteData!.buffer.asUint8List();
//     final result = await ImageGallerySaver.saveImage(buffer);
//     print(result);
//
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.title}'),
//       ),
//       body: Center(
//         child: _image == null
//             ? const Text('No image selected.')
//             : Crop(
//                 onChanged: (decomposition) {
//                   if (_rotation != decomposition.rotation) {
//                     setState(() {
//                       _rotation = ((decomposition.rotation + 180) % 360) - 180;
//                     });
//                   }
//                 },
//                 controller: controller,
//                 shape: shape,
//                 child: Image.file(File(_image!.path)),
//                 helper: shape == BoxShape.rectangle
//                     ? Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                       )
//                     : null,
//               ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 0, left: 0),
//           child: _image == null && _height >= 220
//               ? AnimatedContainer(
//                   curve: Curves.ease,
//                   duration: const Duration(seconds: 1),
//                   height: _height,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25),
//                     ),
//                     color: Colors.indigo[800],
//                     border: Border.all(
//                       color: Colors.indigo,
//                     ),
//                   ),
//                   child: ListView(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             color: const Color.fromRGBO(182, 139, 26, 1),
//                             icon: Icon(
//                               _height == 220
//                                   ? Icons.cancel
//                                   : Icons.arrow_upward_rounded,
//                               color: Colors.green,
//                             ),
//                             onPressed: () {
//                               _height == 220
//                                   ? setState(() {
//                                       _height = 70;
//                                     })
//                                   : setState(() {
//                                       _height = 220;
//                                     });
//                             },
//                           ),
//                           Text(
//                             "Please Choose the image source",
//                             style: GoogleFonts.jomolhari(
//                               fontSize: 18.0,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                           RaisedButton(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Gallery',
//                                   style: GoogleFonts.jomolhari(
//                                     fontSize: 18.0,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Icon(
//                                   Icons.add_photo_alternate,
//                                   color: Colors.white,
//                                 )
//                               ],
//                             ),
//                             color: const Color.fromRGBO(108, 99, 255, 0.9),
//                             splashColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                             onPressed: _image == null
//                                 ? getImag
//                                 : () {
//                                     print(_image);
//                                     setState(() {
//                                       _height = 70;
//                                     });
//                                   },
//                           ),
//                           RaisedButton(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Camera',
//                                   style: GoogleFonts.jomolhari(
//                                     fontSize: 18.0,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Icon(
//                                   Icons.add_a_photo,
//                                   color: Colors.white,
//                                 )
//                               ],
//                             ),
//                             color: const Color.fromRGBO(108, 99, 255, 0.9),
//                             splashColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                             onPressed: _image == null
//                                 ? getImage
//                                 : () {
//                                     print(_image);
//                                     setState(() {
//                                       _height = 70;
//                                     });
//                                   },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               : AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   height: _image == null ? _height : _height = 70.0,
//                   curve: Curves.ease,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25),
//                     ),
//                     color: Colors.indigo[800],
//                     border: Border.all(
//                       color: Colors.indigo,
//                     ),
//                   ),
//
//                   //
//
//                   //
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           RaisedButton(
//                             child: _image == null
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'Select an Image to start',
//                                         style: GoogleFonts.courgette(
//                                           fontSize: 18.0,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       const Icon(
//                                         Icons.add_a_photo,
//                                         color: Colors.white,
//                                       )
//                                     ],
//                                   )
//                                 : Text(
//                                     'Next',
//                                     style: GoogleFonts.courgette(
//                                       fontSize: 18.0,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                             color: const Color.fromRGBO(108, 99, 255, 0.9),
//                             splashColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                             onPressed: () {
//                               if (_image == null) {
//                                 setState(() {
//                                   _height = 220;
//                                 });
//                               } else {
//                                 setState(() {
//                                   _height = 70;
//                                 });
//                                 _cropImage();
//                               }
//
//                               //getImage
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
