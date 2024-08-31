import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../../Data/prayers/begin_prayer.dart';
import '../../widgets/Componets_reading/dialogs.dart';

class AnimatedDropdownPages extends StatefulWidget {
  const AnimatedDropdownPages({
    super.key,
  });
  @override
  AnimatedDropdownPagesState createState() => AnimatedDropdownPagesState();
}

class AnimatedDropdownPagesState extends State<AnimatedDropdownPages> {
  final List arguments = Get.arguments;
  Future<List<dynamic>> _loadData() async {
    List<dynamic> jsonData = [];
    if (arguments[1]) {
      jsonData = await _loadDatafromjson();
      return [...beginPrayers, ...jsonData];
    } else {
      return _loadDatafromdart();
    }
  }

  Future<List<dynamic>> _loadDatafromjson() async {
    final String jsonString = await rootBundle.loadString(arguments[2]!);
    return json.decode(jsonString);
  }

  Future<List<dynamic>> _loadDatafromdart() async {
    return arguments[3]!;
  }

  final ValueNotifier<int?> _selectedPageIndex = ValueNotifier<int?>(0);
  double? _selectedValue1 = 24.00;
  String? _selectedValue2 = 'اسود';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFDDB47E),
          title: Text(
            arguments[0],
            style: const TextStyle(fontFamily: 'mainfont'),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => showSettingsDialog(
                      context,
                      _selectedValue1!,
                      _selectedValue2!,
                      (double newFontSize, String newTextColor) {
                        setState(() {
                          _selectedValue1 = newFontSize;
                          _selectedValue2 = newTextColor;
                        });
                      },
                    )),
          ]),
      body: FutureBuilder<List<dynamic>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final List<dynamic> pages = snapshot.data!;

            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;

                  if (details.primaryVelocity! > 0) {
                    if (_selectedPageIndex.value! < pages.length - 1) {
                      _selectedPageIndex.value = _selectedPageIndex.value! + 1;
                    }
                  } else if (details.primaryVelocity! < 0) {
                    if (_selectedPageIndex.value! > 0) {
                      _selectedPageIndex.value = _selectedPageIndex.value! - 1;
                    }
                  }
                },
                child: ListView(
                  children: [
                    ValueListenableBuilder<int?>(
                      valueListenable: _selectedPageIndex,
                      builder: (context, value, child) {
                        return DropdownButton<int?>(
                          value: value,
                          onChanged: (int? newIndex) {
                            _selectedPageIndex.value = newIndex;
                          },
                          items: List.generate(
                            pages.length,
                            (index) => DropdownMenuItem<int?>(
                              value: index,
                              child: Text(
                                pages[index]['name'],
                                style: const TextStyle(fontFamily: 'mainfont'),
                              ),
                            ),
                          ),
                          selectedItemBuilder: (context) {
                            return List.generate(
                              pages.length,
                              (index) => DropdownMenuItem<int?>(
                                value: index,
                                child: Text(
                                  pages[index]['name'].length > 25
                                      ? '${pages[index]['name'].substring(0, 25)}...'
                                      : pages[index]['name'],
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontFamily: 'mainfont',
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ValueListenableBuilder<int?>(
                      valueListenable: _selectedPageIndex,
                      builder: (context, value, child) {
                        return value != null
                            ? Container(
                                key: ValueKey<int>(value),
                                color: Colors.white24,
                                child: Text(
                                  pages[value]['text'],
                                  style: TextStyle(
                                      color: _selectedValue2 == 'ابيض'
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: _selectedValue1,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'mainfont',
                                      height: 2.0),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
