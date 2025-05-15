

import 'package:ecomme_app/presentation/base/baseviewmodel.dart';

class Storeviewmodel extends Baseviewmodel  implements Storeviewmodelinputs, Storeviewmodeloutputs {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void start() {
    // TODO: implement start
  }
}

abstract class Storeviewmodelinputs {
  void start();
  void dispose();
}
abstract class Storeviewmodeloutputs {
  // here we gonna put the outputs of the store view model 
  // like the producte list and the search bar 
  // and the filter 
  // and the sort 
  // and the pagination 
  // and the search bar 
  // and the filter 
  // and the sort 
  // and the pagination 
}