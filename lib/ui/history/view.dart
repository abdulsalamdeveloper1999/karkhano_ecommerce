import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/core/widgets/back_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/history/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/models/history_model.dart';
import '../admin_panel/order_status/logic.dart';
import 'cubit.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HistoryCubit()..getDataFromFirestore(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<HistoryCubit>(context);

    return SafeArea(
      child: DefaultTabController(
        length: 3, // Number of tabs (statuses)
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.97),
          appBar: AppBar(
            leading: MyBackButtonWidget(),
            centerTitle: true,
            title: Text('Ordered History'),
            bottom: TabBar(
              splashFactory: NoSplash.splashFactory,
              labelColor: kblack,
              labelStyle: TextStyle(fontSize: 16.sp),
              unselectedLabelColor: kblack.withOpacity(0.5),
              indicatorColor: kblack,
              tabs: [
                Tab(text: 'Pending'), // Tab for pending orders
                Tab(text: 'Processing'), // Tab for processing orders
                Tab(text: 'Completed'), // Tab for completed orders
              ],
            ),
          ),
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HistoryLoaded) {
                return TabBarView(
                  children: [
                    // Tab 1: Pending Orders
                    _buildOrderList(cubit.history, 'pending'),

                    // Tab 2: Processing Orders
                    _buildOrderList(cubit.history, 'processing'),

                    // Tab 3: Completed Orders
                    _buildOrderList(cubit.history, 'delivered'),
                  ],
                );
              } else if (state is HistoryError) {
                return Text('Error');
              } else {
                return Text('No State');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<HistoryModel> history, String status) {
    // Filter orders based on the specified status
    final filteredOrders =
        history.where((order) => order.status == status).toList();

    if (filteredOrders.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: filteredOrders.length,
        itemBuilder: (BuildContext context, int index) {
          final items = filteredOrders[index];

          return buildHistoryItem(items);
        },
      );
    } else {
      return Center(
        child: Text('No $status Orders'),
      );
    }
  }

  Widget buildHistoryItem(HistoryModel items) {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Order#',
                        size: 12.sp,
                        color: kblack.withOpacity(0.7),
                      ),
                      MyText(
                        text: items.collectionUid!.toUpperCase(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: 'Placed On ',
                        size: 12.sp,
                        color: kblack.withOpacity(0.7),
                      ),
                      MyText(
                        text:
                            Get.find<OrderStatusLogic>().formatTime(items.date),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ...List.generate(
              items.title!.length,
              (index) {
                final quantity = items.quantity![index];
                final totalPrice = items.price![index];
                final singleItemPrice = totalPrice / quantity;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child:
                                    CircularProgressIndicator(), // Add CircularProgressIndicator as a placeholder
                              ),
                              height: Get.width / 4,
                              width: Get.width / 4,
                              fit: BoxFit.cover,
                              imageUrl: items.images![index],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width / 2.5,
                                child: MyText(
                                  text: items.title![index],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              MyText(
                                text: 'Rs. ${singleItemPrice}',
                                weight: FontWeight.w700,
                              ),
                              SizedBox(height: 2.h),
                              MyText(
                                text: 'x ' + items.quantity![index].toString(),
                              )
                            ],
                          ),
                        ],
                      ),
                      MyText(
                        text: items.status!,
                        color: items.status == 'pending'
                            ? Colors.red
                            : items.status == 'processing'
                                ? Colors.blue
                                : Colors.green,
                        size: 14.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(text: items.quantity!.join('') + ' item, Total '),
                      MyText(
                        text: 'Rs. ' + items.price!.join(''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            items.status == 'pending'
                ? MyText(
                    text:
                        'Tracking code will be provided once the product ships.',
                    // You can customize the text and style accordingly
                  )
                : items.status == 'processing'
                    ? MyText(
                        text: 'Tracking Code: ' + items.trackingCode,
                        color: Colors.orange,
                      )
                    : SizedBox(),
          ],
        ),
      );
    });
  }
}
