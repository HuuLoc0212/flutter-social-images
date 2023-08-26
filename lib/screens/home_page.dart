import 'package:flutter/material.dart';
import 'package:Imagesio/models/category.dart';
import 'package:Imagesio/screens/home/following_tab.dart';
import 'package:Imagesio/screens/home/foryou_tab.dart';
import 'package:Imagesio/services/post.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 1;

  final tabs = <Widget>[
    const FollowingTab(),
    const ForYouTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Category>>(
      create: (BuildContext context) => PostService().getCategories(),
      initialData: const [],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTab = 0;
                  });
                },
                child: Container(
                  decoration: _currentTab == 0
                      ? const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        )
                      : const BoxDecoration(),
                  child: Text(
                    'Following',
                    style: TextStyle(
                        fontWeight: _currentTab == 0
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 18.0,
                        color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
                width: 32,
                child: VerticalDivider(
                  color: Colors.grey[200],
                  thickness: 1.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentTab = 1;
                  });
                },
                child: Container(
                  decoration: _currentTab == 1
                      ? const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        )
                      : const BoxDecoration(),
                  child: Text(
                    'For you',
                    style: TextStyle(
                        fontWeight: _currentTab == 1
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 18.0,
                        color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Transform.rotate(
              angle: -45,
              child: const IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: null,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: tabs[_currentTab],
      ),
    );
  }
}
