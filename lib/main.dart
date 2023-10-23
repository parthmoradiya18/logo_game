import 'dart:io';
import 'package:logo_game/Level_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,));
}

class MyApp extends StatefulWidget {
  static SharedPreferences? prefs;
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int  level = 0;
  List<double> percent = [];
  double wincnt = 0.0;
  List<double> wincountlist = [];
  List pointslist = [];
  int l = 0;
  int p =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data.winlist = List.filled(25, "");
    pointslist = List.filled(5,0);
    wincountlist = List.filled(20, 0.0);

  }
  Future<void> get()
  async {
    MyApp.prefs = await SharedPreferences.getInstance();

    for(int i=0;i<5;i++)
    {
      level = MyApp.prefs!.getInt('level${i}')??0;
      pointslist[i] = MyApp.prefs!.getInt('points${i}')??0;
      percent.add(level/data.ans1.length);
    }


    for (int main = 0; main < 5; main++) {
      for (int sub = 0; sub < 5; sub++) {
        data.winlist[l] = MyApp.prefs?.getString('level${main}${sub}');
        l++;
      }
    }


    for (int main = 0; main < 5; main++) {
      for (int sub = 0; sub < 5; sub++) {
        if(data.winlist[p]=="win")
        {
          wincnt++;
        }
        p++;
        wincountlist[main]=wincnt;
      }
      wincnt = 0;
    }
  }
  Widget build(BuildContext context) {

    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: get(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                margin:EdgeInsets.all(15) ,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("LOGO GAME",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        alignment: Alignment.centerLeft,
                                        child: Text("Quiz your brands knowledge",style: TextStyle(fontSize: 15,color: Colors.black)),

                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(color: Colors.white),
                              )),
                          Expanded(
                              flex: 5,
                              child: Container(
                                child: GestureDetector(onTapUp:(details) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return Level_Page(percent,data.winlist,wincountlist,pointslist);
                                  },));
                                },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text("PLAY",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold
                                    )),
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0,8),
                                              //  spreadRadius: 0,
                                              blurRadius: 5,
                                              blurStyle: BlurStyle.normal
                                          )
                                        ],
                                        gradient: LinearGradient(colors: [Colors.indigo.shade700,Colors.indigo.shade300]), shape: BoxShape.circle),
                                  ),
                                ),
                                decoration: BoxDecoration(color: Colors.white),
                              )),
                          Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(left: 12,right: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: InkWell(onTap: () {
                                        Share.share("MyApp", subject: 'Look what I made!');
                                        setState(() {});
                                      },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.leaderboard),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black12,width: 3),
                                              color: Colors.blue.shade700, shape: BoxShape.circle),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(onTap: () {
                                        Share.share("MyApp", subject: 'Look what I made!');
                                        setState(() {});
                                      },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.arrow_upward),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black12,width: 3),
                                              color: Colors.blue.shade700, shape: BoxShape.circle),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(onTap: () {
                                        Share.share("MyApp", subject: 'Look what I made!');
                                        setState(() {});
                                      },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.cabin),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black12,width: 3),
                                              color: Colors.blue.shade700, shape: BoxShape.circle),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                              ))
                        ],
                      ),
                    );
                  }
                  else {
                    return Container();
                  }
                })


        ),
      ),
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: Text("Do you want to exit"),
                actions: [
                  ElevatedButton(
                      onPressed: () =>

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return MyApp();
                            },
                          )),
                      child: Text("No")),
                  TextButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else {
                          exit(0);
                        }
                      },
                      child: Text("exit")),
                ],
              );
            });
             if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
    );
  }
}