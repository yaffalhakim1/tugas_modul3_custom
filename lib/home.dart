import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_kel27/detail.dart';
import 'package:tugas_kel27/profile.dart';
import 'package:tugas_kel27/profiles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<AiringModel>> airing;
  Future<List<Top>> top;

  @override
  void initState() {
    super.initState();
    airing = fetchAiring();
    top = fetchTop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    'Wibu List',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white, letterSpacing: .5, fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'AIRING NOW',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white, letterSpacing: .5, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: SizedBox(
                height: 180.0,
                child: FutureBuilder<List<AiringModel>>(
                    future: airing,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    item: snapshot.data[index].malId,
                                    title: snapshot.data[index].title,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 400,
                              width: 315,
                              decoration: BoxDecoration(
                                  color: Color(0xff252836),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        snapshot.data[index].image,
                                        fit: BoxFit.cover,
                                        width: 315,
                                        height: 110,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].title,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.2),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          snapshot.data[index].rating
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                              fontSize: 14,
                                              letterSpacing: 0.2),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Gagal menampilkan data Airing');
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'TOP ANIME',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white, letterSpacing: .5, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                // height: 200.0,
                child: FutureBuilder<List<Top>>(
                    future: top,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Card(
                              color: Color(0xff252836),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 0,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      snapshot.data[index].imageUrl),
                                ),
                                title: Text(
                                  snapshot.data[index].title,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 0.2),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  snapshot.data[index].score.toString(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                      fontSize: 14,
                                      letterSpacing: 0.2),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        title: snapshot.data[index].title,
                                        item: snapshot.data[index].malId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiringModel {
  final int malId;
  final String title;
  final num rating;
  final String image;

  AiringModel({
    this.rating,
    this.title,
    this.image,
    this.malId,
  });

  factory AiringModel.fromJson(Map<String, dynamic> json) {
    return AiringModel(
      malId: json['mal_id'],
      title: json['title'],
      rating: json["score"],
      image: json['image_url'],
    );
  }
}

//fetch api

Future<List<AiringModel>> fetchAiring() async {
  String api = 'https://api.jikan.moe/v3/top/anime/1/airing';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var airingJson = jsonDecode(response.body)['top'] as List;

    return airingJson.map((airing) => AiringModel.fromJson(airing)).toList();

    //jika tidak di mapping hanya mendapat instance
    //intance of keynya
  } else {
    throw Exception('Failed to load airing');
  }
}

class Top {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;

  Top({
    this.malId,
    this.title,
    this.imageUrl,
    this.score,
  });

  factory Top.fromJson(Map<String, dynamic> json) {
    return Top(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

// function untuk fetch api
Future<List<Top>> fetchTop() async {
  String api = 'https://api.jikan.moe/v3/top/anime/1';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['top'] as List;

    return topShowsJson.map((top) => Top.fromJson(top)).toList();

    //jika tidak di mapping hanya mendapat instance
    //intance of keynya
  } else {
    throw Exception('Failed to load shows');
  }
}
