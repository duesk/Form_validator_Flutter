import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



import 'package:form_validation/src/model/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

  

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final productoProvider = new ProductosProvider();

  //importar foto declaraciones /////////////////////

  File foto;
  final picker = ImagePicker();

  //Final de foto declaraciones //////////////////////


  ProductoModel producto = new ProductoModel();

  bool _guardando = false;


  @override
  Widget build(BuildContext context) {

    // Recibir el argument enviado.
    final ProductoModel productArgument = ModalRoute.of(context).settings.arguments;
    if( productArgument != null ) {
      producto = productArgument;
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual ),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt ),
            onPressed: _tomarFoto,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                SizedBox(height: 15.0,),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _crearNombre(){

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Producto"
      ),
      onSaved: (newValue) => producto.titulo = newValue,
      validator: (value){
        if(value.length < 3 ){
          return "Ingrese el nombre del producto";

        }else{
          return null;
        }
      },
    );
    
  }

  Widget _crearPrecio(){

    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Precio"
      ),
      onSaved: (newValue) => producto.valor = double.parse(newValue),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{
          return "Sólo números";
        }
      },
    );
  }

  Widget _crearDisponible(){

    return SwitchListTile(
      value: producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.teal[400],
      onChanged: (value)=> setState((){
        producto.disponible = value;
      }) ,
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      color:  Colors.teal[400],
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: (_guardando) ? null : _sumit ,
    );
  }

  void _sumit(){

    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    
    setState(() {
      _guardando = true;
    });
    
    
    //Cuando el formulario es correcto /////////////
    print("ok");
    print("datos producto.valor      : ${producto.valor}");
    print("datos producto.titulo     : ${producto.titulo}");
    print("datos producto.disponible : ${producto.disponible }");


    if( producto.id == null ){
      productoProvider.crearProducto(producto);
    }else{
      productoProvider.editarProducto(producto);
    }

    
    mostrarSnackbar("Articulo actualizado");
    
    Navigator.pop(context);



  }

  void mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000)
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
  

  Widget _mostrarFoto(){
    //print("fotoURL: ${producto.fotoUrl}");
    if(producto.fotoUrl != null ){
      //TODO: 
      return Container();

    }else{
      if(foto != null){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0
        );

      }
      return Image.asset("assets/no-image.png");
    }
  }

  //Seleccionar fotografia de la galeria de foto del dispocitivo
  Future _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }


  // Tomar fotografia con la camara del dispocitivo
  Future _tomarFoto() async {
    _procesarImagen( ImageSource.camera );
  }



  _procesarImagen(ImageSource origen ) async {
    final pickedFile = await picker.getImage(source: origen );
    setState(() {
      if (pickedFile != null){

        foto = File(pickedFile.path);

      }
    });
  }

}