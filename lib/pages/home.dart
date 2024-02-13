import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app_2/data.dart';
import 'package:news_app_2/models/category_model.dart';
import 'package:news_app_2/pages/details_screen.dart';
import 'package:news_app_2/view_models/news_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  String selectedCategory = "Latest news"; // Biến lưu trữ danh mục được chọn
  NewsViewModel newsViewModel = NewsViewModel();
  Map<int, String> publishedTimes =
      {}; // Sử dụng Map để lưu trữ thời gian đã đăng
  bool isNewsLatest = true;

  @override
  void initState() {
    categories = getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Crypto'),
            Text(
              'Feed',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index].title.toString();
                          isNewsLatest = selectedCategory == "Latest news";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            Text(
                              categories[index].title.toString(),
                              style: TextStyle(
                                color:
                                    selectedCategory == categories[index].title
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                            if (selectedCategory == categories[index].title)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 10,
                                child: Container(
                                  height: 2,
                                  color: Colors.orange,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: newsViewModel.fetchNewsLatest(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return Visibility(
                      visible: isNewsLatest,
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, itemIndex, pageViewIndex) {
                          return InkWell(
                            onTap: () {},
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 300,
                                  width: 450,
                                  child: Image.network(
                                    '${snapshot.data!.data![itemIndex].imageurl ?? ''}',
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    height: 130,
                                    width: 450,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${snapshot.data!.data![itemIndex].title}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                            ]),
                          );
                        },
                        options: CarouselOptions(
                          height: 300,
                          autoPlay: true,
                          viewportFraction: 0.55,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: const Duration(seconds: 2),
                          enableInfiniteScroll: true,
                          reverse: false,
                          pageSnapping: true,
                          aspectRatio: 16 / 9,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FutureBuilder(
                    future: newsViewModel.fetchNewsLatest(selectedCategory),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text('No data available'),
                        );
                      } else {
                        final newsItem = snapshot.data!.data![index];
                        int? timestamp = newsItem.publishedOn;
                        String timeAgo = publishedTimes[timestamp] ?? '';

                        if (timestamp != null && timeAgo.isEmpty) {
                          var now = DateTime.now();
                          var date = DateTime.fromMillisecondsSinceEpoch(
                              timestamp * 1000);
                          var difference = now.difference(date);

                          if (difference.inMinutes < 60) {
                            timeAgo = '${difference.inMinutes} p';
                          } else if (difference.inHours < 24) {
                            timeAgo = '${difference.inHours} h';
                          } else {
                            timeAgo = DateFormat('dd/MM').format(date);
                          }

                          publishedTimes[timestamp] = timeAgo;
                        } else if (timestamp != null &&
                            publishedTimes[timestamp] != null) {
                          timeAgo = publishedTimes[timestamp]!;
                        }

                        String domain = _getDomainFromUrl(newsItem.guid ?? '');
                        return Container(
                          margin: EdgeInsets.only(bottom: 12, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.network(
                                    newsItem.imageurl ?? '',
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsNews(
                                              url: newsItem.url.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        newsItem.title.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      newsItem.source.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        domain,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Icon(
                                                        Icons.circle,
                                                        color: Colors.grey,
                                                        size: 5,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        timeAgo,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.add_reaction,
                                                      size: 18),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.comment,
                                                      size: 18),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.share,
                                                      size: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
                childCount: categories.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Hàm để lấy thời gian đã đăng

// Hàm để lấy domain từ URL
String _getDomainFromUrl(String url) {
  Uri uri = Uri.parse(url);
  return uri.host;
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.blue,
  size: 50,
);
