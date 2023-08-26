import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Imagesio/services/post.dart';
import 'package:Imagesio/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchString = TextEditingController();
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;

    if (isFirst == true) {
      // get argument only once
      searchString.text = arg['searchString'];
      setState(() {
        isFirst = false;
      });
    }

    handleSearch(String string) {
      setState(() {
        searchString.text = string;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: Text('keyword: ${searchString.text}'),
        centerTitle: true,
        foregroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.angleLeft, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(23)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      height: 30,
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchString,
                        onSubmitted: (value) {
                          handleSearch(value);
                        },
                        textInputAction: TextInputAction.go,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'I`m listening to what you need'),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: SingleChildScrollView(
                    child: FutureBuilder(
                  future: PostService().getPosts(searchString.text),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        // the number of columns
                        crossAxisCount: 2,
                        // vertical gap between two items
                        mainAxisSpacing: 8,
                        // horizontal gap between two items
                        crossAxisSpacing: 2,
                        itemBuilder: (context, index) {
                          return PostCard(post: snapshot.data[index]);
                        },
                      );
                    }
                    return Container();
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
