import 'dart:async';
import 'package:ecomme_app/domain/model/modeles.dart';
import 'package:ecomme_app/presentation/base/baseviewmodel.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:flutter/foundation.dart';

class Homeviewmodel extends Baseviewmodel implements HomeviewmodelInputs, HomeviewmodelOutputs {
  // Use a broadcast stream to support multiple listeners
  final StreamController<List<Categories>> _streamController = StreamController<List<Categories>>.broadcast();
  late List<Categories> _categoriesDataList;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    try {
      debugPrint('Homeviewmodel: start() called');
      _loadCategories();
    } catch (e, stackTrace) {
      debugPrint('Error in start(): $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void _loadCategories() {
    try {
      // Load categories data
      _categoriesDataList = _getCategoriesData();
      
      // Debug log the categories
      debugPrint('Categories loaded: ${_categoriesDataList.length}');
      
      // Output to UI immediately
      _postDataToView();
    } catch (e, stackTrace) {
      debugPrint('Error loading categories: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Make sure we add an empty list to avoid "no data" errors
      _categoriesDataList = [];
      _postDataToView();
    }
  }

  @override
  Stream<List<Categories>> get outputscategories => _streamController.stream;

  @override
  void goMoredeatil() {
    // Navigation logic here
  }

  List<Categories> _getCategoriesData() {
    debugPrint('Getting categories data...');
    
    // Explicitly define the URLs for debugging
    const String url1 = "https://lottie.host/3eb24622-7900-4a79-b04d-e8dd8857074d/peN3dYdBas.json";
    const String url2 = "https://lottie.host/aff75fb2-9c7e-4a09-b84a-797a3b1c4ae6/MGVtnuddAR.json";
    const String url3 = "https://lottie.host/f9914ba4-5cf4-4c74-af07-4107bd1dc76f/Z3Kbg4i7v0.json";
    const String url4 = "https://lottie.host/df0906a8-a856-4055-a1dd-422c63e401f1/LYG4sIAq2o.json";
    const String url5 = "https://lottie.host/7f51baed-0414-402c-9600-3b1b6fcaadbf/6tuU5Tij8F.json";
    const String url6 = "https://lottie.host/aff75fb2-9c7e-4a09-b84a-797a3b1c4ae6/MGVtnuddAR.json";
    
    // Create the list with hardcoded URLs for testing
    return [
      Categories(
        image: url1, // Use direct URL instead of AppImg.categories1
        title: AppString.categories1,
        description: AppString.categories1description,
      ),
      Categories(
        image: url2, // Use direct URL instead of AppImg.categories2
        title: AppString.categories2,
        description: AppString.categories2description,
      ),
      Categories(
        image: url3, // Use direct URL instead of AppImg.categories3
        title: AppString.categories3,
        description: AppString.categories3description,
      ),
      Categories(
        image: url4, // Use direct URL instead of AppImg.categories4
        title: AppString.categories4,
        description: AppString.categories4description,
      ),
      Categories(
        image: url5, // Use direct URL instead of AppImg.categories5
        title: AppString.categories5,
        description: AppString.categories5description,
      ),
      Categories(
        image: url6, // Use direct URL instead of AppImg.categories6
        title: AppString.categories6,
        description: AppString.categories6description,
      ),
    ];
  }

  @override
  Sink<List<Categories>> get inputCatgoriesView => _streamController.sink;

  void _postDataToView() {
    try {
      if (_streamController.isClosed) {
        debugPrint('Stream controller is closed, cannot add data');
        return;
      }
      
      debugPrint('Posting ${_categoriesDataList.length} categories to view');
      if (_categoriesDataList.isNotEmpty) {
        debugPrint('First category URL: ${_categoriesDataList.first.image}');
      }
      
      // Add the data to the stream
      inputCatgoriesView.add(_categoriesDataList);
      debugPrint('Data posted to stream successfully');
    } catch (e, stackTrace) {
      debugPrint('Error posting data to view: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  void setdata(int index) {
    if (index >= 0 && index < _categoriesDataList.length) {
      _postDataToView();
    }
  }

  @override
  int nbrOfcategories() => _categoriesDataList.length;
}

abstract class HomeviewmodelInputs {
  void setdata(int index);
  void goMoredeatil();
  int nbrOfcategories();
  Sink<List<Categories>> get inputCatgoriesView;
}

abstract class HomeviewmodelOutputs {
  Stream<List<Categories>> get outputscategories;
}

