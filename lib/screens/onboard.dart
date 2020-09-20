import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:paradise/constant.dart';
import 'package:paradise/screens/pagecontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  List<String> images = [
    "images/explore.png",
    "images/travel.png",
    "images/relax.png"
  ];
  double currentPage = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => skip(),
                          child: Wrap(
                            children: [
                              Text(
                                'skip',
                                style: TextStyle(color: textGrey),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          itemBuilder: (ctx, index) => Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  child: Image.asset(images[index],
                                      fit: BoxFit.contain)))),
                    ),
                  ),
                  Container(
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                                opacity: (currentPage < images.length - 1)
                                    ? 0.0
                                    : 1.0,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeIn,
                                child: FlatButton(
                                    color: primaryGreen,
                                    onPressed: () =>skip(),
                                    child: Text('Get Started',style:TextStyle(color:backColor,fontWeight: FontWeight.w600)))),
                            AnimatedOpacity(
                              curve: Curves.easeIn,
                              opacity:
                                  (currentPage < images.length - 1) ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 150),
                              child: DotsIndicator(
                                position: currentPage,
                                dotsCount: images.length,
                                decorator: DotsDecorator(
                                    activeColor: primaryGreen,
                                    activeSize: Size.square(13.0)),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ))),
    );
  }

  skip()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    sf.setBool('seen',true);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>PageContainer()));
  }
}
