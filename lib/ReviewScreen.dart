import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_place_api/route_arguments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_webservice/src/places.dart';

class ReviewScreen extends StatefulWidget {
  RouteArgument routeArgument;

  ReviewScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Spyveb"),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 30),
            shrinkWrap: true,
            itemBuilder: (_, int index) => ReviewView(this
                .widget
                .routeArgument
                .placesDetailsResponse
                .result
                .reviews[index]),
            itemCount: this
                .widget
                .routeArgument
                .placesDetailsResponse
                .result
                .reviews
                .length,
          ),
        ),
      ),
    );
  }
}

class ReviewView extends StatelessWidget {
  Review data;

  ReviewView(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[400],
                spreadRadius: 4,
                blurRadius: 10 //edited
                ),
          ],
          borderRadius: const BorderRadius.all(
            const Radius.circular(10),
          ),
          shape: BoxShape.rectangle),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    imageUrl: data.profilePhotoUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        data.authorName,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 5,bottom: 5),
                      child: Text(
                        data.relativeTimeDescription,
                        maxLines: 10,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: data.rating.toDouble(),
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          data.text.isNotEmpty
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    data.text,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
