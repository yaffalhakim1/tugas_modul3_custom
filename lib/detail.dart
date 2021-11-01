import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final String title;
  final int item;
  DetailPage({
    Key key,
    this.title,
    this.item,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<AiringDetail> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1F1D2B),
        title: Text(
          'Details',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<AiringDetail>(
          future: detail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    //gambar gede
                    Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(snapshot.data.image),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.network(snapshot.data.image),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.title,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0.2),
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              Row(
                                children: [
                                  Text(
                                    snapshot.data.episodes.toString() +
                                        ' episodes',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        letterSpacing: 0.2),
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '•',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    snapshot.data.broadcast,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        letterSpacing: 0.2),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    letterSpacing: 0.2),
                              ),
                              Text(
                                snapshot.data.score.toString(),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    letterSpacing: 0.2),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Synopsis',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          snapshot.data.synopsis,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Gagal menampilkan data detail'));
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

class AiringDetail {
  String image;
  String title;
  String synopsis;
  num malId;
  num score;
  String broadcast;
  num episodes;

  AiringDetail({
    this.image,
    this.title,
    this.synopsis,
    this.malId,
    this.score,
    this.broadcast,
    this.episodes,
  });

  factory AiringDetail.fromJson(json) {
    return AiringDetail(
      image: json['image_url'],
      title: json['title'],
      synopsis: json['synopsis'],
      malId: json['mal_id'],
      score: json['score'],
      broadcast: json['broadcast'],
      episodes: json['episodes'],
    );
  }
}

Future<AiringDetail> fetchDetails(malId) async {
  String api = 'https://api.jikan.moe/v3/anime/$malId';
  var response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    return AiringDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
