import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/enum/viewstate.dart';
import 'package:flutter_app/utility/utils.dart';
import 'package:flutter_app/view/base_view/base_view.dart';
import 'package:flutter_app/view/home_list/home_list.dart';
import 'package:flutter_app/view/login/login_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  String userName = '';
  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        resizeToAvoidBottomInset: false,
        body: BaseView<LoginNotifierModel>(
          onModelReeady: (model) => model.checkLoginSession(context),
          builder: (context, model, child) {
            return
              getPageState(context, model);
          },
        ),

    );
  }

  Widget getPageState(BuildContext context, LoginNotifierModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return const LinearProgressIndicator();
      case ViewState.Idle:
        return getMainView(context, model);
      default:
        return Container();
    }
  }

  Widget getMainView(BuildContext context, LoginNotifierModel model) {
    return Padding(padding: const EdgeInsets.all(8),
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: userNameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter User Name'),
                  onChanged: (text) => userName,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.greenAccent[200]),
                    onPressed: () async {
                      signIn(context);
                    },
                    child: Text("Sign in")),
              ),
            ],
          )
      ),
    );
  }


  Future<void> signIn(BuildContext context) async{
    userName = userNameController.text.toString();
    if(userName.isEmpty) {
      showSnackBar(context, 'Please Enter User Name');
      return;
    }
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async{
        if(user != null) {
          final myDbObj = Hive.box(Utils.dbName);
          await myDbObj.put(Utils.userNameKey, userName);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeList()));
        }
    });
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch(e) {
      showSnackBar(context, 'Unable to Login,Please Try Again');
    }
    catch(e) {
      showSnackBar(context, 'Unable to Login,Please check your Connection and Try Again');
    }

  }

  void showSnackBar(BuildContext context , String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),));
  }
}