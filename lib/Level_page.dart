import 'package:flutter/material.dart';
import 'package:logo_game/Sub_Level_Page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

import 'main.dart';
class Level_Page extends StatefulWidget {
  List percent;
  List winlist;
  List wincountlist;
  List pointslist;
  Level_Page(this.percent,this.winlist,this.wincountlist,this.pointslist);

  @override
  State<Level_Page> createState() => _Level_PageState();
}

class _Level_PageState extends State<Level_Page> {
  int level = 0;
  double wincnt = 0.0;
  List<double> wincountlist = [];
  List pointslist = [];
  List<double> percent = [];
  int l = 0;
  int p =0;

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
        child: Scaffold(
            appBar: AppBar(title: Text("choose level"),actions: [
              InkWell(onTap: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(backgroundColor: Colors.black,
                  title: Text("You Have Hints.",style: TextStyle(color: Colors.white),)
                  ,actions: [

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
            body: FutureBuilder(
                future: get(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState==ConnectionState.active) {
                    return Container(
                      alignment: Alignment.center,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTapUp: (details) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Sub_level_page(index,level,widget.pointslist);
                                  },
                                ));

                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue.shade900,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurStyle: BlurStyle.normal,
                                                  blurRadius: 2,
                                                  offset: Offset(1,1),
                                                  spreadRadius: 0.5)
                                            ]),
                                        child: Text("${widget.wincountlist[index]}/${5}",
                                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Text("Level ${index + 1}",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text("Points ${widget.wincountlist[index]*5}"),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            Expanded(
                                                child: Container(
                                                  //color: Colors.black12,
                                                    child: Container(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(15.0),
                                                        child: new LinearPercentIndicator(
                                                          width: 200,
                                                          lineHeight: 14.0,
                                                          percent: widget.wincountlist[index]/10*2,
                                                          // linearStrokeCap: LinearStrokeCap.roundAll,
                                                          backgroundColor: Colors.grey,
                                                          progressColor: Colors.blue,
                                                        ),
                                                      ),
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: data.l.length),
                    );
                  }
                  else {
                    return Container();
                  }
                })
        ),
        onWillPop: ()async{
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(title: Text("You want to exit this page"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return MyApp();
                      }));

                    }, child: Text("yes")),
                    TextButton(
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);

                          });

                        }, child: Text("No")),

                  ],
                );
              });
          return true;
        }
    );
  }
}