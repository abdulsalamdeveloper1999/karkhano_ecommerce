import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/back_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/models/history_model.dart';

class OrderStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Get.find<OrderStatusLogic>().status.length,
      child: Scaffold(
        backgroundColor: kwhite.withOpacity(0.97),
        appBar: AppBar(
          leading: MyBackButtonWidget(),
          centerTitle: true,
          title: Text('Customer Orders'),
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            labelColor: kblack,
            labelStyle: TextStyle(fontSize: 16.sp),
            unselectedLabelColor: kblack.withOpacity(0.5),
            indicatorColor: kblack,
            tabs: [
              ...List.generate(
                Get.find<OrderStatusLogic>().status.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(Get.find<OrderStatusLogic>()
                      .status[index]
                      .toString()
                      .capitalizeFirst!),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingView(),
            ProcessingView(),
            DeliveredView(),
          ],
        ),
      ),
    );
  }
}

class PendingView extends StatelessWidget {
  const PendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderStatusLogic>(
      init: OrderStatusLogic(),
      initState: (_) {
        Get.find<OrderStatusLogic>().fetchPendingData();
      },
      builder: (logic) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: logic.pendingHistory.length,
          itemBuilder: (context, index) {
            final data = logic.pendingHistory[index];
            return Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // MyText(
                            //   text: 'Order',
                            //   size: 14.sp,
                            // ),
                            MyText(
                              text: 'Placed On ' + logic.formatTime(data.date),
                              size: 12.sp,
                              color: kblack.withOpacity(0.7),
                            ),
                          ],
                        ),
                        MyText(text: 'COD'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: data.images![0],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    text:
                                        data.title!.join('').capitalizeFirst!),
                                MyText(text: 'Rs.' + data.price!.join('')),
                                MyText(text: 'x ' + data.quantity!.join('')),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            MyText(
                              text: data.status!.capitalizeFirst!,
                              color: Colors.red,
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OrderConfirmWidget(data: data);
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: kblack,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: MyText(
                                  text: 'Update',
                                  fontStyle: FontStyle.italic,
                                  color: kwhite,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          text: '${data.quantity!.join('')}  item, Total  ',
                          size: 14.sp,
                          color: kblack.withOpacity(0.8),
                        ),
                        MyText(
                          text: logic.oneItemPrice(data.price!, data.quantity!),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ProcessingView extends StatelessWidget {
  const ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderStatusLogic>(
      init: OrderStatusLogic(),
      initState: (_) {
        Get.find<OrderStatusLogic>().fetchProcessingData();
      },
      builder: (logic) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: logic.processingHistory.length,
          itemBuilder: (context, index) {
            final data = logic.processingHistory[index];
            return Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // MyText(
                            //   text: 'Order',
                            //   size: 14.sp,
                            // ),
                            MyText(
                              text: logic.formatTime(data.date),
                              size: 12.sp,
                              color: kblack.withOpacity(0.7),
                            ),
                          ],
                        ),
                        MyText(text: 'COD'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: data.images![0],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    text:
                                        data.title!.join('').capitalizeFirst!),
                                MyText(text: 'Rs.' + data.price!.join('')),
                                MyText(text: 'x ' + data.quantity!.join('')),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            MyText(
                              text: data.status!.capitalizeFirst!,
                              color: Colors.red,
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OrderDeliveredWidget(
                                      data: data,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: kblack,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: MyText(
                                  text: 'Update',
                                  fontStyle: FontStyle.italic,
                                  color: kwhite,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          text: '${data.quantity!.join('')}  item, Total  ',
                          size: 14.sp,
                          color: kblack.withOpacity(0.8),
                        ),
                        MyText(
                          text: logic.oneItemPrice(data.price!, data.quantity!),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DeliveredView extends StatelessWidget {
  const DeliveredView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderStatusLogic>(
      init: OrderStatusLogic(),
      initState: (_) {
        Get.find<OrderStatusLogic>().fetchDeliveredData();
      },
      builder: (logic) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: logic.deliveredHistory.length,
          itemBuilder: (context, index) {
            final data = logic.deliveredHistory[index];
            return Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // MyText(
                            //   text: 'Order',
                            //   size: 14.sp,
                            // ),
                            MyText(
                              text: logic.formatTime(data.date),
                              size: 12.sp,
                              color: kblack.withOpacity(0.7),
                            ),
                          ],
                        ),
                        MyText(text: 'COD'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: data.images![0],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    text:
                                        data.title!.join('').capitalizeFirst!),
                                MyText(text: 'Rs.' + data.price!.join('')),
                                MyText(text: 'x ' + data.quantity!.join('')),
                              ],
                            )
                          ],
                        ),
                        MyText(
                          text: data.status!.capitalizeFirst!,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          text: '${data.quantity!.join('')}  item, Total  ',
                          size: 14.sp,
                          color: kblack.withOpacity(0.8),
                        ),
                        MyText(
                          text: logic.oneItemPrice(data.price!, data.quantity!),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class OrderConfirmWidget extends StatelessWidget {
  OrderConfirmWidget({
    super.key,
    required this.data,
  });

  HistoryModel data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Status: '),
          Text(
            '${data.status!.capitalizeFirst!}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: Get.find<OrderStatusLogic>().trackingController,
            decoration: InputDecoration(
              hintText: 'Tracking Code',
              labelText: 'Tracking Code',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.find<OrderStatusLogic>().trackingController.clear();
            Get.back();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (Get.find<OrderStatusLogic>()
                .trackingController
                .text
                .isNotEmpty) {
              await Get.find<OrderStatusLogic>()
                  .updateStatusAndTrackingCode(
                data.collectionUid!,
              )
                  .then((value) {
                Get.find<OrderStatusLogic>().fetchPendingData();
                print(data.collectionUid);
                Navigator.pop(context);
              });
            } else {
              Get.rawSnackbar(
                duration: Duration(milliseconds: 800),
                titleText: MyText(
                  text: 'Required',
                  color: kwhite,
                ),
                messageText: MyText(
                  text: 'Provide Tracking Code',
                  color: kwhite,
                ),
              );
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class OrderDeliveredWidget extends StatelessWidget {
  OrderDeliveredWidget({
    super.key,
    required this.data,
  });

  HistoryModel data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Status: '),
          Text(
            '${data.status!.capitalizeFirst!}',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.find<OrderStatusLogic>().trackingController.clear();
            Get.back();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () async {
            await Get.find<OrderStatusLogic>()
                .updateDelivered(
              data.collectionUid!,
            )
                .then((value) {
              Get.find<OrderStatusLogic>().fetchProcessingData();
              print(data.collectionUid);
              Navigator.pop(context);
            });
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
