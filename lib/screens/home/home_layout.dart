import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Imagesio/providers/screen_provider.dart';
import 'package:Imagesio/screens/home_page.dart';
import 'package:Imagesio/screens/notification_page.dart';
import 'package:Imagesio/screens/profile_page.dart';
import 'package:Imagesio/screens/search_page.dart';
import 'package:Imagesio/services/util.dart';
import 'package:Imagesio/widgets/tabbar_widget.dart';
import 'package:provider/provider.dart';

class HomeLayoutPage extends StatefulWidget {
  static const routeName = '/home';
  const HomeLayoutPage({Key? key}) : super(key: key);

  @override
  State<HomeLayoutPage> createState() => _HomeLayoutPageState();
}

class _HomeLayoutPageState extends State<HomeLayoutPage> {
  // int _currentIndex = 0;

  final pages = <Widget>[
    const HomePage(),
    const SearchPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    int _currentTab = context.watch<ScreenProvider>().currentTab;
    final screenProvider = Provider.of<ScreenProvider>(context);

    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    handleAdd(ImageSource source) async {
      File? image = await Util().getImage(source);

      if (image != null) {
        Navigator.pushNamed(context, 'add-post', arguments: {
          'image': image,
        });
      }
    }

    return Scaffold(
      body: pages[_currentTab],
      bottomNavigationBar: TabbarWidget(
        index: _currentTab,
        onChangedTab: screenProvider.changeTab,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !showFab,
        child: SpeedDial(
          backgroundColor: Colors.blue,
          icon: Icons.add,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.image),
              label: "Gallery",
              onTap: () => handleAdd(ImageSource.gallery),
            ),
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.camera),
              label: "Camera",
              onTap: () => handleAdd(ImageSource.camera),
            ),
          ],
          tooltip: 'Add',
        ),
      ),
    );
  }
}
