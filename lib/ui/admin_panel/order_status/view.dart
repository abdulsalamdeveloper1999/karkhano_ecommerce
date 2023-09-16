import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/back_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/logic.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/reuseable_card.dart';
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
        backgroundColor: Colors.white.withOpacity(0.97),
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
                  child: Text(
                    Get.find<OrderStatusLogic>()
                        .status[index]
                        .toString()
                        .capitalizeFirst!,
                  ),
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
  const PendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderStatusLogic>(
      init: OrderStatusLogic(),
      initState: (_) {
        Get.find<OrderStatusLogic>().fetchPendingData();
      },
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.pendingHistory.length,
          itemBuilder: (context, index) {
            final data = logic.pendingHistory[index];

            return ReusableCard(data: data);
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
          itemCount: logic.processingHistory.length,
          itemBuilder: (context, index) {
            final data = logic.processingHistory[index];

            return ReusableCard(data: data);
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
          itemCount: logic.deliveredHistory.length,
          itemBuilder: (context, index) {
            final data = logic.deliveredHistory[index];

            return ReusableCard(data: data);
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
      title: ListTile(
        leading: Icon(Icons.watch_later_outlined, size: 24.h),
        title: Text(
          'Status: ',
          style: TextStyle(fontSize: 16.sp),
        ),
        subtitle: Text(
          '${data.status!.capitalizeFirst!}',
          style: TextStyle(color: Colors.red, fontSize: 14.sp),
        ),
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
          child: Text('Mark As Confirm'),
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
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: ListTile(
        leading: Icon(Icons.pending, size: 24.h),
        title: Text(
          'Status: ',
          style: TextStyle(fontSize: 16.sp),
        ),
        subtitle: Text(
          '${data.status!.capitalizeFirst!}',
          style: TextStyle(color: Colors.red, fontSize: 14.sp),
        ),
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
          child: Text('Mark As Delivered'),
        ),
      ],
    );
  }
}
