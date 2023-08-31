import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/ui/splash/cubit.dart';
import 'package:e_commerce_store_karkhano/ui/splash/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'EncodeSansMedium',
          primarySwatch: generateMaterialColor(kblack),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Counter App',
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SplashCubit()..loadSplashData(),
            ),
          ],
          child: SplashPage(),
        ),
      ),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
// class CounterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final counterCubit = BlocProvider.of<CounterCubit>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Counter App')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Counter Value:',
//               style: TextStyle(fontSize: 20),
//             ),
//             BlocBuilder<CounterCubit, int>(
//               builder: (context, count) {
//                 return Text(
//                   '$count',
//                   style: TextStyle(fontSize: 40),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => counterCubit.increment(),
//                   child: Text('Increment'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => counterCubit.decrement(),
//                   child: Text('Decrement'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
