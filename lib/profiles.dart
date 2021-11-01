import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilesWidget extends StatelessWidget {
  final String nama;
  final num nim;
  final String image;
  final String kel;
  const ProfilesWidget({Key key, this.nim, this.nama, this.image, this.kel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: CircleAvatar(
        radius: 30,
        child: Text(kel),
      ),
      title: Text(
        nama,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 0.2),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        nim.toString(),
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 14,
            letterSpacing: 0.2),
      ),
    );
  }
}
