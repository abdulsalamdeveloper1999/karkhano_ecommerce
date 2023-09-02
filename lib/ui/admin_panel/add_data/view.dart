import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/elevated_button.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/add_data/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/mytext.dart';
import '../admin_get_data/view.dart';
import 'cubit.dart';

class Add_dataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddDataCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<AddDataCubit>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Data'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Images',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropDownWidget(),
                  BlocConsumer<AddDataCubit, AddDataState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          cubit.pickFromGallery();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 15),
                          width: Get.width,
                          height: 150.h,
                          decoration: BoxDecoration(
                            color: kblack,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: cubit.images.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_rounded,
                                      color: kwhite,
                                    ),
                                    SizedBox(height: 10.h),
                                    MyText(
                                      text: 'Upload Upto 6 images',
                                      color: kwhite,
                                      size: 16.sp,
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: 'UPLOAD UP TO 6 PHOTOS',
                                          color: kwhite,
                                          fontFamily: '',
                                          size: 14.sp,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: kwhite,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            cubit.images.length, (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _edit(index, context);
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  cubit.images[index],
                                                  height: 75.h,
                                                  width: 85.w,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    MyText(
                                      text: 'Tap on images to edit them',
                                      color: kwhite,
                                      fontFamily: '',
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required*';
                      }
                      return null;
                    },
                    controller: cubit.titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required*';
                      }
                      return null;
                    },
                    controller: cubit.descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required*';
                      }
                      return null;
                    },
                    controller: cubit.priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter price',
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: Get.width,
                    height: 55,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(kblack),
                      ),
                      onPressed: () async {
                        if (cubit.formKey.currentState!.validate() &&
                            cubit.images.isNotEmpty) {
                          cubit.showCustomProgressDialog(context);
                          await cubit.addDataToFirestore();
                          cubit.hideCustomProgressDialog(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: kblack,
                            content: Text('All Fields and Images are Required'),
                          ));
                        }
                      },
                      child: MyText(
                        text: 'Submit',
                        color: kwhite,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  MyButton(
                      text: 'text',
                      onPress: () {
                        Get.to(() => AdminGetDataPage());
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _edit(int index, context) {
    final cubit = BlocProvider.of<AddDataCubit>(context);
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Remove Image'),
              onPressed: () {
                // remove the image at the given index
                cubit.removeImage(index);
                Get.back();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            isDefaultAction: true,
            onPressed: () => Get.back(),
          ),
        );
      },
    );
  }
}

class DropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AddDataCubit>(context);
    return DropdownButtonFormField(
      borderRadius: BorderRadius.circular(15),
      value: cubit.selectedOption,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required*';
        }
        return null;
      },
      onChanged: (newValue) {
        cubit.setDropValue(newValue);
        print(cubit.selectedOption);
      },
      items: cubit.options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}
