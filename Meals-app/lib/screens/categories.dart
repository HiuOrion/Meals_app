import 'package:flutter/material.dart';
import 'package:todo_app/data/dummy_data.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/meal.dart';
import 'package:todo_app/screens/meals.dart';
import 'package:todo_app/widgets/category_grid_items.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});


  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //Late là để nói biến sẽ init sau. Đảm bảo biến sẽ không null khi sử dụng
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //vsync giúp đồng bộ tần số các frame với tần số màn hình
    //AnimationController sẽ nhận được infor tốc độ khung hình để kích hoạt animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    //Lọc ra dummyMeals có id trùng với id của Category mà user chọn
    // Và sau đó .tolist để trả về danh sách
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
          //cách lấy ra các category trong dummy data
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: _animationController.drive( // chuyển từ 0,1 của bound sang trục x,y của offset
          Tween(
            begin: const Offset(0, 0.3), // bắt đầu từ 30% của Trục y
            end: const Offset(0, 0),  // kết thúc về gốc => dịch chuyển từ dưới lên trên
          ),
        ),
        child: child,
      ),
    );
  }
}
