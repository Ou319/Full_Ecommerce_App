import 'package:ecomme_app/app/app_prefs.dart';
import 'package:ecomme_app/domain/model/modeles.dart';
import 'package:ecomme_app/presentation/oboarding/viewmodel/oboardingviewmodel.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/routesmanaget.dart';
import 'package:ecomme_app/presentation/ressourses/stylemanager.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:ecomme_app/presentation/ressourses/valuesmanager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboardingview extends StatefulWidget {
  const Onboardingview({super.key});

  @override
  State<Onboardingview> createState() => _OnboardingviewState();
}

class _OnboardingviewState extends State<Onboardingview> {
  final PageController _pageController = PageController();
  Oboardingviewmodel _oboardingviewmodel = Oboardingviewmodel();
  late Future<AppPreferences> _appPreferencesFuture;

  @override
  void initState() {
    super.initState();
    _appPreferencesFuture = _initSharedPrefs();
    _bind();
  }

  Future<AppPreferences> _initSharedPrefs() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return AppPreferences(sharedPrefs);
  }

  _bind() {
    _oboardingviewmodel.start();
  }

  Future<void> _skkipedOnboarding() async {
    final appPreferences = await _appPreferencesFuture;
    await appPreferences.getOnBoardingScreenView();
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.naviagationbottombar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewobject>(
        stream: _oboardingviewmodel.outputSliderViewobject,
        builder: (context, snapshot) {
          return _getContentwidget(snapshot.data);
        });
  }


  _getContentwidget(SliderViewobject? data) {
    if (data == null) return SizedBox.shrink();
    
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _skkipedOnboarding,
            child: Container(
              margin: EdgeInsets.only(left: 420, top: 50),
              child: Text(
                AppString.skip,
                style: getTextStylesubetitle(AppFontsize.s12,
                    FontWhightmanager.lighter, AppColor.blue),
              ),
            ),
          ),
          Container(
            width: 390,
            height: 500,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => _oboardingviewmodel.onPagechnged(value),
                itemCount: data.nbrOfSliders,
                itemBuilder: (context, index) {
                  var item = data.sliderobject;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.network(
                          item.image,
                          frameBuilder: (context, child, composition) {
                            if (composition == null) {
                              return const CircularProgressIndicator();
                            } else {
                              return child;
                            }
                          },
                        ),
                      ),
                      Text(item.title,
                          style: getstyleTitle(AppFontsize.s16,
                              FontWhightmanager.medium, Colors.black)),
                      const SizedBox(height: Appsize.a10),
                      Text(
                        item.description,
                        style: getstyleTitle(AppFontsize.s12,
                            FontWhightmanager.medium, AppColor.textsm),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: Appsize.a36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      _oboardingviewmodel.goPrevious(),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(AppMargine.m16),
                    width: Appsize.a60,
                    height: Appsize.a60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: Appsize.a10,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < data.nbrOfSliders; i++)
                      Mycontainer(data.currentIndex == i),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (data.currentIndex == data.nbrOfSliders - 1) {
                      _skkipedOnboarding();
                    }
                    _pageController.animateToPage(
                      _oboardingviewmodel.goNext(),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: Appsize.a60,
                    margin: EdgeInsets.all(AppMargine.m16),
                    height: Appsize.a60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: Appsize.a10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Mycontainer(bool isNextpage) {
    return AnimatedContainer(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 700),
      width: isNextpage ? 54 : 20,
      height: 4,
      decoration: BoxDecoration(
        color: isNextpage ? Colors.black : Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _oboardingviewmodel.dispose();
    super.dispose();
  }
}