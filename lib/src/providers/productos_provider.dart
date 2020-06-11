
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:form_validation/src/model/producto_model.dart';

class ProductosProvider{

  final String _url = "https://flutter-test-b95a2.firebaseio.com";


  Future<bool> crearProducto( ProductoModel producto ) async{ 

    final url = "$_url/productos.json";

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode( resp.body );

    //print( decodedData );

    return true;
  }


  Future<bool> editarProducto( ProductoModel producto ) async{ 

    final url = "$_url/productos/${producto.id}.json";
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode( resp.body );
    //print( decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {

    final url = "$_url/productos.json";
    final resp = await http.get(url);
    print("cfrf4");


    final Map<String,dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if(decodedData == null) return [];

    decodedData.forEach((id, value) {
      final productoTemp = ProductoModel.fromJson(value);
      productoTemp.id = id;
      productos.add(productoTemp);
    });
    print("cfrf4");
    return productos;
  }

  Future<int> borrarProductos( String id ) async{
    
    final url = "$_url/productos/$id.json";
    final resp =  await http.delete(url);

  }



  Future<String> subirImage( File imagen ) async {

    final url = Uri.parse("https://api.cloudinary.com/v1_1/dql22gfad/image/upload?upload_preset=ml_default");
    
  }







}