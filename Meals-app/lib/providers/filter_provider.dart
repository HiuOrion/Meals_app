import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetable, vegan }

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetable: false,
          Filter.vegan: false
        });
  void setFilters(Map<Filter, bool> choosenFilters){
    state = choosenFilters;
  }
  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive
    }; //Map mới sẽ bằng Map hiện tại và thêm filter vừa active ở cuối
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
    (ref) => FilterNotifier());

//Trả về danh sách các bữa ăn đã lọc 
final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider); //Nhận được thực hiện lại bất cứ khi nào mealsProvider thay đổi
  final activeFilters = ref.watch(filterProvider);
  return meals.where((meal) {
    // nếu chọn bữa ăn không có gluten và bữa ăn có gluten thì trả về false
    if(activeFilters[Filter.glutenFree]! && !meal.isGlutenFree){
      return false;
    }
    if(activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
      return false;
    }
    if(activeFilters[Filter.vegetable]! && !meal.isVegetarian){
      return false;
    }
    if(activeFilters[Filter.vegan]! && !meal.isVegan){
      return false;
    }
    return true;
  }).toList();

});