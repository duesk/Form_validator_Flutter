
import 'dart:async';
import 'package:rxdart/rxdart.dart';


import 'package:form_validation/src/bloc/validators.dart';


class LoginBloc with Validators{


  // Para trabajar con los Stream 
  //final _emailControler     = StreamController<String>.broadcast();
  //final _passwordControler  = StreamController<String>.broadcast();

  // para trabajar co RXdart
  final _emailControler = BehaviorSubject<String>();
  final _passwordControler = BehaviorSubject<String>();




  //Recuperar datos del stream
  Stream<String> get emailStream => _emailControler.stream.transform(validarEmail); //obtiene el valor que fluye en el stream
  Stream<String> get passwordStream => _passwordControler.stream.transform(validarPassword);

  Stream<bool>   get formValidStream => 
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);
    //Observable.comb
    

  //insertar valores al stream
  Function(String)get changeEmail => _emailControler.sink.add; //Añade el valor al Stream
  Function(String)get changePassword => _passwordControler.sink.add;



  //Obtener el ultimo valo ingresado
  String get email =>_emailControler.value;
  String get password =>_passwordControler.value;

  dispose(){
    _emailControler?.close();
    _passwordControler?.close();
  }

}