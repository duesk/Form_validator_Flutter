
import 'dart:convert';
//import 'dart:html';
import 'dart:io';

import 'package:mime_type/mime_type.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
    final mimeType = mime(imagen.path).split("/");

    final imageUploadRequest = http.MultipartRequest(
      "post",
      url
    );

    final file = await http.MultipartFile.fromPath(
      "file",
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1])
    );
    
    imageUploadRequest.files.add(file);
    // imageUploadRequest.files.add(file); // SI necesitas subir mas archivos.


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode !=201){
      print("error algo no funciona: ");
      print(resp.body);
      return null;
    }

  }







}