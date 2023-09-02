import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/admin_get_data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/mytext.dart';
import 'cubit.dart';

class AdminGetDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminGetDataCubit()..fetchData(),
      child: _buildBody(),
    );
  }

  Scaffold _buildBody() {
    return Scaffold(
      backgroundColor: kwhite,
      body: BlocBuilder<AdminGetDataCubit, AdminGetDataState>(
        builder: (context, state) {
          if (state is AdminGetDataLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kblack,
              ),
            );
          } else if (state is AdminGetDataLoaded) {
            final adminData = state.data;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: adminData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    MyText(
                      text: adminData[index].adminTitle!,
                      color: kblack,
                    ),
                    MyText(
                      text: adminData[index].adminCategory!,
                      color: kblack,
                    ),
                    MyText(
                      text: adminData[index].adminDescription!,
                      color: kblack,
                    ),
                    MyText(
                      text: '${adminData[index].adminPrice!}',
                      color: kblack,
                    ),
                    Column(
                      children: adminData[index].adminImages!.map((imageFile) {
                        // Extract the URL from the File object
                        final imageUrl = imageFile.path;

                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          } else if (state is AdminGetDataError) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: TextStyle(color: kblack),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Unknown state',
                style: TextStyle(color: kblack),
              ),
            );
          }
        },
      ),
    );
  }
}
