import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_todo_assignment/data_model.dart';
import'package:hive_todo_assignment/my_home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
void main()async{WidgetsFlutterBinding.ensureInitialized();
  final applicationDocumentDir=
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(applicationDocumentDir.path);
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>('data');
  runApp(MyApp());

}