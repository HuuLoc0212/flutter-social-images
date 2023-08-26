import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/category.dart';
import 'package:Imagesio/screens/search_screen.dart';
import 'package:Imagesio/services/post.dart';
import 'package:Imagesio/widgets/slider.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
];

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Category> trendings = [];
  List<Category> suggestions = [];

  TextEditingController searchString = TextEditingController();

  @override
  void initState() {
    getCategories() async {
      final cts = await PostService().getCategories();
      setState(() {
        cts.shuffle();
        trendings = cts.sublist(0, 4);
        suggestions = cts.sublist(5, 9);
      });
    }

    getCategories();
    super.initState();
  }

  handleSearch(String searchString) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: {'searchString': searchString});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[20],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 32.0,
                  top: 12.0,
                ),
                child: Text(
                  'Search',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.0,
                ),
                child: Container(
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
              ),
              const SizedBox(
                height: 16,
              ),
              CarouselWithDotsPage(imgList: imgList),

              // For you
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 35.0,
                ),
                child: Text(
                  'Suggestions for you',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              buildGridView(suggestions),

              // Trending
              const SizedBox(
                height: 8.0,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 35.0,
                ),
                child: Text(
                  'Trending',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              buildGridView(trendings),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildGridView(List<Category> list) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              handleSearch(list[index].title.toLowerCase());
            },
            child: Card(
              margin: const EdgeInsets.all(4.0),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: list[index].imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: 2 / 1,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  ClipRRect(
                    // Clip it cleanly.
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                      child: Container(
                        color: Colors.grey.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Text(
                          list[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
