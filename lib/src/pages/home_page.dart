import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/model/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';


 

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),

    );
  }

  Widget _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.teal[400],
      onPressed: ()=>Navigator.pushNamed( context, "producto").then((value) => setState((){}))
    );
  }

  Widget _crearListado(){


    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context,AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i ) => _crearItem(context, productos[i]),
            
            );
        }else {
          return Center(
            child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _crearItem( BuildContext context,  ProductoModel producto){
    print("cfre3d3ed3e3f4");


    return Dismissible(
      key: UniqueKey(),
      background: _dissmissible(),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, "producto",arguments: producto)
          .then((value) => setState((){})), ///setState para recargar el Build
        title: Text("${producto.titulo} -  ${producto.valor}"),
        subtitle: Text("${producto.id}"),
      ),
      onDismissed: ( direction ){
        productosProvider.borrarProductos(producto.id);
      },
    );

  }

  Widget _dissmissible(){
    return Container(
      color: Colors.red,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:10.0),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(Icons.delete, color: Colors.white,),
      )
    );

  }
}



  /*
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Email: ${bloc.email}'),
              Text("Password: ${bloc.password}")
            ],
          ),
        ),
      );
  }
}
*/