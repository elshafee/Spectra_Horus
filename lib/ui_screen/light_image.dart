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
import 'package:spectra_horus/ui_screen/blank_process.dart';
import 'package:transition/transition.dart';

class LightPro extends StatefulWidget {
  int? count;
  List<int> img = [];
  List<int> lightList = [];
  List<int> blankList = [];
  List<int> sampleList = [];
  LightPro({required this.count, required this.img, Key? key})
      : super(key: key);

  @override
  _LightProState createState() => _LightProState();
}

class _LightProState extends State<LightPro> {
  //define variables
  List<int> _ava = [];
  int? _count;

  List<int> _img = [];
  File? _image, _cropped;
  double _height = 70.0;
  List imageData = [];
  int? _width, _heigh, _length;
  int? _wt, _hg;
  bool dataLoaded = true;
  Uint8List? _unit8list;
  MemoryImage? flutter;
  late imgLib.Image buf;

  //define controllers

  final picker = ImagePicker();
  BoxShape shape = BoxShape.rectangle;

  // get image from camera and Gallery

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
  }

  // crop the image

  void _cropImage() async {
    int _wid = _wt!;
    int lt = _unit8list!.length;
    double sum = lt / _wid;
    int y = 0;
    List _lis = [];
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
      _lis.add(ul);

      _value = [];
      y += _wid;
    }
    var imageDat;
    print(_lis);
    setState(() {
      imageData = _lis;
      imageDat = _unit8list as Uint8List;
      _width = _wt;
      _heigh = _hg;
      _count = widget.count!.toInt();
      _img = widget.img;
      dataLoaded = false;
      _length = _ava.length;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Crop Result'),
            centerTitle: true,
          ),
          body: dataLoaded
              ? const CircularProgressIndicator()
              : Center(
                  child: Image.file(_cropped!),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              for (int y = _count!; y < 3; y++) {
                for (int i = 0; i < imageDat.length; i++) {
                  _img.add(imageDat[i]);
                }
                setState(() {
                  _count = y;
                });

                print(_count);
                print(_img.length);
                imageData = [];
                Navigator.push(
                  context,
                  Transition(
                    child: LightPro(
                      img: _img,
                      count: _count,
                    ),
                    transitionEffect: TransitionEffect.LEFT_TO_RIGHT,
                  ),
                );
              }

              double _lent = (_img.length) / 3; //1000
              double _lent2 = (_img.length) - _lent; //3000 - 2000
              int _lent3 = _img.length; //3000

              List var1 = [];
              List var2 = [];
              List var3 = [];

              for (int i = 0; i <= _img.length; i += _lent.toInt()) {
                int v = i;
                if (v <= _lent.toInt()) {
                  for (int x = 0; x < _lent.toInt(); x++) {
                    var1.add(_img[x]);
                  }
                }
                if (_lent < v && v <= _lent2) {
                  for (int y = 0; y < _lent.toInt(); y++) {
                    int l = y + _lent.toInt();
                    var2.add(_img[l]);
                  }
                }
                if (_lent < v && v <= _lent3) {
                  for (int y = 0; y < _lent.toInt(); y++) {
                    int m = y + _lent2.toInt();
                    var3.add(_img[m]);
                  }
                }
              }

              for (int j = 0; j < _lent.toInt(); j++) {
                int va1 = var1[j];
                int va2 = var2[j];
                int va3 = var3[j];
                int sum = (va1 + va2 + va3);
                sum = (sum / 3).toInt();
                _ava.add(sum.toInt());
              }

              Navigator.push(
                context,
                Transition(
                  child: BlankProcess(
                    sampleList: _ava,
                    blankList: _ava,
                    lightlength: _length,
                    lightList: _ava,
                  ),
                  transitionEffect: TransitionEffect.FADE,
                ),
              );
            },
            child: const Icon(Icons.navigate_next),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Light Selection"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: _image == null
              ? Text('No Image Selected')
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
