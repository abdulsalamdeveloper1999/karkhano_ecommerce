import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/favorites/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'cubit.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FavoritesCubit()..getFavorites(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<FavoritesCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Favorites',
          size: 18.sp,
          fontFamily: 'EncodeSansSemiBold',
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            return Container(
              margin: EdgeInsets.only(top: 15),
              child: Center(
                child: cubit.fav.isNotEmpty
                    ? ListView.builder(
                        itemCount: cubit.fav.length,
                        itemBuilder: (BuildContext context, int index) {
                          final items = cubit.fav[index];
                          List<String> imageUrls = items.adminImages!
                              .map((file) => file.path)
                              .toList();
                          return BlocConsumer<FavoritesCubit, FavoritesState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (_) async {
                                  cubit.delFavorites(items.adminUid, index);
                                  print(items.adminUid);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      // color: kblack.withOpacity(0.2),
                                      ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.fill,
                                          imageUrl: imageUrls.first,
                                        ),
                                      ),
                                      SizedBox(width: Get.width * 0.04),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: items.adminTitle!,
                                            size: 14.sp,
                                            fontFamily: 'EncodeSansSemiBold',
                                          ),
                                          MyText(
                                            text: 'Dress modern',
                                            size: 10.sp,
                                            color: Color(0xffA4AAAD),
                                            fontFamily: 'EncodeSansRegular',
                                          ),
                                          Container(
                                            width: Get.width / 1.6,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: MyText(
                                                    text: '${items.adminPrice}',
                                                    size: 14.sp,
                                                    fontFamily:
                                                        'EncodeSansSemiBold',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Text('No Favorites Items'),
              ),
            );
          } else if (state is FavoriteError) {
            return Text('Error');
          } else {
            return Text('No State');
          }
        },
      ),
    );
  }
}
