

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/user_data_model.dart';
import 'package:flutter_app/repository/data_repository.dart';
import 'package:flutter_app/view/common_widget/user_data_card.dart';
import 'package:flutter_app/view/dialogs/add_data_dialog.dart';
import 'package:flutter_app/view/login/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../utility/utils.dart';


class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final DataRepository repository = DataRepository();
  final boldStyle =
      const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  String userName = '';

  @override
  void initState() {
    super.initState();
    final myDbObj = Hive.box(Utils.dbName);
    userName =  myDbObj.get(Utils.userNameKey, defaultValue: '');
  }

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $userName'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async{
              // do something
              bool isLogout = await showAlertDialog(context);
              if(isLogout) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: getDataFromDb(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addData(null);
        },
        tooltip: 'Add Details',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getDataFromDb(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          if(snapshot.hasError) return _errorWidget(context);

          return _buildList(context, snapshot.data?.docs ?? []);
        });
  }

  void _addData(final UserData? data) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AddDataDialog(userData: data,);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.length > 0 ? ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList().reversed.toList() ,
    ):
    noDataWidget(context);
  }

  Widget noDataWidget(BuildContext context) {
    return Center(
      child: Text("Please Add New Record", style: boldStyle,  ),
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Container(
      child:  Center(
        child: Container(
          alignment: Alignment.center,
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amber[300],
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 3),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ' Something went wrong. Please Try Again',
                style: const TextStyle(color: Colors.red,fontSize: 20),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                    child: Icon(Icons.refresh, color: Colors.white,),
                  onTap: () => getDataFromDb(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final userData = UserData.fromSnapshot(snapshot);

    return UserDataCard(userData: userData, boldStyle: boldStyle, onEdit: (UserData data) {
      _addData(data);
    }, onDelete: (UserData data) {
      repository.deleteUserData(userData);
    },);
  }

  Future showAlertDialog(BuildContext context) async{

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context,false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async{
        await repository.logoutUser();
        Navigator.pop(context,true);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Hey $userName Do you really want to Logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
