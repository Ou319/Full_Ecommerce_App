class OnboardingSlider{
  final String image;
  final String title;
  final String description;

  OnboardingSlider({
    required this.image,
    required this.title,
    required this.description,
  });
}

class SliderViewobject {
  OnboardingSlider sliderobject;
  int nbrOfSliders;
  int currentIndex;

  SliderViewobject({
    required this.sliderobject,
    required this.nbrOfSliders,
    required this.currentIndex,
  });
}

