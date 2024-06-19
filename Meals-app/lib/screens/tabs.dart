
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/meals_provider.dart';
import 'package:todo_app/screens/categories.dart';
import 'package:todo_app/screens/filter.dart';
import 'package:todo_app/screens/main_drawer.dart';
import 'package:todo_app/screens/meals.dart';
import 'package:todo_app/models/meal.dart';

const initialFilters = {
  Filter.glutenFree:false,
  Filter.lactoseFree: false,
  Filter.vegetable:false,
  Filter.vegan:false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = initialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleFavoriteMealStatus(Meal meal) {
    // add meal or remove meal in the favorite
    //check parameter meal có trong _favorite hay không?
    // nếu có trả về true k thì ngược lại
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      //
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a favorite');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // trả về 1 giá trị fulture
    if (identifier == "Filters") {

      //result là map có key là enum(Filter) và value là boolean
     final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) =>  FiltersScreen(currentFilter: _selectedFilters)),
      );

     //Sử dụng để cập nhật món ăn khi lọc
     setState(() {
       _selectedFilters = result ?? initialFilters; //lấy result nếu result khác null còn không lấy giá trị của initialFilters.
     });

    }

  }

  @override
  Widget build(BuildContext context) {
    //thiết lập 1 trình lắng nghe make sure Build method thực thi lại
    //Khi nào mealsProvider thay đổi thì sẽ build lại
    final meals =  ref.watch(mealsProvider);
    //lọc bữa ăn trong dummy  lưu vào availableMeals
    final availableMeals = meals.where((meal) {
      // nếu chọn bữa ăn không có gluten và bữa ăn có gluten thì trả về false
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(_selectedFilters[Filter.vegetable]! && !meal.isVegetarian){
        return false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleFavoriteMealStatus,
      availableMeals: availableMeals,
    ); // mặc định ban đầu là CategorieScreen
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      // nếu
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavoriteMealStatus,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'favorites'),
        ],
      ),
    );
  }
}
