import 'package:flutter/material.dart';
import 'package:pantaucorona/indonesia_model.dart';
import 'package:pantaucorona/provinsi_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pantaucorona/tentang_page.dart';

class IndonesiaPage extends StatefulWidget {
  @override
  _IndonesiaPageState createState() => _IndonesiaPageState();
}

class _IndonesiaPageState extends State<IndonesiaPage> {
  int indoPositif = 0;
  int indoSembuh = 0;
  int indoMeninggal = 0;
  int indoAktif = 0;
  List<Provinsi> provinsi = [];
  bool _sortProvinsiAsc = true;
  bool _sortPositifAsc = true;
  bool _sortSembuhAsc = true;
  bool _sortMeninggalAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;
  final formatter = new NumberFormat("#,###");
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool processall = false;
  bool processprov = false;

  @override
  void initState() {
    super.initState();
    getDataIndo();
    getProvinsi();
  }

  Future getDataIndo() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url = 'https://api.kawalcorona.com/indonesia/';
    processall = true;
    await http.get(url).then((onValue) {
      processall = false;
      var jsonObject = json.decode(onValue.body);
      var value = Indonesia.fromJson(jsonObject[0]);
      print('satu');
      setState(() {
        indoPositif = toInt(value.positif);
        indoSembuh = toInt(value.sembuh);
        indoMeninggal = toInt(value.meninggal);
        indoAktif = indoPositif-(indoSembuh+indoMeninggal);
      });
    }, onError: (err) {
      processall = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  toInt(str) {
    String huruf = str.replaceAll(',', '');
    return int.parse(huruf);
  }

  Future getProvinsi() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url =  'https://api.kawalcorona.com/indonesia/provinsi/';
    processprov = true;
    await http.get(url).then((onValue) {
      processprov = false;
      List responseJson = json.decode(onValue.body);
      var value = responseJson.map((m) => new Provinsi.fromJson(m)).toList();
      print('prov');
      setState(() {
        provinsi = value;
      });
    }, onError: (err) {
      processprov = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  void _showDialog(msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Error'),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Hero(
            tag: 'pc',
            child: Image(
              width: 40,
              image: AssetImage('assets/images/virus.png'),
              fit: BoxFit.contain
            ),
          ),
          onPressed: () {
              
          },
        ),
        title: Text('Pantau Corona', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TentangPage();
              }));
            },
          ),
        ],
      ),
      body: bodyWidget()
    );
  }

  double getSmallDiameter(BuildContext context) => MediaQuery.of(context).size.width * 2/3;
  double getBigDiameter(BuildContext context) => MediaQuery.of(context).size.width * 7/8;

  Widget bodyWidget() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        getDataIndo();
        return getProvinsi();
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -getSmallDiameter(context) / 3,
            top: -getSmallDiameter(context) / 3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
              ),
            ),
          ),
          Positioned(
            left: -getBigDiameter(context) / 4,
            top: -getBigDiameter(context) / 4,
            child: Container(
              width: getBigDiameter(context),
              height: getBigDiameter(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
              ),
            ),
          ),
          Positioned(
            right: -getSmallDiameter(context) / 4,
            bottom: -getSmallDiameter(context) / 4,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
              ),
            ),
          ),
          ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(2, 0, 0, 10),
                      child: Text('Indonesia', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700))
                    ),
                    Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text('TOTAL POSITIF'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: processall ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(indoPositif), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                                ),
                                Text('ORANG'),
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 65,
                                image: AssetImage('assets/images/positif.png'),
                                fit: BoxFit.contain
                              )
                            )
                          ),
                        ]
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text('TOTAL KASUS AKTIF'),
                                ),
                                  Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: processall ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(indoAktif), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                                ),
                                Text('ORANG'),
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 65,
                                image: AssetImage('assets/images/aktif.png'),
                                fit: BoxFit.contain
                              )
                            )
                          ),
                        ]
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text('TOTAL SEMBUH'),
                                ),
                                  Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: processall ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(indoSembuh), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                                ),
                                Text('ORANG'),
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 65,
                                image: AssetImage('assets/images/sembuh.png'),
                                fit: BoxFit.contain
                              )
                            )
                          ),
                        ]
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text('TOTAL MENINGGAL'),
                                ),
                                  Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: processall ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(indoMeninggal), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
                                ),
                                Text('ORANG'),
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 65,
                                image: AssetImage('assets/images/meninggal.png'),
                                fit: BoxFit.contain
                              )
                            )
                          ),
                        ]
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(2, 0, 0, 10),
                      child: Text('Data Statistik', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))
                    ),
                    Card(
                      elevation: 5,
                      child: processall ? SizedBox(height: 200.0, child: Center(child: CircularProgressIndicator())) : generatePieChart()
                    ),
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(2, 0, 0, 10),
                      child: Text('Data Provinsi', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))
                    ),
                    Card(
                      elevation: 5,
                      child: processprov ? SizedBox(height: 200.0, width: MediaQuery.of(context).size.width * 1, child: Center(child: CircularProgressIndicator())) : SingleChildScrollView(scrollDirection: Axis.vertical, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: generateTable()))
                    )
                  ],
                )
              )
            ],
          ),
        ]
      )
    );
  }

  Widget generatePieChart() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
          height: 200.0,
          child: charts.PieChart(
            [
              charts.Series<PieChart, String>(
                id: 'Kasus',
                domainFn: (PieChart dataChart, _) => dataChart.kasus,
                measureFn: (PieChart dataChart, _) => dataChart.total,
                data: [
                  PieChart('Aktif', indoAktif),
                  PieChart('Sembuh', indoSembuh),
                  PieChart('Meninggal', indoMeninggal),
                ],
                labelAccessorFn: (PieChart row, _) => '${formatter.format(row.total)}',
              ),
            ],
            animate: true,
            behaviors: [
              new charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                horizontalFirst: true,
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0, top: 4.0, left: 4.0),
              ),
            ],
            defaultRenderer: charts.ArcRendererConfig(
              arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.outside,
                outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 10, color: 
                  charts.Color.fromHex(code: "#000000")
                  )
                )
              ]
            )
          ),
        ),
      );
    }

    Widget generateTable() {
      return DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAsc,
        columns: [
          DataColumn(
            onSort: (columnIndex, sortAscending) {
              setState(() {
                if (columnIndex == _sortColumnIndex) {
                  _sortAsc = _sortProvinsiAsc = sortAscending;
                } else {
                  _sortColumnIndex = columnIndex;
                  _sortAsc = _sortProvinsiAsc;
                }
                provinsi.sort((a, b) => a.attributes.provinsi.compareTo(b.attributes.provinsi));
                if (!_sortAsc) {
                  provinsi = provinsi.reversed.toList();
                }
              });
            },
            label: Text('Provinsi', style: TextStyle(fontWeight: FontWeight.bold))
          ),
          DataColumn(
            onSort: (columnIndex, sortAscending) {
              setState(() {
                if (columnIndex == _sortColumnIndex) {
                  _sortAsc = _sortPositifAsc = sortAscending;
                } else {
                  _sortColumnIndex = columnIndex;
                  _sortAsc = _sortPositifAsc;
                }
                provinsi.sort((a, b) => a.attributes.kasusPosi.compareTo(b.attributes.kasusPosi));
                if (!_sortAsc) {
                  provinsi = provinsi.reversed.toList();
                }
              });
            },
            label: Text('Positif')
          ),
          DataColumn(
            onSort: (columnIndex, sortAscending) {
              setState(() {
                if (columnIndex == _sortColumnIndex) {
                  _sortAsc = _sortSembuhAsc = sortAscending;
                } else {
                  _sortColumnIndex = columnIndex;
                  _sortAsc = _sortSembuhAsc;
                }
                provinsi.sort((a, b) => a.attributes.kasusSemb.compareTo(b.attributes.kasusSemb));
                if (!_sortAsc) {
                  provinsi = provinsi.reversed.toList();
                }
              });
            },
            label: Text('Sembuh')
          ),
          DataColumn(
            onSort: (columnIndex, sortAscending) {
              setState(() {
                if (columnIndex == _sortColumnIndex) {
                  _sortAsc = _sortMeninggalAsc = sortAscending;
                } else {
                  _sortColumnIndex = columnIndex;
                  _sortAsc = _sortMeninggalAsc;
                }
                provinsi.sort((a, b) => a.attributes.kasusMeni.compareTo(b.attributes.kasusMeni));
                if (!_sortAsc) {
                  provinsi = provinsi.reversed.toList();
                }
              });
            },
            label: Text('Meninggal')
          ),
        ],
        rows: provinsi.map(((element) => DataRow(
            cells: <DataCell>[
              DataCell(Text(element.attributes.provinsi)),
              DataCell(Text(formatter.format(element.attributes.kasusPosi))),
              DataCell(Text(formatter.format(element.attributes.kasusSemb))),
              DataCell(Text(formatter.format(element.attributes.kasusMeni)))
            ],
          )),
        ).toList()
      );
    }

}

class PieChart {
  final String kasus;
  final int total;

  PieChart(this.kasus, this.total);
}