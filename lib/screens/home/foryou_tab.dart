import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:Imagesio/models/category.dart';
import 'package:Imagesio/services/post.dart';
import 'package:Imagesio/widgets/category_list.dart';
import 'package:Imagesio/widgets/post_card.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({Key? key}) : super(key: key);

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab> {
  Category category = Category(id: '', imageUrl: '', title: '');

  void changeCategory(Category cate) {
    setState(() {
      category = cate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          CategoryList(changeCategory: changeCategory, category: category),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: PostService().getPosts(category.title),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
