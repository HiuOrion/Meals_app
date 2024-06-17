import 'package:flutter/material.dart';
import 'package:todo_app/models/meal.dart';
import 'package:todo_app/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal,});

  final Meal meal;
  final void Function( Meal meal) onSelectMeal;

  String get complexityText {
    // get complexity ra rồi chuyển thành Text
    return meal.complexity.name[0]
            .toUpperCase() + // Chuyển chữ cái đầu thành hoa
        meal.complexity.name.substring(1); // nối phần chưẽ còn lại
  }
  String get  affordabilityText {
    // get complexity ra rồi chuyển thành Text
    return meal.affordability.name[0]
        .toUpperCase() + // Chuyển chữ cái đầu thành hoa
        meal.affordability.name.substring(1); // nối phần chưẽ còn lại
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge, // nội dung nào nằm ngoài Card thì bị cắt bỏ
      child: InkWell(
        onTap: (){
          onSelectMeal(meal);
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
            ),
            Positioned(
              //Hiện Container vào phía trên cùng của hình ảnh trên
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      //title chỉ được hiện tối đa 2 dòng
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // đảm bảo cho văn bản được bọc đúng cách
                      overflow: TextOverflow.ellipsis,
                      // very long text...
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                            label: '${meal.duration} min ',
                            icon: Icons.schedule),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                          label: complexityText,
                          icon: Icons.work,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                          label: affordabilityText,
                          icon: Icons.monetization_on,

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
