import 'package:flutter/material.dart';
import 'package:Imagesio/models/category.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  final Function changeCategory;
  final Category category;
  const CategoryList(
      {Key? key, required this.changeCategory, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Provider.of<List<Category>>(context);
    return SizedBox(
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  changeCategory(categories[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    categories[index].title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: category.id == categories[index].id
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: category.id == categories[index].id
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
          itemCount: categories.length),
    );
  }
}
