import 'package:ecomme_app/presentation/ressourses/textmanager.dart';

class CategoriesData {
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        image: "https://lottie.host/3eb24622-7900-4a79-b04d-e8dd8857074d/peN3dYdBas.json",
        title: AppString.categories1,
        description: AppString.categories1description,
      ),
      CategoryModel(
        image: "https://lottie.host/aff75fb2-9c7e-4a09-b84a-797a3b1c4ae6/MGVtnuddAR.json",
        title: AppString.categories2,
        description: AppString.categories2description,
      ),
      CategoryModel(
        image: "https://lottie.host/f9914ba4-5cf4-4c74-af07-4107bd1dc76f/Z3Kbg4i7v0.json",
        title: AppString.categories3,
        description: AppString.categories3description,
      ),
      CategoryModel(
        image: "https://lottie.host/df0906a8-a856-4055-a1dd-422c63e401f1/LYG4sIAq2o.json",
        title: AppString.categories4,
        description: AppString.categories4description,
      ),
      CategoryModel(
        image: "https://lottie.host/7f51baed-0414-402c-9600-3b1b6fcaadbf/6tuU5Tij8F.json",
        title: AppString.categories5,
        description: AppString.categories5description,
      ),
      CategoryModel(
        image: "https://lottie.host/aff75fb2-9c7e-4a09-b84a-797a3b1c4ae6/MGVtnuddAR.json",
        title: AppString.categories6,
        description: AppString.categories6description,
      ),
    ];
  }
}

class CategoryModel {
  final String image;
  final String title;
  final String description;

  CategoryModel({
    required this.image,
    required this.title,
    required this.description,
  });
}