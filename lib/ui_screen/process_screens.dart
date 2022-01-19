import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spectra_horus/ui_screen/hh.dart';
import 'package:spectra_horus/ui_screen/light_image.dart';
import 'package:transition/transition.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome',
            style: GoogleFonts.courgette(
              fontSize: 30.0,
              color: const Color.fromRGBO(108, 99, 255, 0.9),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset('assets/draws/img.png'),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            height: 55,
            child: RaisedButton(
              child: Text(
                'Next',
                style: GoogleFonts.courgette(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              color: const Color.fromRGBO(108, 99, 255, 0.9),
              splashColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    Transition(
                        child: const PageTwo(),
                        transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/draws/img2.png'),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10),
            child: Text(
              'Please remove any cover on your mobile camera then tap next.',
              style: GoogleFonts.courgette(
                fontSize: 24.0,
                color: const Color.fromRGBO(108, 99, 255, 0.9),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            height: 55,
            child: RaisedButton(
              child: Text(
                'Next',
                style: GoogleFonts.courgette(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              color: const Color.fromRGBO(108, 99, 255, 0.9),
              splashColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    Transition(
                        child: LightPro(
                          img: [],
                          count: 0,
                        ),
                        transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BlankSelection extends StatefulWidget {
  List<int> lightList = [];
  List<int> blankList = [];
  List<int> sampleList = [];
  int? lightlength, blanklength, samplelength;

  BlankSelection({
    Key? key,
    required this.blanklength,
    required this.lightlength,
    required this.samplelength,
    required this.lightList,
    required this.blankList,
    required this.sampleList,
  }) : super(key: key);
  @override
  _BlankSelectionState createState() => _BlankSelectionState();
}

class _BlankSelectionState extends State<BlankSelection> {
  int _blanklength = 0, _samplelength = 0, _length = 0, _val1 = 0, _val2 = 0;
  int _sum = 0;
  int progress = 0;
  List<double> _list = [];
  List<int> _value = [];
  List<int> _lightList = [];
  List<int> _blankList = [];
  List<int> _sampleList = [];

  var imageDat;
  @override
  void initState() {
    super.initState();
    setState(() {
      _lightList = widget.lightList;
      _blankList = widget.blankList;
      _sampleList = widget.sampleList;
      _blanklength = _blankList.length;
      _samplelength = _sampleList.length;
    });

    print(_blanklength);
    print(_samplelength);

    if (_blanklength > _samplelength) {
      setState(() {
        _length = _samplelength;
      });
    }
    if (_samplelength > _blanklength) {
      setState(() {
        _length = _blanklength;
      });
    }

    for (int i = 0; i < _length; i++) {
      _val1 = _sampleList[i];
      _val2 = _blankList[i];
      _sum = _val1 - _val2;
      print('befor abs $_sum');
      _sum = _sum.abs();
      print('after abs $_sum');

      if (_sum.isInfinite) {
        print(_sum);
      }
      _value.add(_sum);
    }
    int lent = _value.length;
    _val1 = 0;
    _val2 = 0;
    double _sume = 0;
    for (int j = 0; j < lent; j++) {
      _val1 = _value[j];
      _val2 = _lightList[j];
      _sume = -100 * log(_val1 / _val2);
      if (_sume.isFinite) {
        _list.add(_sume);
      }
    }
    print(_list);
    setState(() {
      _length = _list.length;
    });
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        Transition(
            child: Histest(
              length: _length,
              list: _list,
            ),
            transitionEffect: TransitionEffect.FADE),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Your result is ready'),
            SizedBox(
              height: 20,
            ),
            LinearProgressIndicator()
          ],
        ),
      ),
    );
  }
}
