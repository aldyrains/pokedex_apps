import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: GoogleFonts.poppins(),
          bodyMedium: GoogleFonts.poppins(),
          bodySmall: GoogleFonts.poppins(),
          titleLarge: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
          titleSmall: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
          displayLarge: GoogleFonts.fredoka(),
          displayMedium: GoogleFonts.fredoka(),
          displaySmall: GoogleFonts.fredoka(),
          labelLarge: GoogleFonts.baloo2(),
          labelMedium: GoogleFonts.baloo2(),
          labelSmall: GoogleFonts.baloo2(),
        ),
      ),
    );
  }
}
