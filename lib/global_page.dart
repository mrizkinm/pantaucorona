import 'package:flutter/material.dart';
import 'package:pantaucorona/global_model.dart';
import 'package:pantaucorona/global_country_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pantaucorona/tentang2_page.dart';

class GlobalPage extends StatefulWidget {
  @override
  _GlobalPageState createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage> {
  int globalPositif = 0;
  int globalSembuh = 0;
  int globalMeninggal = 0;
  int globalAktif = 0;
  List<GlobalCountry> global = [];
  bool _sortGlobalAsc = true;
  bool _sortPositifAsc = true;
  bool _sortSembuhAsc = true;
  bool _sortMeninggalAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex;
  final formatter = new NumberFormat("#,###");
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool processpositif = false;
  bool processsembuh = false;
  bool processmeninggal = false;
  bool processaktif = false;
  bool processglobal = false;

  @override
  void initState() {
    super.initState();
    getPositif();
    getSembuh();
    getMeninggal();
    getAktif();
    getGlobal();
  }

  Future getPositif() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url = 'https://api.kawalcorona.com/positif/';
    processpositif = true;
    await http.get(url).then((onValue) {
      processpositif = false;
      var jsonObject = json.decode(onValue.body);
      var value = Global.fromJson(jsonObject);
      print('positif');
      setState(() {
        globalPositif = toInt(value.value);
      });
    }, onError: (err) {
      processpositif = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  Future getSembuh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url = 'https://api.kawalcorona.com/sembuh/';
    processsembuh = true;
    await http.get(url).then((onValue) {
      processsembuh = false;
      var jsonObject = json.decode(onValue.body);
      var value = Global.fromJson(jsonObject);
      print('sembuh');
      setState(() {
        globalSembuh = toInt(value.value);
      });
    }, onError: (err) {
      processsembuh = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  Future getMeninggal() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url = 'https://api.kawalcorona.com/meninggal/';
    processmeninggal= true;
    await http.get(url).then((onValue) {
      processmeninggal = false;
      var jsonObject = json.decode(onValue.body);
      var value = Global.fromJson(jsonObject);
      print('meninggal');
      setState(() {
        globalMeninggal = toInt(value.value);
      });
    }, onError: (err) {
      processmeninggal = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  Future getGlobal() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    String url =  'https://api.kawalcorona.com/';
    processglobal = true;
    await http.get(url).then((onValue) {
      processglobal = false;
      List responseJson = json.decode(onValue.body);
      var value = responseJson.map((m) => new GlobalCountry.fromJson(m)).toList();
      print('global');
      setState(() {
        global = value;
      });
    }, onError: (err) {
      processglobal = false;
      _showDialog('Gagal mendapatkan data');
    });
  }

  Future getAktif() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    processaktif = true;
    return new Future.delayed(new Duration(seconds: 2), () {
      processaktif = false;
      print('aktif');
      setState(() {
        globalAktif = globalPositif-(globalSembuh+globalMeninggal);
      });
    });
  }

  toInt(str) {
    String huruf = str.replaceAll(',', '');
    return int.parse(huruf);
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

  Widget generatePieChart() {
      globalAktif = globalPositif-(globalSembuh+globalMeninggal);
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
                  PieChart('Aktif', globalAktif),
                  PieChart('Sembuh', globalSembuh),
                  PieChart('Meninggal', globalMeninggal),
                ],
                // Set a label accessor to control the text of the arc label.
                labelAccessorFn: (PieChart row, _) => '${formatter.format(row.total)}',
              )
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
                _sortAsc = _sortGlobalAsc = sortAscending;
              } else {
                _sortColumnIndex = columnIndex;
                _sortAsc = _sortGlobalAsc;
              }
              global.sort((a, b) => a.attributes.countryRegion.compareTo(b.attributes.countryRegion));
              if (!_sortAsc) {
                global = global.reversed.toList();
              }
            });
          },
          label: Text('Negara')
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
              global.sort((a, b) => a.attributes.confirmed.compareTo(b.attributes.confirmed));
              if (!_sortAsc) {
                global = global.reversed.toList();
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
              global.sort((a, b) => a.attributes.recovered.compareTo(b.attributes.recovered));
              if (!_sortAsc) {
                global = global.reversed.toList();
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
              global.sort((a, b) => a.attributes.deaths.compareTo(b.attributes.deaths));
              if (!_sortAsc) {
                global = global.reversed.toList();
              }
            });
          },
          label: Text('Meninggal')
        ),
      ],
      rows: global.map(((element) => DataRow(
          cells: <DataCell>[
            DataCell(Text(element.attributes.countryRegion)),
            DataCell(Text(formatter.format(element.attributes.confirmed))),
            DataCell(Text(formatter.format(element.attributes.recovered))),
            DataCell(Text(formatter.format(element.attributes.deaths)))
          ],
        )),
      ).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Hero(
            tag: 'pc2',
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
                return Tentang2Page();
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
        getPositif();
        getSembuh();
        getMeninggal();
        getAktif();
        return getGlobal();
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
                      margin: EdgeInsets.fromLTRB(1, 0, 0, 10),
                      child: Text('Global', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700))
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
                                  child: processpositif ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(globalPositif), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
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
                                  child: processaktif ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(globalAktif), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
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
                                  child: processsembuh ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(globalSembuh), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
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
                                  child: processmeninggal ? SizedBox(height: 22.0, width: 22.0, child: Center(child: CircularProgressIndicator())) : Text(formatter.format(globalMeninggal), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))
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
                      child: processaktif ? SizedBox(height: 200.0, child: Center(child: CircularProgressIndicator())) : generatePieChart()
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
                      child: Text('Data Global', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))
                    ),
                    Card(
                      elevation: 5,
                      child: processglobal ? SizedBox(height: 200.0, width: MediaQuery.of(context).size.width * 1, child: Center(child: CircularProgressIndicator())) : SingleChildScrollView(scrollDirection: Axis.vertical, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: generateTable()))
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
}

class PieChart {
  final String kasus;
  final int total;

  PieChart(this.kasus, this.total);
}