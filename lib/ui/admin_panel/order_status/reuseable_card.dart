import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants.dart';
import '../../../core/models/history_model.dart';
import '../../../core/widgets/mytext.dart';
import 'logic.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({super.key, required this.data});

  final HistoryModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kwhite),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
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
                    text: data.collectionUid!.toUpperCase(),
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
                    text: Get.find<OrderStatusLogic>().formatTime(data.date),
                  ),
                ],
              ),
            ],
          ),
          ...List.generate(
            data.title!.length,
            (index) {
              final quantity = data.quantity![index];
              final totalPrice = data.price![index];
              final singleItemPrice = totalPrice / quantity;
              return Container(
                margin: EdgeInsets.only(bottom: 15.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Adjust the alignment as needed
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child:
                              CircularProgressIndicator(), // Add CircularProgressIndicator as a placeholder
                        ),
                        imageUrl: data.images![index],
                        height: Get.width / 4,
                        width: Get.width / 4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: data.title![index],
                            size: 14.sp,
                          ),
                          MyText(
                            text: 'Rs. ${singleItemPrice.toStringAsFixed(2)}',
                            size: 14.sp,
                            weight: FontWeight.bold,
                          ),
                          MyText(
                            text: 'x ' + data.quantity![index].toString(),
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: data.status!.capitalizeFirst!,
                color: Colors.red,
                size: 16.sp,
                fontStyle: FontStyle.italic,
              ),
              data.status != 'delivered'
                  ? GestureDetector(
                      onTap: data.status != 'delivered'
                          ? () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return data.status == 'pending'
                                      ? OrderConfirmWidget(data: data)
                                      : data.status == 'processing'
                                          ? OrderDeliveredWidget(data: data)
                                          : Container();
                                },
                              );
                            }
                          : null,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                    )
                  : SizedBox(),
            ],
          ),
          Wrap(
            alignment:
                WrapAlignment.spaceEvenly, // Set alignment to spaceEvenly
            children: [
              ...List.generate(
                data.quantity!.length,
                (quantityIndex) => Row(
                  children: [
                    MyText(
                      text: '${data.quantity![quantityIndex]}  item, Total  ',
                      size: 12.sp,
                      color: kblack.withOpacity(0.8),
                    ),
                    MyText(
                      text: data.price![quantityIndex].toString(),
                      size: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
