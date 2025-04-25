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


// models categories 

class Categories {
  final String image;
  final String title;
  final String description;

  Categories({
    required this.image,
    required this.title,
    required this.description,
  });
}

// model productes

class ProducteModel {
  final String ImageAasset;
  final String Title;
  final String description;
  final String category;
  final double Price;
  bool isFavorit;
  int count;

  ProducteModel({
    required this.Price,
    required this.Title,
    required this.description,
    required this.category,
    required this.ImageAasset,
    this.count = 1,
    this.isFavorit = false,
  });

  // Factory constructor to create a ProducteModel from JSON
  factory ProducteModel.fromJson(Map<String, dynamic> json) {
    return ProducteModel(
      Price: (json['price'] ?? 0.0).toDouble(),
      Title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      ImageAasset: json['imageAsset'] ?? '',
      count: json['count'] ?? 1,
      isFavorit: json['isFavorit'] ?? false,
    );
  }

  // Method to convert ProducteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'price': Price,
      'title': Title,
      'description': description,
      'category': category,
      'imageAsset': ImageAasset,
      'count': count,
      'isFavorit': isFavorit,
    };
  }
}