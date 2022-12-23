import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  Future<List<Araba>> arabalarJsonOku() async {
    try {
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');

      var jsonArray = jsonDecode(okunanString);

      List<Araba> tumArabalar = (jsonArray as List)
          .map((arabaMap) => Araba.fromMap(arabaMap))
          .toList();

      return tumArabalar;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  String _title = 'Local Json İslemleri';

  late final Future<List<Araba>> _listeyiDoldur;

  @override
  void initState() {
    super.initState();
    _listeyiDoldur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    arabalarJsonOku();
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _title = 'Buton Tıklandı';
          });
        },
      ),
      body: FutureBuilder<List<Araba>>(
        future: _listeyiDoldur,
        initialData: [
          Araba(
              arabaAdi: 'mercedes',
              kurulusYil: 1988,
              ulke: 'almanya',
              model: [
                Model(modelAdi: 'modelAdi', fiyat: 1500, benzinli: false)
              ])
        ],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Araba> arabaListesi = snapshot.data!;

            return ListView.builder(
                itemCount: arabaListesi.length,
                itemBuilder: (context, index) {
                  Araba oankiAraba = arabaListesi[index];
                  return ListTile(
                    title: Text(oankiAraba.arabaAdi),
                    subtitle: Text(oankiAraba.ulke),
                    leading: CircleAvatar(
                      child: Text(
                        oankiAraba.model[0].fiyat.toString(),
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
