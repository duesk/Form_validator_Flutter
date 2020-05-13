import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:form_validation/src/bloc/login_bloc.dart';
export 'package:form_validation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider(){
    if(_instancia) 
  }

  final loginBloc = LoginBloc();


  Provider({Key key, Widget child})
    :super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)=> true;

  static LoginBloc of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }


}