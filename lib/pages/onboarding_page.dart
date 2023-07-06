import 'package:chitchat/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  late int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemCount: demo_data.length,
                controller: _pageController,
                itemBuilder: (context, index) => OnBoardingContent(
                    pageImage: demo_data[index].pageImage,
                    title: demo_data[index].title,
                    description: demo_data[index].description),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                    demo_data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DotIndicator(isActive: index == _pageIndex),
                        )),
                Spacer(),
                if (_pageIndex == demo_data.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AuthGate()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.black,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class OnBoard {
  final String pageImage, title, description;

  OnBoard(
      {required this.pageImage,
      required this.title,
      required this.description});
}

final List<OnBoard> demo_data = [
  OnBoard(
      pageImage: 'lib/assets/chating.svg',
      title: 'Meet with new people!',
      description:
          'officia deserunt mollitia animi, id est laborum et dolorum fuga.'),
  OnBoard(
      pageImage: 'lib/assets/chatingtwo.svg',
      title: 'Meet with new people!',
      description:
          'officia deserunt mollitia animi, id est laborum et dolorum fuga.'),
  OnBoard(
      pageImage: 'lib/assets/chatingthree.svg',
      title: 'Meet with new people!',
      description:
          'officia deserunt mollitia animi, id est laborum et dolorum fuga.'),
];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.pageImage,
    required this.title,
    required this.description,
  });

  final String pageImage, title, description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Spacer(),
          SvgPicture.asset(
            pageImage,
            height: 250,
          ),
          Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
