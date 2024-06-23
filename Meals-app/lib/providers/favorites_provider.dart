import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    //state là danh sách các meal hiện tại
    //state.contains(meal) kiểm tra meal truyền vào có trong meal hiện tại không
    //nếu meal đang kiểm tra có trong list favoriteMeal trả về true
    final mealIsFavorite = state.contains(meal);

    //nêú có thì cập nhật state = lọc giữ lại m có id khác với id đang xét(meal.id) rồi trả về m dạng danh sách
    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false; // xoas khỏi danh sách favorite thì false
    } else {
      state = [...state, meal]; // Lấy ra những phần tử hiện tại có trong state đẩy meal vào cuối danh sách đó
      return true; // thêm vào danh sách thì trả về true
    }
  }
}
final favoritesMealsProvider = StateNotifierProvider<FavoriteMealsNotifier, List<Meal>> ((ref) {
  return FavoriteMealsNotifier();
});