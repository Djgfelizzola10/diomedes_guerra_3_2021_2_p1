import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:anime_app/helpers/api_helper.dart';
import 'package:anime_app/models/anime.dart';
import 'package:anime_app/models/data2.dart';
import 'package:anime_app/models/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:anime_app/components/loader_componet.dart';

class AnimeInfoScreen extends StatefulWidget {
  final Anime anime;

  AnimeInfoScreen({required this.anime});

  @override
  _AnimeInfoScreenState createState() => _AnimeInfoScreenState();
}

class _AnimeInfoScreenState extends State<AnimeInfoScreen> {
   bool _showLoader = false;
  late Data2 _data2;
  late Anime _anime;

  @override
  void initState() {
    super.initState();
    _anime=widget.anime;
    _getData2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${_anime.Name}'),
      ),
      body: Center(
        child: _showLoader 
          ? loaderComponent(text: 'Por favor espere...',) 
          : _getContent(),
      ),
    );
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showInfoAnime(),
        Expanded(
          child: _data2.fact.length == 0 ? _noContent() : _getListView(),
        ),
      ],
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getData2,
      child: ListView(
        children: _data2.fact.map((e) {
          return Card(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.fact,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
          );
        }).toList(),
      ), 
    );
  }

  Future<Null> _getData2() async {
    setState(() {
      _showLoader = true;
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

    Response response = await ApiHelper.getFact(_anime.Name);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
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
      _data2 = response.result;
    });
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'El anime no tiene hechos registrados',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _showInfoAnime() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: _data2.img,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                  placeholder: (context, url) => Image(
                    image: AssetImage('https://www.kananss.com/wp-content/uploads/2021/06/51-519068_loader-loading-progress-wait-icon-loading-icon-png-1.png'),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Total de hechos: ', 
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              _data2.totalFacts.toString(), 
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}