import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_kel27/profiles.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kelompok 27',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.2),
        ),
        backgroundColor: Color(0xff1F1D2B),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfilesWidget(
            nama: 'Muhammad Yafi Alhakim',
            nim: 21120119130064,
            kel: "27",
          ),
          ProfilesWidget(
            nama: 'Farrel Ahmad Yudhitia',
            nim: 21120119130067,
            kel: "27",
          ),
          ProfilesWidget(
            nama: 'Elmar Leonard',
            nim: 21120119130064,
            kel: "27",
          ),
          ProfilesWidget(
            nama: 'Muhammad Farizan Kholis',
            nim: 21120119130064,
            kel: "27",
          )
        ],
      ),
    );
  }
}
