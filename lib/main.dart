import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Success',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _gifController;
  late final AnimationController _positionController;
  bool isHidden = true;

  @override
  void initState() {
    super.initState();

    _gifController = AnimationController(vsync: this);
    _positionController = AnimationController(vsync: this);
    _positionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isHidden = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _gifController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double initialSize = size.width * .6;
    double finalSize = size.width * .4;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  Rect.fromLTWH(
                    size.width * .2,
                    size.height * .6 - initialSize,
                    initialSize,
                    initialSize,
                  ),
                  size,
                ),
                end: RelativeRect.fromSize(
                  Rect.fromLTWH(
                    size.width * .3,
                    size.height * .1,
                    finalSize,
                    finalSize,
                  ),
                  size,
                ),
              ).animate(
                CurvedAnimation(
                  parent: _positionController,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: Lottie.asset(
                'assets/success.json',
                controller: _gifController,
                onLoaded: (composition) {
                  _gifController
                    ..duration = composition.duration
                    ..forward();

                  Future.delayed(
                    _gifController.duration!,
                    () {
                      _positionController
                        ..duration = const Duration(seconds: 1)
                        ..forward();
                    },
                  );
                },
                repeat: false,
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: isHidden ? 0 : 1,
              child: Center(
                child: SizedBox(
                  width: size.width * .7,
                  height: size.height * .4,
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text(
                            'Data',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
