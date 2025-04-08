import 'dart:async';

import 'package:ecomme_app/domain/model/modeles.dart';
import 'package:ecomme_app/presentation/base/baseviewmodel.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:flutter/material.dart';

class Oboardingviewmodel extends Baseviewmodel{

  StreamController _streamController = StreamController<SliderViewobject>();
  int _currentIndex = 0;
  late final List<OnboardingSlider> _onboardingSliderList;

  

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _onboardingSliderList = _getsliderdata();
    _postDataToView();
    
  }

  int goNext(){
    int nextIndex = _currentIndex ++;
    if(nextIndex ==_onboardingSliderList.length){
      _currentIndex = 0;
    }
    return _currentIndex;
  }

  int goPrevious(){
    int previousIndex = _currentIndex --;
    if(previousIndex == -1){
      _currentIndex = 0;
    }
    return _currentIndex;
  }

  void onPagechnged(int index){
    _currentIndex = index;
    _postDataToView();
  }




  @override
  Sink get inputSliderViewobject => _streamController.sink;


    void _postDataToView() {
    // do here
      inputSliderViewobject.add(
        SliderViewobject(
          sliderobject: _onboardingSliderList[_currentIndex],
          nbrOfSliders: _onboardingSliderList.length,
          currentIndex: _currentIndex,
        ),
      );
    }

  @override
  Stream<SliderViewobject> get outputSliderViewobject => _streamController.stream.map((sliderViewObject) => sliderViewObject as SliderViewobject);

  List<OnboardingSlider> _getsliderdata()=>[
    OnboardingSlider(
      image: AppImg.onboqrdinglottie1,
      title: AppString.onboardingtitle1,
      description: AppString.onboardingsubtitle1,
    ),
    OnboardingSlider(
      image: AppImg.onboqrdinglottie2,
      title: AppString.onboardingtitle2,
      description: AppString.onboardingsubtitle2,
    ),
    OnboardingSlider(
      image: AppImg.onboqrdinglottie3,
      title: AppString.onboardingtitle3,
      description: AppString.onboardingsubtitle3,
    ),
  ];
}

abstract class OboardingviewmodelInputs{
  int goNext();
  int goPrevious();
  void onPagechnged(int index);
  

  Sink get inputSliderViewobject;
}
abstract class OboardingviewmodelOutputs{
  Stream<SliderViewobject> get outputSliderViewobject;
}