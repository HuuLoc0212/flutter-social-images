import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(23),
              topLeft: Radius.circular(40),
            ),
          ),
          isScrollControlled: false, // chi co the keo xuong
          isDismissible: true, // co the keo xuong va an vao auto out
          backgroundColor: Colors.white,
          context: context,
          builder: (context) => DraggableScrollableSheet(
            // initialChildSize: 0.4,
            // minChildSize: 0.2,
            // maxChildSize: 0.6,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Infomation',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Support',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Get Support',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Security and privacy',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        fixedSize: const Size(170, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                    ),
                    Container(
                      // alignment: Alignment.center,
                      child: Container(
                        color: Colors.white,
                        // height: 200,
                        // width: 150,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
