import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/mytext.dart';
import 'admin_get_data_controller.dart';

class AdminGetDataPage extends GetView<AdminGetDataController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: 'Uploaded Products',
          size: 18.sp,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AdminGetDataController>(
          init: AdminGetDataController(),
          builder: (logic) {
            return logic.adminData.isEmpty
                ? Center(child: Text('No Data'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: logic.adminData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = logic.adminData[index];

                      print(data.adminTitle);
                      print(data.adminDescription);

                      return Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kwhite,
                          boxShadow: [
                            BoxShadow(
                              color: kblack.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: 'Title:',
                                  color: kblack,
                                  size: 14.sp,
                                  weight: FontWeight.w700,
                                ),
                                MyText(
                                  text: data.adminTitle!,
                                  color: kblack,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: 'Category:',
                                  color: kblack,
                                  size: 14.sp,
                                  weight: FontWeight.w700,
                                ),
                                MyText(
                                  text: data.adminCategory!,
                                  color: kblack,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: 'Description:',
                                  color: kblack,
                                  size: 14.sp,
                                  weight: FontWeight.w700,
                                ),
                                MyText(
                                  text: data.adminDescription!,
                                  color: kblack,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: 'Price:',
                                  color: kblack,
                                  size: 14.sp,
                                  weight: FontWeight.w700,
                                ),
                                MyText(
                                  text: data.adminPrice!.toString(),
                                  color: kblack,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: data.adminImages!.map((imageFile) {
                                final imageUrl = imageFile.path;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) => Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16.sp),
                            GestureDetector(
                              onTap: () {
                                logic.deleteData(
                                    logic.adminData[index].adminUid!);
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: kblack,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: kwhite,
                                    ),
                                    SizedBox(width: 10.w),
                                    MyText(
                                      text: 'Delete Current Product',
                                      size: 14.sp,
                                      color: kwhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.sp),
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    logic.titleController.text =
                                        logic.adminData[index].adminTitle!;
                                    logic.descriptionController.text = logic
                                        .adminData[index].adminDescription!;
                                    logic.priceController.text = logic
                                        .adminData[index].adminPrice!
                                        .toString();
                                    return AlertDialog(
                                      title: Text('Edit Admin Item'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: logic.titleController,
                                            decoration: InputDecoration(
                                              labelText: 'Title',
                                            ),
                                          ),
                                          TextFormField(
                                            maxLines: 2,
                                            minLines: 1,
                                            controller:
                                                logic.descriptionController,
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                            ),
                                          ),
                                          TextFormField(
                                            controller: logic.priceController,
                                            decoration: InputDecoration(
                                              labelText: 'Price',
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await logic.editData(
                                              logic.adminData[index].adminUid!,
                                              {
                                                'adminTitle':
                                                    logic.titleController.text,
                                                'adminDescription': logic
                                                    .descriptionController.text,
                                                'adminPrice': int.parse(
                                                    logic.priceController.text),
                                              },
                                            );
                                            Navigator.of(context)
                                                .pop(); // Close the dialog after saving
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: kblack,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: kwhite,
                                    ),
                                    SizedBox(width: 10.w),
                                    MyText(
                                      text: 'Edit Current Product',
                                      size: 14.sp,
                                      color: kwhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }),
    );
  }
}
