// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
// import 'package:e_commerce_store_karkhano/ui/home/cubit.dart';
// import 'package:e_commerce_store_karkhano/ui/home/state.dart';
// import 'package:e_commerce_store_karkhano/ui/product_detail/view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../core/constants.dart';
// import '../../core/widgets/mytext.dart';
// import '../../core/widgets/staggered_widget.dart';
//
// class AllItemsWidget extends StatelessWidget {
//   const AllItemsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final _cubit = BlocProvider.of<HomeCubit>(context);
//     return BlocProvider<HomeCubit>(
//       create: (context) => HomeCubit()..fetchData(),
//       child: Container(
//         // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
//         margin: EdgeInsets.only(top: 32, left: 24, right: 24),
//         height: Get.height,
//         child: BlocBuilder<HomeCubit, HomeState>(
//           builder: (context, state) {
//             if (state is HomeLoaded) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: kblack,
//                 ),
//               );
//             } else if (state is HomeGetLoaded) {
//               final adminData = state.data;
//               return StaggeredDualView(
//                 mainAxisSpacing: 20.0,
//                 aspectRatio: 0.45,
//                 spacing: 20.0,
//                 itemBuilder: (context, index) {
//                   // return ProductCardWidget(
//                   //   onTap: () {
//                   //     Get.to(() => ProductDetailPage());
//                   //   },
//                   // );
//                   return ProductWidget(
//                     adminData: adminData,
//                     index: index,
//                   );
//                 },
//                 itemCount: adminData.length,
//               );
//             } else if (state is HomeDataError) {
//               return Center(
//                 child: Text(
//                   'Error: ${state.error}',
//                   style: TextStyle(color: kblack),
//                 ),
//               );
//             } else {
//               return Center(
//                 child: Text(
//                   'Unknown state',
//                   style: TextStyle(color: kblack),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class ProductWidget extends StatelessWidget {
//   ProductWidget({
//     super.key,
//     required this.adminData,
//     required this.index,
//   });
//
//   final List<AdminModel> adminData;
//   int index;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: kwhite,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(14),
//               child: Stack(
//                 fit: StackFit.passthrough,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.to(() => ProductDetailPage(
//                             adminData: adminData[index],
//                           ));
//                     },
//                     child: Column(
//                       children: [
//                         // Access the first image from adminData[0].adminImages
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(14),
//                           child: CachedNetworkImage(
//                             height: Get.height / 3,
//                             fit: BoxFit.cover,
//                             imageUrl: adminData[index]
//                                 .adminImages![0]
//                                 .path, // Assuming adminImages is a list of File objects
//                             placeholder: (context, url) =>
//                                 Center(child: CircularProgressIndicator()),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: kblack,
//                       child: Icon(
//                         Icons.favorite_border_rounded,
//                         color: kwhite,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 8.h),
//                 MyText(
//                   text: adminData[index].adminTitle!,
//                   size: 14.sp,
//                   fontFamily: 'EncodeSansSemiBold',
//                 ),
//                 // SizedBox(height: 4.h),
//                 // MyText(
//                 //   text: 'Dress modern',
//                 //   size: 10.sp,
//                 //   fontFamily: 'EncodeSansRegular',
//                 //   color: Color(0xffA4AAAD),
//                 // ),
//                 SizedBox(height: 8.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     MyText(
//                       text: 'Rs. ${adminData[index].adminPrice}',
//                       size: 14.sp,
//                       fontFamily: 'EncodeSansSemiBold',
//                     ),
//                     Row(
//                       children: [
//                         MyText(
//                           text: '5.0',
//                           size: 12.sp,
//                           fontFamily: 'EncodeSansRegular',
//                           color: Color(0xffA4AAAD),
//                         ),
//                         Icon(
//                           Icons.star,
//                           color: Color(0xffFFD33C),
//                         )
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
