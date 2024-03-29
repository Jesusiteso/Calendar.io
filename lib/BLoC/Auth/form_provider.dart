import 'package:Calendar_io/BLoC/Auth/form_bloc.dart';
import 'package:flutter/material.dart';

class FormProvider extends InheritedWidget {
  final bloc = FormBloc();

  FormProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static FormBloc of(BuildContext context) {
    return ((context.inheritFromWidgetOfExactType(FormProvider) as FormProvider)
        .bloc);
  }
}
