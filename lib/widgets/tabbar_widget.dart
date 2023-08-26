import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/author.dart';
import 'package:provider/provider.dart';

class TabbarWidget extends StatefulWidget {
  final int index;
  final Function onChangedTab;
  const TabbarWidget({
    Key? key,
    required this.index,
    required this.onChangedTab,
  }) : super(key: key);

  @override
  State<TabbarWidget> createState() => _TabbarWidgetState();
}

class _TabbarWidgetState extends State<TabbarWidget> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = Provider.of<User?>(context);

    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(onPressed: null, icon: Icon(Icons.no_cell)),
    );

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        buildTabItem(
          index: 0,
          icon: const Icon(Icons.home),
        ),
        buildTabItem(
          index: 1,
          icon: const Icon(Icons.search),
        ),
        placeholder,
        buildTabItem(
          index: 2,
          icon: const Icon(Icons.notifications),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Author? author = Author.fromJson(snapshot.data.data());
                return GestureDetector(
                  onTap: () => widget.onChangedTab(3),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 16.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(author.avatar),
                      radius: widget.index == 3 ? 14.0 : 16.0,
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => widget.onChangedTab(3),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(36),
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                    )),
              );
            }),
      ]),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.blue : Colors.black,
      ),
      child: IconButton(
        onPressed: () => widget.onChangedTab(index),
        icon: icon,
        iconSize: isSelected ? 26.0 : 24.0,
      ),
    );
  }
}
