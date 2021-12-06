import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_config/flutter_config.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

void main() async {
  runApp(
      new MaterialApp(home: new HomePage(), debugShowCheckedModeBanner: false));
  // await FlutterConfig.loadEnvVariables();
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  String url;
  List data;
  var _finalresponse;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  // ignore: non_constant_identifier_names
  Future<String> getJsonData() async {
    // var isOffline = FlutterConfig.get('isOffline');
    // if (isOffline == true) {

    // } else {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    url =
        "https://developers.zomato.com/api/v2.1/search?lat=${position.latitude}&lon=${position.longitude}";

    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "user-key": "6e122059d19277d79f8308ff9ad70263"
    });

    //print(response.body);

    if (response.body == '') {
      _finalresponse = await DefaultAssetBundle.of(context)
          .loadString('assets/restaurants1.json');
    } else {
      _finalresponse = response.body;
    }
    // _finalresponse = await DefaultAssetBundle.of(context)
    //     .loadString('assets/restaurants1.json');
    setState(() {
      var convertDataToJson = json.decode(_finalresponse);
      data = convertDataToJson["restaurants"];
    });
    // }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Restaurants Near You"),
      ),
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    retaurantDetails: data[index]
                                        ['restaurant'])));
                      },
                      child: new Card(
                          child: new Container(
                        child: _buildCard(data[index]['restaurant']),
                        padding: const EdgeInsets.all(20.0),
                      )),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Widget _buildCard(retaurantDetails) => SizedBox(
      child: Card(
        child: Column(
          children: [
            new Container(
                //padding: const EdgeInsets.all(8.0),
                child: retaurantDetails['featured_image'] == ''
                    ? Image.asset('images/Default.jpg')
                    : Image.network(
                        retaurantDetails['thumb'].toString().split('?')[0],
                        //retaurantDetails['featured_image'],
                        fit: BoxFit.fitWidth)),
            ListTile(
                title: Text(retaurantDetails['name'],
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle:
                    Text(retaurantDetails['location']['locality_verbose']),
                trailing: Column(
                  children: <Widget>[
                    Text(
                        retaurantDetails['user_rating']['rating_obj']['title']
                                ['text']
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    Icon(
                      Icons.star,
                      color: _colorFromHex(
                          retaurantDetails['user_rating']['rating_color']),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );

class DetailPage extends StatelessWidget {
  final retaurantDetails;
  DetailPage({Key key, @required this.retaurantDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(retaurantDetails['name']),
        // ),
        body: Center(
      child: new Container(
        child: _builddetailsCard(retaurantDetails),
      ),
    ));
  }
}

Widget _builddetailsCard(retaurantDetails) => SizedBox(
      //height: 160,
      child: Card(
        child: Column(
          children: <Widget>[
            // new Container(
            //     //padding: const EdgeInsets.all(8.0),
            //     child: retaurantDetails['featured_image'] == ''
            //         ? Image.asset('images/Default.jpg')
            //         : Image.network(
            //             retaurantDetails['thumb'].toString().split('?')[0],
            //             //retaurantDetails['featured_image'],
            //             fit: BoxFit.fitWidth)),
            // ListTile(
            //     title: Text(retaurantDetails['name'] + '\n',
            //         style:
            //             TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            //     subtitle: Text('Quick Bites - ' +
            //         retaurantDetails['cuisines'] +
            //         '\n' +
            //         retaurantDetails['location']['locality_verbose'] +
            //         '\n\nCost for two - ' +
            //         retaurantDetails['average_cost_for_two'].toString() +
            //         '(approx.) \n' +
            //         'Timings - ' +
            //         retaurantDetails['timings'] +
            //         '\n'),
            //     trailing: Column(
            //       children: <Widget>[
            //         Text(
            //             retaurantDetails['user_rating']['rating_obj']['title']
            //                     ['text']
            //                 .toString(),
            //             style: TextStyle(fontWeight: FontWeight.w900)),
            //         Icon(
            //           Icons.star,
            //           color: _colorFromHex(
            //               retaurantDetails['user_rating']['rating_color']),
            //         ),
            //       ],
            //     )),
            // ListTile(
            //     title: Text('Address',
            //         style:
            //             TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            //     subtitle: Text(retaurantDetails['location']['address'])),
            Card(
              child: Column(
                children: [
                  new Container(
                      //padding: const EdgeInsets.all(8.0),
                      child: retaurantDetails['featured_image'] == ''
                          ? Image.asset('images/Default.jpg')
                          : Image.network(
                              retaurantDetails['thumb']
                                  .toString()
                                  .split('?')[0],
                              //retaurantDetails['featured_image'],
                              fit: BoxFit.fitWidth)),
                  ListTile(
                      title: Text(retaurantDetails['name'] + '\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25)),
                      subtitle: Text('Quick Bites - ' +
                          retaurantDetails['cuisines'] +
                          '\n' +
                          retaurantDetails['location']['locality_verbose'] +
                          '\n\nCost for two - ' +
                          retaurantDetails['average_cost_for_two'].toString() +
                          '(approx.) \n' +
                          'Timings - ' +
                          retaurantDetails['timings'] +
                          '\n'),
                      trailing: Column(
                        children: <Widget>[
                          Text(
                              retaurantDetails['user_rating']['rating_obj']
                                      ['title']['text']
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          Icon(
                            Icons.star,
                            color: _colorFromHex(retaurantDetails['user_rating']
                                ['rating_color']),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Text('Address \n',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                      subtitle: Text(retaurantDetails['location']['address'])),
                ],
              ),
            ),
            ListTile(
              title: Text('Menu',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            ),
            Expanded(
              child: _buildMenuGrd(),
            )
          ],
        ),
      ),
    );

Widget _buildMenuGrd() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(3));

// The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
// The List.generate() constructor allows an easy way to create
// a list when objects have a predictable naming pattern.
List<Container> _buildGridTileList(int count) => List.generate(
    count, (i) => Container(child: Image.asset('images/pic$i.jpg')));

// Widget _buildAddress(restaurantDtls) => Card(
//     color: Colors.white,
//     shadowColor: Colors.transparent,
//     child: Column(
//       children: [
//         Text('Address',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
//         Text(''),
//         Text(restaurantDtls['location']['address'],
//             style: TextStyle(color: Colors.black.withOpacity(0.5))),
//       ],
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//     ));

// Widget _buildRating(restaurantDtls) => Card(
//     color: Colors.white,
//     shadowColor: Colors.transparent,
//     child: Row(
//       children: <Widget>[
//         Column(
//           children: [
//             SmoothStarRating(
//               rating: double.parse(
//                   restaurantDtls['user_rating']['rating_obj']['title']['text']),
//               isReadOnly: false,
//               size: 20,
//               filledIconData: Icons.star,
//               halfFilledIconData: Icons.star_half,
//               defaultIconData: Icons.star_border,
//               starCount: 5,
//               allowHalfRating: true,
//               spacing: 2.0,
//               color:
//                   _colorFromHex(restaurantDtls['user_rating']['rating_color']),
//               onRated: (value) {
//                 print("rating value -> $value");
//               },
//             ),
//           ],
//           crossAxisAlignment: CrossAxisAlignment.start,
//         ),
//         Column(
//           children: <Widget>[
//             Padding(padding: const EdgeInsets.only(left: 40.0)),
//             Text(restaurantDtls['user_rating']['rating_obj']['title']['text'],
//                 style: TextStyle(fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ],
//     ));

// Widget _buildNameHeader(restaurantDtls) => Card(
//     color: Colors.white,
//     child: Column(
//       children: [
//         Text(restaurantDtls['name'],
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
//         Divider(),
//         Text(
//             restaurantDtls['establishment'][0] +
//                 '-' +
//                 restaurantDtls['cuisines'],
//             style: TextStyle(color: Colors.black.withOpacity(0.5))),
//         Text(restaurantDtls['location']['locality_verbose'],
//             style: TextStyle(color: Colors.black.withOpacity(0.5))),
//         Text(''),
//         Text(
//             'Timings - ' +
//                 // Icons.ac_unit.toString() +
//                 restaurantDtls['timings'].toString(),
//             style: TextStyle(color: Colors.black.withOpacity(0.5))),
//         Text(
//             'Cost for two - ' +
//                 // Icons.ac_unit.toString() +
//                 restaurantDtls['average_cost_for_two'].toString() +
//                 '(approx.)',
//             style: TextStyle(color: Colors.black.withOpacity(0.5))),
//         Text(''),
//         Text('Contact - ' + restaurantDtls['phone_numbers']),
//       ],
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//     ));

// Widget _buildOtherhighlights(List<String> highlights) => Card(
//     color: Colors.white,
//     //shadowColor: Colors.transparent,
//     child: Column(
//       children: <Widget>[
//         Divider(),
//         Text('Other Info.',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
//       ],
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//     ));
