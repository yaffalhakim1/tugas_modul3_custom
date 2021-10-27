import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_kel27/detail.dart';
import 'package:tugas_kel27/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<AiringModel>> airing;
  Future<List<Top>> top;
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    airing = fetchAiring();
    top = fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.search),
                  Text(
                    'AIRING NOW',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.black, letterSpacing: .5, fontSize: 15),
                    ),
                  ),
                  Icon(Icons.settings),
                ],
              ),
            ),
            // Row(
            //   children: [

            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 180.0,
                child: FutureBuilder<List<AiringModel>>(
                    future: airing,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
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
                            child: Card(
                              elevation: 0,
                              child: Container(
                                height: 150,
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                        height: 150,
                                        child: Image.network(
                                            snapshot.data[index].image)),
                                    Text(
                                      snapshot.data[index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 20),
              child: Text(
                'TOP ANIME',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black, letterSpacing: .5, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
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
                              ListTile(
                            leading: Image.network(
                              snapshot.data[index].imageUrl,
                            ),
                            title: Text(snapshot.data[index].title),
                            subtitle:
                                Text(snapshot.data[index].score.toString()),
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
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
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
Future<List<Top>> fetchShows() async {
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
