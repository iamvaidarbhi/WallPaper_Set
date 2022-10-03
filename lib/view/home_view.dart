import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall_set/view/full_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List _images = [];
  int page = 1;

  fetchApi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
              "563492ad6f91700001000001b9021f3f3304470c9802a3ce771871a6"
        }).then((value) {
      Map result = jsonDecode(value.body);
      print(result);
      setState(() {
        _images = result['photos'];
      });
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        "https://api.pexels.com/v1/curated?per_page=80&page=" + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          "563492ad6f91700001000001b9021f3f3304470c9802a3ce771871a6"
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        _images.addAll(result['photos']);
      });
    });
  }

  @override
  void initState() {
    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullView(
                                      imageURL: _images[index]['src']
                                          ['large2x'],
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          _images[index]['src']['tiny'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                loadMore();
              },
              child: Center(
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
