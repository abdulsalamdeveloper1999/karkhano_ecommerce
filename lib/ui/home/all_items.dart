import 'package:e_commerce_store_karkhano/ui/home/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../core/widgets/product_card_widget.dart';
import '../../core/widgets/staggered_widget.dart';
import '../product_detail/view.dart';

class AllItemsWidget extends StatelessWidget {
  const AllItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _cubit = BlocProvider.of<HomeCubit>(context);
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      margin: EdgeInsets.only(top: 32, left: 24, right: 24),
      height: Get.height,
      child: StaggeredDualView(
        mainAxisSpacing: 20.0,
        aspectRatio: 0.45,
        spacing: 20.0,
        itemBuilder: (context, index) {
          return ProductCardWidget(
            onTap: () {
              Get.to(() => ProductDetailPage());
            },
          );
        },
        itemCount: 15,
      ),
    );
  }
}
