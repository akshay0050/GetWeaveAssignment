import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/enum/viewstate.dart';
import 'package:flutter_app/utility/utils.dart';
import 'package:flutter_app/view/base_view/base_model.dart';
import 'package:flutter_app/view/home_list/home_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginNotifierModel extends BaseModel {

  void checkLoginSession(BuildContext context) {
    setState(ViewState.Busy);
    final myDbObj = Hive.box(Utils.dbName);
    final data =  myDbObj.get(Utils.userNameKey,defaultValue: '');
    if(data.toString().isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeList()));
      });
    } else {
      setState(ViewState.Idle);
    }

  }
}