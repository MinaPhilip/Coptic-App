import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkeraza/helper/awesome_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/Componets_loginandsign/Signinbutton.dart';
import '../../widgets/Componets_loginandsign/Textfiled.dart';

final TextEditingController _passwordTextController = TextEditingController();
final TextEditingController _emailTextController = TextEditingController();
final TextEditingController _userNameTextController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');
Map<String, List<String>> categoryItems = {};
final List<String> roles = ['خادم', 'مخدوم'];
String? selectedRole;
String? selectedItem;
String? selectedCategory;

Future<bool> checkIfDocExists(String docId) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();
    return doc.exists;
  } catch (e) {
    return false;
  }
}

Future<void> fetchCategoryItems() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    for (var doc in querySnapshot.docs) {
      String category = doc.id;
      List<String> items = List<String>.from(doc['items']);
      categoryItems[category] = items;
    }
  } catch (e) {
    print('Error fetching category items: $e');
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      fetchCategoryItems(); // Fetch categories when the screen is initialized
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "حساب جديد",
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'mainfont'),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("اسم المستخدم", Icons.person_outline, false,
                    _userNameTextController, 100, false),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "عنوان البريد الالكتروني",
                    Icons.email_outlined,
                    false,
                    _emailTextController,
                    100,
                    false),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("كلمه السر", Icons.lock_outlined, true,
                    _passwordTextController, 100, false),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'اختار كنيستك',
                      labelStyle: TextStyle(fontFamily: 'mainfont')),
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                      selectedItem = null;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      showFailureSnackbar(context, 'خطأ', 'يجب ملئ البيانات');
                    }
                    return null;
                  },
                  items: categoryItems.keys.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(fontFamily: 'mainfont'),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                if (selectedCategory != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'اختار خدمتك',
                        labelStyle: TextStyle(fontFamily: 'mainfont')),
                    value: selectedItem,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an item';
                      }
                      return null;
                    },
                    items: categoryItems[selectedCategory!]!.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontFamily: 'mainfont'),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                if (selectedItem != null)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'خادم ام مخدوم ',
                        labelStyle: TextStyle(fontFamily: 'mainfont')),
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(fontFamily: 'mainfont'),
                        ),
                      );
                    }).toList(),
                  ),
                custom_button(context, () async {
                  if (_emailTextController.text.isEmpty ||
                      _passwordTextController.text.isEmpty ||
                      _userNameTextController.text.isEmpty) {
                    showFailureSnackbar(
                      context,
                      'البيانات غير مكتمله',
                      'يجب ملئ جميع البيانات الخاصة بك',
                    );
                  } else if (await checkIfDocExists(
                          _emailTextController.text) ==
                      true) {
                    showFailureSnackbar(
                      context,
                      'حسابك موجود بالفعل',
                      'يمكنك تسجيل الدخول عن طريق البريد الالكتروني وكلمة المرور الخاصة بك',
                    );
                  } else if (_emailTextController.text
                              .endsWith('@gmail.com') ==
                          false &&
                      _emailTextController.text.endsWith('@yahoo.com') ==
                          false &&
                      _emailTextController.text.endsWith('@outlook.com') ==
                          false &&
                      _emailTextController.text.endsWith('@hotmail.com') ==
                          false &&
                      _emailTextController.text.endsWith('@icloud.com') ==
                          false &&
                      _emailTextController.text.endsWith('@aol.com') == false &&
                      _emailTextController.text.endsWith('@live.com') ==
                          false) {
                    showFailureSnackbar(
                      context,
                      'خطأ في كتابه البريد الالكتروني',
                      'يجب ان ينتهي ب @',
                    );
                  } else if (_emailTextController.text.isNotEmpty &&
                      _passwordTextController.text.isNotEmpty &&
                      _userNameTextController.text.isNotEmpty &&
                      selectedCategory != null &&
                      selectedItem != null) {
                    var uuid = const Uuid();
                    users.doc(_emailTextController.text).set({
                      'name': _userNameTextController.text,
                      'email': _emailTextController.text,
                      'password': _passwordTextController.text,
                      'الكنيسه': selectedCategory!,
                      'الخدمه': selectedItem!,
                      'id': uuid.v4(),
                      'role': selectedRole!,
                    }).then((value) {
                      setState(() {
                        selectedCategory = null;
                        selectedItem = null;
                      });
                      _emailTextController.clear();
                      _passwordTextController.clear();
                      _userNameTextController.clear();
                      showSuccessSnackbar(
                        context,
                        'تم انشاء الحساب',
                        'تم انشاء حسابك بنجاح يمكنك تسجيل الدخول  ',
                      );

                      Get.offNamed('/login');
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to create user: ${error.toString()}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  } else {
                    showFailureSnackbar(
                      context,
                      'البيانات غير مكتمله',
                      'يجب ملئ جميع البيانات واختيار كنيستك وخدمتك',
                    );
                  }
                }, 'انشاء حساب'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
