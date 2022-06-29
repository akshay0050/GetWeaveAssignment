import 'package:flutter/material.dart';
import 'package:flutter_app/locators/locator.dart';
import 'package:flutter_app/view/base_view/base_model.dart';
import 'package:provider/provider.dart';


class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T) onModelReeady;

  BaseView({
    required this.builder,
    required this.onModelReeady,
  });

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReeady != null) {
      widget.onModelReeady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (BuildContext context) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
