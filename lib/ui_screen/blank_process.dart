// import 'package:flutter/material.dart';
// import 'package:spectra_horus/ui_screen/home_screen.dart';
//
// class BlankProcess extends StatefulWidget {
//   const BlankProcess({Key? key}) : super(key: key);
//
//   @override
//   _BlankProcessState createState() => _BlankProcessState();
// }
//
// class _BlankProcessState extends State<BlankProcess> {
//   @override
//   Widget build(BuildContext context) {
//     return HomeScreen(title: 'Blank Selection');
//   }
// }
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as imgLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:spectra_horus/ui_screen/sample_process.dart';
import 'package:transition/transition.dart';

class BlankProcess extends StatefulWidget {
  List<int> lightList = [];
  List<int> blankList = [];
  List<int> sampleList = [];
  int? lightlength;

  BlankProcess(
      {required this.lightList,
      required this.lightlength,
      required this.blankList,
      required this.sampleList,
      Key? key})
      : super(key: key);

  @override
  _BlankProcessState createState() => _BlankProcessState();
}

class _BlankProcessState extends State<BlankProcess> {
  //define variables

  File? _image, _cropped;
  double _height = 70.0;
  double _rotation = 0;
  List imageData = [];
  int? _width, _heigh;
  bool dataLoaded = false;
  List<int> _ava = [];
  Uint8List? _unit8list;
  MemoryImage? flutter;
  int? _wt, _hg;

  Uint8List? imageBytes, _buffe;

  //define controllers

  final picker = ImagePicker();
  BoxShape shape = BoxShape.rectangle;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
  }
  // get image from camera

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _cropped = await ImageCropper.cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
        compressFormat: ImageCompressFormat.jpg,
      );

      _cropped!.readAsBytes().then(
        (value) {
          final p = value;

          print(value.runtimeType);

          for (var i = 0, len = p.length - 4; i < len; i += 4) {
            final l = imgLib.getLuminanceRgb(p[i], p[i + 1], p[i + 2]);
            p[i] = l;
            p[i + 1] = l;
            p[i + 2] = l;
          }

          var imag = Image.memory(p);
          print(p);
          setState(() {
            _unit8list = p;
            print(imag.runtimeType);
          });
        },
      );
    }
  }

  // get image from gallery

  void _cropImage() async {
    int _wid = _wt!;
    int lt = _unit8list!.length;
    double sum = lt / _wid;
    int y = 0;
    List<int> _lis = [];
    List _value = [];
    for (int k = 0; k < sum.toInt(); k++) {
      for (int i = 0; i < _wid; i++) {
        var edit = _unit8list![i + y];
        _value.add(edit);
      }
      double ul = 0.0;
      var sums = 0;

      sums = _value.reduce((a, b) => a + b);
      ul = sums / _wid;
      ul = double.parse((ul).toStringAsFixed(0));
      _lis.add(ul.toInt());

      _value = [];
      y += _wid;
    }
    var imageDat;
    print(_lis);
    setState(() {
      imageDat = _unit8list as Uint8List;
      _width = _wt;
      _heigh = _hg;
      imageData = _lis;

      dataLoaded = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Crop Result'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: dataLoaded
              ? const CircularProgressIndicator()
              : Center(
                  child: Image.file(_cropped!),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  Transition(
                      child: SampleProcess(
                        lightlength: widget.lightlength,
                        blanklength: imageData.length,
                        lightList: widget.lightList,
                        sampleList: imageData as List<int>,
                        blankList: imageData as List<int>,
                      ),
                      transitionEffect: TransitionEffect.FADE));
            },
            child: const Icon(Icons.navigate_next),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
    // _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blank Selection"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: _image == null
              ? const Text('No Image Selected')
              : ImagePixels(
                  imageProvider: FileImage(_cropped!),
                  builder: (BuildContext context, ImgDetails img) {
                    return Scaffold(
                      body: Center(
                        child: Image.file(_cropped!),
                      ),
                      bottomNavigationBar: BottomAppBar(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0, left: 0),
                          child: _image == null && _height >= 220
                              ? AnimatedContainer(
                                  curve: Curves.ease,
                                  duration: const Duration(seconds: 1),
                                  height: _height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    color: Colors.indigo[800],
                                    border: Border.all(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  child: ListView(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            color: const Color.fromRGBO(
                                                182, 139, 26, 1),
                                            icon: Icon(
                                              _height == 220
                                                  ? Icons.cancel
                                                  : Icons.arrow_upward_rounded,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              _height == 220
                                                  ? setState(() {
                                                      _height = 70;
                                                    })
                                                  : setState(() {
                                                      _height = 220;
                                                    });
                                            },
                                          ),
                                          Text(
                                            "Please Choose the image source",
                                            style: GoogleFonts.jomolhari(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          RaisedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Gallery',
                                                    style:
                                                        GoogleFonts.jomolhari(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                    Icons.add_photo_alternate,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              color: const Color.fromRGBO(
                                                  108, 99, 255, 0.9),
                                              splashColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              onPressed: () {
                                                _image == null
                                                    ? getImage(
                                                        ImageSource.gallery)
                                                    : () {
                                                        print(_image);
                                                        setState(() {
                                                          _height = 70;
                                                        });
                                                      };
                                              }),
                                          RaisedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Camera',
                                                    style:
                                                        GoogleFonts.jomolhari(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                    Icons.add_a_photo,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              color: const Color.fromRGBO(
                                                  108, 99, 255, 0.9),
                                              splashColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              onPressed: () {
                                                _image == null
                                                    ? getImage(
                                                        ImageSource.camera)
                                                    : () {
                                                        print(_image);
                                                        setState(() {
                                                          _height = 0;
                                                        });
                                                      };
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  height:
                                      _image == null ? _height : _height = 70.0,
                                  curve: Curves.ease,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    color: Colors.indigo[800],
                                    border: Border.all(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            child: _image == null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Select an Image to start',
                                                        style: GoogleFonts
                                                            .courgette(
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    'Next',
                                                    style:
                                                        GoogleFonts.courgette(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                            color: const Color.fromRGBO(
                                                108, 99, 255, 0.9),
                                            splashColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            onPressed: () {
                                              _wt = img.width;
                                              _hg = img.height;
                                              print(_wt);
                                              print(_hg);

                                              _cropImage();

                                              //getImage
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                )
          // Image.file(_cropped!),
          ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 0, left: 0),
          child: _image == null && _height >= 220
              ? AnimatedContainer(
                  curve: Curves.ease,
                  duration: const Duration(seconds: 1),
                  height: _height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.indigo[800],
                    border: Border.all(
                      color: Colors.indigo,
                    ),
                  ),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            color: const Color.fromRGBO(182, 139, 26, 1),
                            icon: Icon(
                              _height == 220
                                  ? Icons.cancel
                                  : Icons.arrow_upward_rounded,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              _height == 220
                                  ? setState(() {
                                      _height = 70;
                                    })
                                  : setState(() {
                                      _height = 220;
                                    });
                            },
                          ),
                          Text(
                            "Please Choose the image source",
                            style: GoogleFonts.jomolhari(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Gallery',
                                    style: GoogleFonts.jomolhari(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              color: const Color.fromRGBO(108, 99, 255, 0.9),
                              splashColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              onPressed: () {
                                _image == null
                                    ? getImage(ImageSource.gallery)
                                    : () {
                                        print(_image);
                                        setState(() {
                                          _height = 70;
                                        });
                                      };
                              }),
                          RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Camera',
                                    style: GoogleFonts.jomolhari(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              color: const Color.fromRGBO(108, 99, 255, 0.9),
                              splashColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              onPressed: () {
                                _image == null
                                    ? getImage(ImageSource.camera)
                                    : () {
                                        print(_image);
                                        setState(() {
                                          _height = 0;
                                        });
                                      };
                              }),
                        ],
                      ),
                    ],
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: _image == null ? _height : _height = 0.0,
                  curve: Curves.ease,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.indigo[800],
                    border: Border.all(
                      color: Colors.indigo,
                    ),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  child: _image == null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Select an Image to start',
                                              style: GoogleFonts.courgette(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.add_a_photo,
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      : null,
                                  color:
                                      const Color.fromRGBO(108, 99, 255, 0.9),
                                  splashColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  onPressed: () {
                                    if (_image == null) {
                                      setState(() {
                                        _height = 220;
                                      });
                                    } else {
                                      setState(() {
                                        _height = 70;
                                      });
                                      _cropImage();
                                    }

                                    //getImage
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : null,
                ),
        ),
      ),
    );
  }
}
