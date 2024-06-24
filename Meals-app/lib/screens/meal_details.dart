import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/meal.dart';
import 'package:todo_app/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final favoriteMeals = ref.watch(favoritesMealsProvider);
     final isFavorite = favoriteMeals.contains(meal);
    //WidgetRef để lắng nghe những thay đổi của provider
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //vì đã có trình nghe là onPressed nên không cần ref.watch()
              final wasAdded = ref
                  .read(favoritesMealsProvider.notifier)
                  .toggleMealFavoriteStatus(meal);//Sử dụng toggle... qua notifier

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(wasAdded ? "Món ăn đã được thêm vào yêu thích." : "Món ăn đã xoá khỏi yêu thích." ),
                ),
              );
            },
            //Xét animation cho icon yêu thích
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // thời gian
              transitionBuilder: (child, animation) {
                //tất cả child đều là 1
                return RotationTransition(
                  turns: Tween(begin: 0.9, end: 1.0).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(
                  isFavorite,
                ),
              ),
            ),
          ),
        ],
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover, // Để có kích thước phù hợp không biến dạng
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Ingradient', // Nguyen liệu
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            for (final ingredients in meal.ingredients) Text(ingredients),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            for (final steps in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  steps,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
