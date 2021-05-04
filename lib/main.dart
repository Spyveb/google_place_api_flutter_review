import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_place_api/ReviewScreen.dart';
import 'package:flutter_google_place_api/route_arguments.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyBNtWuhYPhH_a5Qne-CcSd0QCzeUx2aRLs";

main() {
  runApp(RoutesWidget());
}

final customTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  accentColor: Colors.redAccent,
);

class RoutesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My App",
        theme: customTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (_) => MyApp(),
        },
      );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _MyAppState extends State<MyApp> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text("Spyveb"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDropdownMenu(),
          ElevatedButton(
            onPressed: _handlePressButton,
            child: Text("Search places"),
          ),
        ],
      )),
    );
  }

  Widget _buildDropdownMenu() => DropdownButton(
        value: _mode,
        dropdownColor: Colors.white,
        items: <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            child: Text(
              "Overlay",
              style: TextStyle(color: Colors.black),
            ),
            value: Mode.overlay,
          ),
          DropdownMenuItem<Mode>(
            child: Text(
              "Fullscreen",
              style: TextStyle(color: Colors.black),
            ),
            value: Mode.fullscreen,
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m;
          });
        },
      );

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      offset: 0,
      radius: 1000,
      strictbounds: false,
      types: [],
      components: [Component(Component.country, "IN"),Component(Component.country, "UK")],
      overlayBorderRadius: BorderRadius.circular(20),
    );
    displayPrediction(p, homeScaffoldKey.currentState);
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    Navigator.push(
        homeScaffoldKey.currentContext,
        MaterialPageRoute(
          builder: (context) => ReviewScreen(
            routeArgument: new RouteArgument(placesDetailsResponse: detail),
          ),
        ));
  }
}