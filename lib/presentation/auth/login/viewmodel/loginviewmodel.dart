import 'dart:async';

import 'package:ecomme_app/presentation/base/baseviewmodel.dart';

class Loginviewmodel extends Baseviewmodel implements Loginviewmodelinputs, Loginviewmodeloutputs {

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  @override
  void dispose() {
    
    _userNameStreamController.close();
    _passwordStreamController.close();
    
  } 

  @override
  void start() {
    // TODO: implement start
  }

  ///////////////////////////////////////////
  ///
  ///
  /// Input functions
  ///
  ////////////////////////////////////////////
  ///
  ///
  @override
  SetPassword(String password) {
    // TODO: implement SetPassword
    throw UnimplementedError();
  }
  
  @override
  SetUsername(String username) {
    // TODO: implement SetUsername
    throw UnimplementedError();
  }

    @override
  login() {
    // TODO: implement login
    throw UnimplementedError();
  }
  
  @override
  Sink get inputPassword => _passwordStreamController.sink;
  
  @override
  Sink get inputUserName => _userNameStreamController.sink;
  



    ///////////////////////////////////////////
  ///
  ///
  /// Outputs functions
  ///
  ////////////////////////////////////////////
  ///
  ///
  @override
  // TODO: implement isPasswordValid
  Stream<bool> get isPasswordValid => _passwordStreamController.stream.map((password)=> _isPasswordValid(password));
  
  @override
  // TODO: implement isUserNameValid
  Stream<bool> get isUserNameValid => _passwordStreamController.stream.map((username)=> _isUserNameValid(username));
  

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String username) {
    return username.isNotEmpty;
  }
}

abstract class Loginviewmodelinputs{
  SetUsername(String username);
  SetPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
}

abstract class Loginviewmodeloutputs{
  Stream<bool> get isUserNameValid;
  Stream<bool> get isPasswordValid;
}