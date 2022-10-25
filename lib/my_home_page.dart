import 'package:flutter/material.dart';
import 'data_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String dataBoxName = "data";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'TODO App Using Hive',
      theme: ThemeData(
        primarySwatch: Colors.teal,

      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum DataFilter { ALL, COMPLETED, PROGRESS }

class _MyHomePageState extends State<MyHomePage> {
  late Box<DataModel> dataBox;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DataFilter filter = DataFilter.ALL;

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true,leading: IconButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Make a good list and chase your dreams!!'),backgroundColor: Colors.teal
          ),
        );
        }, icon: Icon(Icons.menu)),
          automaticallyImplyLeading: false,

          title: Text("Atomic Habits"),
          actions: <Widget>[
            PopupMenuButton<String>(elevation: 10,position: PopupMenuPosition.over,tooltip: "Filter",
              onSelected: (value) {
                if (value.compareTo("All") == 0) {
                  setState(() {
                    filter = DataFilter.ALL;
                  });
                } else if (value.compareTo("Completed") == 0) {
                  setState(() {
                    filter = DataFilter.COMPLETED;
                  });
                } else {
                  setState(() {
                    filter = DataFilter.PROGRESS;
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return ["All", "Completed", "Progress"].map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            )
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: dataBox.listenable(),

                builder: (context, Box<DataModel> items, _) {
                  List<int> keys;

                  if (filter == DataFilter.ALL) {
                    keys = items.keys.cast<int>().toList();
                  } else if (filter == DataFilter.COMPLETED) {
                    keys = items.keys.cast<int>().where((key) =>
                    items.get(key)!
                        .complete).toList();
                  } else {
                    keys = items.keys.cast<int>().where((key) =>
                    !items.get(key)!
                        .complete).toList();
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),

                    itemCount: keys.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final DataModel? data = items.get(key);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.grey[250],
                        child: ListTile(
                          title: Center(
                            child: Text(data!.title,
                              style: TextStyle(fontSize: 22, color: Colors.brown),),
                          ),
                          subtitle: Text(data.description, style: TextStyle(
                              fontSize: 20, color: Colors.black,fontStyle: FontStyle.italic)),
                          leading: Text("$key",
                            style: TextStyle(fontSize: 18, color: Colors.black),),
                          trailing: Icon(Icons.check_circle_outline,size: 40, color: data.complete
                              ? Colors.green
                              : Colors.blueAccent,),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .lightGreen,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadiusDirectional
                                                            .circular(10))),
                                                onPressed: () {
                                                  DataModel mData = DataModel(
                                                      title: data.title,
                                                      description: data
                                                          .description,
                                                      complete: true
                                                  );
                                                  dataBox.put(key, mData);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Finished",
                                                  style: TextStyle(
                                                      color: Colors.black87),)),ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .redAccent,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadiusDirectional
                                                            .circular(10))),
                                                onPressed: () {
                                                   DataModel(
                                                      title: data.title,
                                                      description: data
                                                          .description,
                                                      complete: true
                                                  );
                                                  dataBox.delete(key);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Remove",
                                                  style: TextStyle(
                                                      color: Colors.black87),))
                                          ],
                                        ),
                                      )
                                  );
                                }
                            );
                          },
                        ),
                      );
                    },

                  );
                },
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(elevation: 10,
          onPressed: () {
            showDialog(
                context: context,
                 builder: (BuildContext context) { return Dialog(

                     backgroundColor: Colors.white,
                     child: Container(
                       padding: EdgeInsets.all(16),
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: <Widget>[
                           TextField(
                             decoration: InputDecoration(hintText: "Title"),
                             controller: titleController,
                           ),
                           SizedBox(
                             height: 8,
                           ),
                           TextField(
                             decoration: InputDecoration(hintText: "Description"),
                             controller: descriptionController,
                           ),
                           SizedBox(
                             height: 8,
                           ),
                           TextButton(style:ElevatedButton.styleFrom(elevation: 5,
                               backgroundColor: Colors
                                   .teal,
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadiusDirectional
                                       .circular(30))),
                             child: Text("Start", style: TextStyle(color: Colors
                                 .white,fontSize: 16),),
                             onPressed: () {
                               final String title = titleController.text;
                               final String description = descriptionController
                                   .text;
                               titleController.clear();
                               descriptionController.clear();
                               DataModel data = DataModel(title: title,
                                   description: description,
                                   complete: false);
                               dataBox.add(data);
                               Navigator.pop(context);
                             },
                           )
                         ],
                       ),
                     )
                 ); }
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}