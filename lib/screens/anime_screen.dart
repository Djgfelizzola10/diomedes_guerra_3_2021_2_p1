import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:anime_app/components/loader_componet.dart';
import 'package:anime_app/helpers/api_helper.dart';
import 'package:anime_app/models/data.dart';
import 'package:anime_app/models/response.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeScreen extends StatefulWidget {

  const AnimeScreen();

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
bool _isFiltered=false;
String _search='';
bool _showLoader=false;
late Data _data;

 @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Animes - The anime revolution'),
        actions: <Widget>[
          _isFiltered
          ?IconButton(
            onPressed: _removeFilter,
            icon: Icon(Icons.filter_none)
            )
            :IconButton(
            onPressed: _showFilter,
            icon: Icon(Icons.filter_alt)
            )
        ],
      ),
      body: Center(
        child:_showLoader ? loaderComponent(text: 'Por favor espere...') 
        : _getContent(),
      ),
    );
  }
  
   Future<Null> _getData() async{

    setState(() {
      _showLoader=true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response=await ApiHelper.getAnimes();

    setState(() {
      _showLoader=false;
    });

    if(!response.isSuccess){
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]
        );
        return;
    }

    setState(() {
      _data=response.result;
    });
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child: _data.animes.length == 0 ? _noContent() : _getListView(),
        ),
      ],
    );
}

Widget _getListView() {
   return RefreshIndicator(
      onRefresh: _getData,
      child: ListView(
        children: _data.animes.map((e) {
          return Card(
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: e.Img,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/noimage.png'),
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.Name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                    Icon(Icons.arrow_forward_ios, size: 40,)
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ), 
    );
 }

 Widget _noContent() {
   return Center(
     child: Container(
       margin: EdgeInsets.all(20),
       child: Text(
         _isFiltered
         ? 'No hay animes con ese criterio de busqueda.'
         :'No hay animes registradas',
         style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold
         ),
         ),
     ),
   );
 }

  

  void _removeFilter() {
    setState(() {
      _isFiltered=false;
    });
    _getData();
  }

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
            title: Text('Filtrar animes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras del anime a buscar'),
                SizedBox(height: 10,),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Criterio de busqueda...',
                    labelText: 'Buscar',
                    suffixIcon: Icon(Icons.search)
                  ),
                  onChanged: (value){
                      _search=value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: ()=> Navigator.of(context).pop(),
                child: Text('Cancelar')
                ),
                TextButton(
                onPressed: ()=> _filter(),
                child: Text('Filtrar')
                )
            ],
        );
      });
  }
  _filter() {}
}