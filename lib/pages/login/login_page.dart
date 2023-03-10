import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenStateList = <String>['login', 'register', 'resetPassword'];
    final screenState = useState('login');

    final isObscure = useState(true);

    final loginEmail = useState('');
    final loginPassword = useState('');
    final loginEmailController = useState(TextEditingController());
    final loginPassordController = useState(TextEditingController());

    final regiEmail = useState('');
    final regiPassword = useState('');
    final regiEmailController = useState(TextEditingController());
    final regiPassordController = useState(TextEditingController());

    final resetEmail = useState('');
    final resetEmailController = useState(TextEditingController());

    String changeEmail(String v) {
      if (screenState.value == 'login') {
        return loginEmail.value = v;
      } else if (screenState.value == 'register') {
        return regiEmail.value = v;
      } else {
        return resetEmail.value = v;
      }
    }

    TextEditingController returnEmailController() {
      if (screenState.value == 'login') {
        return loginEmailController.value;
      } else if (screenState.value == 'register') {
        return regiEmailController.value;
      } else {
        return resetEmailController.value;
      }
    }

    String changePassword(String v) {
      if (screenState.value == 'login') {
        return loginPassword.value = v;
      } else {
        return regiPassword.value = v;
      }
    }

    TextEditingController returnPasswordController() {
      if (screenState.value == 'login') {
        return loginPassordController.value;
      } else {
        return regiPassordController.value;
      }
    }

    void clearLoginText() {
      loginEmail.value = '';
      loginPassword.value = '';
      loginEmailController.value.clear();
      loginPassordController.value.clear();
      isObscure.value = true;
    }

    void clearRegisterText() {
      regiEmail.value = '';
      regiPassword.value = '';
      regiEmailController.value.clear();
      regiPassordController.value.clear();
      isObscure.value = true;
    }

    void clearResetText() {
      resetEmail.value = '';
      resetEmailController.value.clear();
      isObscure.value = true;
    }

    String selectButtonText() {
      if (screenState.value == 'login') {
        return '????????????';
      } else if (screenState.value == 'register') {
        return '????????????';
      } else {
        return '??????????????????????????????????????????';
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // ???????????????????????????????????????
              SizedBox(height: 103.h),
      
              // AppThemeIcon?????????
              SizedBox(
                height: 120.h,
                width: 120.h,
                child: Image.asset('assets/icon/c_logo.png'),
              ),
      
              // AppThemeIcon???TextField??????
              SizedBox(height: 40.h),
      
              // email???TextField
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 32, top: 16, right: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text('?????????????????????'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        title: TextFormField(
                          controller: returnEmailController(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: changeEmail,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      
              // Password???TextField
              Visibility(
                visible: screenState.value != 'resetPassword',
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 32, top: 16, right: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('???????????????'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32, right: 32),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: TextFormField(
                            obscureText: isObscure.value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    isObscure.value = !isObscure.value,
                              ),
                            ),
                            controller: returnPasswordController(),
                            onChanged: changePassword,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              // [????????????], [????????????], [??????????????????????????????????????????]????????????
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // ????????????
                      if (screenState.value == 'login') {
                        await AuthFire()
                            .loginFire(loginEmail.value, loginPassword.value);
                            
                        ref
                            .read(loginInfoProvider.notifier)
                            .login(FirebaseAuth.instance.currentUser?.uid);
                        // ????????????
                      } else if (screenState.value == 'register') {
                        await AuthFire().registerFire(
                          regiEmail.value,
                          regiPassword.value,
                        );
                        ref
                            .read(loginInfoProvider.notifier)
                            .login(FirebaseAuth.instance.currentUser?.uid);
                        // ??????????????????????????????????????????
                      } else if (screenState.value == 'resetPassword') {
                        await AuthFire().sendPasswordResetMailFire(
                          resetEmail.value,
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC62D70), Color(0xFF644777)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Text(selectButtonText()),
                    ),
                  ),
                ),
              ),
      
              // ????????????????????????????????????
              Visibility(
                visible: screenState.value == 'login',
                child: TextButton(
                  child: const Text('????????????????????????????????????'),
                  onPressed: () {
                    screenState.value = screenStateList[2];
                    clearLoginText();
                  },
                ),
              ),
              const Divider(
                indent: 32,
                endIndent: 32,
              ),
      
              // ???????????????
              Visibility(
                visible: screenState.value == 'login',
                child: TextButton(
                  child: const Text('????????????'),
                  onPressed: () {
                    // context.go('/loginPage/registerPage');
                    screenState.value = screenStateList[1];
                    clearLoginText();
                  },
                ),
              ),
      
              // ?????????????????????????????????
              Visibility(
                visible: screenState.value == 'register',
                child: TextButton(
                  child: const Text('???????????????????????????????????????????????????'),
                  onPressed: () {
                    screenState.value = screenStateList[0];
                    clearRegisterText();
                  },
                ),
              ),
      
              // ???????????????????????????????????????
              Visibility(
                visible: screenState.value == 'resetPassword',
                child: TextButton(
                  child: const Text('??????'),
                  onPressed: () {
                    screenState.value = screenStateList[0];
                    clearResetText();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
