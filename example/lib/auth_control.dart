import 'dart:math';

import 'package:code_field/code_field.dart';
import 'package:flutter_control/core.dart';

class AuthCodeModel extends BaseModel with ObservableComponent {
  final code = InputCodeControl();

  bool loading = false;
  String message;

  AuthCodeModel({String value, String regex}) {
    code.value = value;
    code.inputRegex = regex;
  }

  @override
  void init(Map args) {
    super.init(args);

    code.done(validate);
    code.focusNode.addListener(_onFocus);
  }

  void _onFocus() {
    message = null;
    notify();
  }

  void validate() async {
    if (!code.isFilled) {
      message = 'code not filled';
      notify();
      return;
    }

    code.unfocus();
    loading = true;
    message = null;
    notify();

    await Future.delayed(Duration(seconds: 2)); // simulate network call

    if (Random().nextBool()) {
      message = 'invalid code';
    } else {
      message = null;
    }

    loading = false;
    notify();
  }

  void toggleObscure() {
    code.setObscure(!code.isObscured);
  }

  @override
  void dispose() {
    super.dispose();

    code.dispose();
  }
}

class AuthControl extends BaseControl {
  final numberCode = AuthCodeModel();
  final stringCode = AuthCodeModel();
  final fancyCode = AuthCodeModel();

  @override
  void dispose() {
    super.dispose();

    numberCode.dispose();
    stringCode.dispose();
    fancyCode.dispose();
  }
}
