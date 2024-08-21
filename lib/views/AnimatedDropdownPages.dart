import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AnimatedDropdownPages extends StatefulWidget {
  const AnimatedDropdownPages(
      {super.key,
      this.path,
      required this.title,
      this.file,
      required this.json});
  final String? path;
  final String title;
  final List<dynamic>? file;
  final bool json;

  @override
  AnimatedDropdownPagesState createState() => AnimatedDropdownPagesState();
}

class AnimatedDropdownPagesState extends State<AnimatedDropdownPages> {
  Future<List<dynamic>> _loadDatafromjson() async {
    final String jsonString = await rootBundle.loadString(widget.path!);
    return json.decode(jsonString);
  }

  Future<List<dynamic>> _loadDatafromdart() async {
    return widget.file!;
  }

  final ValueNotifier<int?> _selectedPageIndex = ValueNotifier<int?>(0);
  double? _selectedValue1 = 24.00;
  String? _selectedValue2 = 'اسود';

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "الاعدادات",
            style: const TextStyle(fontFamily: 'mainfont'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'حجم الخط',
                style: TextStyle(fontFamily: 'mainfont'),
              ),
              DropdownButton<double>(
                value: _selectedValue1,
                onChanged: (double? newValue) {
                  setState(() {
                    _selectedValue1 = newValue!;
                  });
                },
                items: <double>[12, 24, 36, 48, 60]
                    .map<DropdownMenuItem<double>>((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(fontFamily: 'mainfont'),
                    ),
                  );
                }).toList(),
              ),
              const Text(
                'لون الخط',
                style: TextStyle(fontFamily: 'mainfont'),
              ),
              DropdownButton<String>(
                value: _selectedValue2,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue2 = newValue!;
                  });
                },
                items: <String>['اسود', 'ابيض']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontFamily: 'mainfont'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(fontFamily: 'mainfont'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFDDB47E),
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'mainfont'),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showDialog()),
          ]),
      body: FutureBuilder<List<dynamic>>(
        future: widget.json ? _loadDatafromjson() : _loadDatafromdart(),
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
                                  style:
                                      const TextStyle(fontFamily: 'mainfont',),
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
                                      fontFamily: 'mainfont',height: 2.0),
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
