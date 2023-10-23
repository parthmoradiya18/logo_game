import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logo_game/Sub_Level_Page.dart';
import 'package:logo_game/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

class Playing_Area extends StatefulWidget {
  int logo_ind;
  int perent_ind;
  List logos;
  List answer;
  List pointlist;

  Playing_Area(
      this.logo_ind, this.logos, this.perent_ind, this.answer, this.pointlist);

  @override
  State<Playing_Area> createState() => _Playing_AreaState();
}

class _Playing_AreaState extends State<Playing_Area> {
  int level = 0;
  PageController? controller;
  SharedPreferences? prefs;

  List tempbool = [];
  List input = [];
  List output = [];
  List tempans = [];
  List ansbreakout = [];
  List outputbreakout = [];
  List rendom = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
  ];
  List pos = [];
  String temp = "";
  int i = 0;
  int points = 0;
  bool process_open_temp = false;
  int bottomSelectedIndex = 0;
  int directlevel = 0;

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = MyApp.prefs!.getInt('level') ?? 0;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = MyApp.prefs!.getInt('level') ?? 0;
      controller!.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    level = widget.logo_ind;
    controller = PageController(initialPage: level);
    directlevel = MyApp.prefs!.getInt('level') ?? 0;
    output = List.filled(20, "");
    tempbool = List.filled(14, false);
    temp = widget.answer[level];
    for (int j = 0, k = 0; j < 15; j++) {
      if (j < temp.length) {
        input.add(temp[j]);
        ansbreakout.add(temp[j]);
      }
      if (j > temp.length) {
        input.add(rendom[k]);
        k++;
      }
    }
    process_open_temp = true;
    get();
  }

  get() async {
    MyApp.prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    setState(() {
      temp = widget.answer[level];
    });
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text("level ${level + 1}"),actions: [

          InkWell(onTap: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(backgroundColor: Colors.black,actions: [
                Column(children: [
                  Card(color: Colors.green.shade700,child: ListTile(title: Text("random letter"),),),
                  Card(color: Colors.green.shade700,child: ListTile(title: Text("category"),),),
                  Card(color: Colors.indigo.shade300,child: ListTile(title: Text("selected letter"),),),
                  Card(color: Colors.indigo.shade300,child: ListTile(title: Text("remove extra letters"),),),
                  Card(color: Colors.red.shade700,child: ListTile(title: Text("solve",style: TextStyle(color: Colors.white),),),),
                  Center(child: TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("close",style: TextStyle(color: Colors.white),)),)

                ],)
              ],);
            },);
          },child: Icon(Icons.important_devices)),SizedBox(width: 5,),
        ],),
        body: (process_open_temp)
            ? Container(
                child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    widget.logo_ind = value;
                  });
                  output = List.filled(20, "");
                  i = 0;
                  tempbool = List.filled(14, false);
                  level = value;
                  input.clear();
                  ansbreakout.clear();
                  outputbreakout.clear();
                  String temp = "";
                  temp = widget.answer[level];
                  for (int j = 0, k = 0; j < 15; j++) {
                    if (j < temp.length) {
                      input.add(temp[j]);
                      ansbreakout.add(temp[j]);
                    }

                    if (j > temp.length) {
                      input.add(rendom[k]);
                      k++;
                    }
                  }
                  setState(() {});
                },
                itemCount: data.ans1.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Image(
                                image:
                                    AssetImage("images/${widget.logos[level]}"),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 5, color: Colors.black),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white38,
                                    border: Border.all(
                                        color: Colors.black12, width: 1)),
                                child: (data.winlist[
                                            (widget.perent_ind * 5) + index] !=
                                        "win")
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              margin: EdgeInsets.all(30),
                                              height: 200,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              child: Wrap(
                                                runSpacing: 5,
                                                alignment: WrapAlignment.center,
                                                children: List.generate(
                                                    widget.answer[index]
                                                        .toString()
                                                        .length, (index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (output[index] != "") {
                                                        setState(() {
                                                          if (i > 0) {
                                                            output[index] = "";
                                                            outputbreakout
                                                                .removeAt(
                                                                    index);
                                                            tempbool[pos[
                                                                index]] = false;
                                                            pos.removeAt(index);
                                                            i--;
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: EdgeInsets.all(5),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueGrey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                Colors.blueGrey,
                                                                Colors.blueGrey
                                                                    .shade200,
                                                                Colors.blueGrey
                                                                    .shade400,
                                                                Colors.blueGrey
                                                              ])),
                                                      child: Text(
                                                        "${output[index]}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTapUp: (details) {
                                                  setState(() {
                                                    output =
                                                        List.filled(20, "");
                                                    outputbreakout.clear();
                                                    tempbool =
                                                        List.filled(14, false);
                                                    pos.clear();
                                                    i = 0;

                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: 50,
                                                  child: Icon(Icons.delete),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.blueGrey,
                                                            Colors.blueGrey
                                                                .shade200,
                                                            Colors.blueGrey
                                                                .shade400,
                                                            Colors.blueGrey
                                                            // Colors.grey.shade600,
                                                          ])),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              GestureDetector(
                                                onTapUp: (details) {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.all(3),
                                                  padding: EdgeInsets.all(3),
                                                  height: 50,
                                                  width: 140,
                                                  child: Text(
                                                    "Use hints",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.blueGrey,
                                                            Colors.blueGrey
                                                                .shade200,
                                                            Colors.blueGrey
                                                                .shade400,
                                                            Colors.blueGrey
                                                          ])),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              GestureDetector(
                                                onTapUp: (details) {
                                                  setState(() {
                                                    if (i > 0) {
                                                      output[i - 1] = "";
                                                      outputbreakout
                                                          .removeAt(i - 1);
                                                      tempbool[pos[i - 1]] =
                                                          false;
                                                      pos.removeAt(i - 1);
                                                      i--;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  width: 50,
                                                  child: Icon(
                                                    Icons
                                                        .arrow_circle_left_rounded,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.blueGrey,
                                                            Colors.blueGrey
                                                                .shade200,
                                                            Colors.blueGrey
                                                                .shade400,
                                                            Colors.blueGrey
                                                          ])),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: GridView.builder(
                                                itemCount: 14,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 7,
                                                        mainAxisSpacing: 5,
                                                        crossAxisSpacing: 5),
                                                itemBuilder: (context, a) {
                                                  return InkWell(
                                                      onTap: () async {
                                                        if (tempbool[a] !=
                                                            true) {
                                                          setState(() {
                                                            pos.add(a);
                                                            output[i] =
                                                                input[a];
                                                            outputbreakout
                                                                .add(input[a]);
                                                            tempbool[a] = true;
                                                            i++;

                                                          });
                                                        }
                                                        if ((listEquals(
                                                                ansbreakout,
                                                                outputbreakout)) &&
                                                            i == temp.length) {
                                                          print(
                                                              "You win this game");
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "You win this level"),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (ansbreakout ==
                                                                                outputbreakout)
                                                                              prefs!.setString("level${level}", "win");

                                                                            controller!.animateToPage(level + 1,
                                                                                duration: Duration(milliseconds: 200),
                                                                                curve: Curves.linear);
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            "Next")),
                                                                  ],
                                                                );
                                                              });
                                                          points = widget
                                                                      .pointlist[
                                                                  widget
                                                                      .perent_ind] +
                                                              20;
                                                          MyApp.prefs!.setInt(
                                                              'points${widget.perent_ind}',
                                                              points);

                                                          MyApp.prefs!.setString(
                                                              'level${widget.perent_ind}${level}',
                                                              "win");
                                                          MyApp.prefs!.setInt(
                                                              'level${widget.perent_ind}',
                                                              level + 1);

                                                        } else if ((listEquals(
                                                                    ansbreakout,
                                                                    outputbreakout) ==
                                                                false) &&
                                                            i == temp.length) {


                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Wrong Answer",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                          setState(() {
                                                            output =
                                                                List.filled(
                                                                    20, "");
                                                            outputbreakout
                                                                .clear();
                                                            tempbool =
                                                                List.filled(
                                                                    20, false);
                                                            pos.clear();
                                                            i = 0;
                                                          });
                                                        }
                                                      },
                                                      child:
                                                          (tempbool[a] == true)
                                                              ? Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  height: 25,
                                                                  width: 25,
                                                                  child: Text(
                                                                      "",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(3)),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Text(
                                                                      "${input[a]}"),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .blueGrey),
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            Colors.blueGrey,
                                                                            Colors.blueGrey.shade200,
                                                                            Colors.blueGrey.shade400,
                                                                            Colors.blueGrey
                                                                          ])),
                                                                ));
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        height: 200,
                                        width: 400,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              level = MyApp.prefs!.getInt(
                                                      'level${widget.perent_ind}') ??
                                                  0;
                                              bottomTapped(level);
                                            });

                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Colors.blueGrey,
                                                  Colors.blueGrey.shade200,
                                                  Colors.blueGrey.shade400,
                                                  Colors.blueGrey
                                                ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text("Next",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15))),
                                        ),
                                      ))),
                      ],
                    ),
                  );
                },
              ))
            : CircularProgressIndicator(),
      ),
      onWillPop: () async {
        Navigator.pop(context, MaterialPageRoute(
          builder: (context) {
            return Sub_level_page(level, level, widget.pointlist);
          },
        ));
        return true;
      },
    );
  }
}
