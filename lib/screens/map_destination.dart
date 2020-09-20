import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradise/models/destination.dart';
import 'package:paradise/services/firestore_service.dart';

import 'detail_destination.dart';

class MapDestination extends StatefulWidget {
  @override
  _MapDestinationState createState() => _MapDestinationState();
}

class _MapDestinationState extends State<MapDestination> {
  Position current;
  Destination activeDestinationInfo;
  List<Destination> destinations;
  bool isLoading=false;
  loadData() async {
    setState(() {
      isLoading=true;
    });
    Position _current = await getCurrentPosition();

    List<Destination> _destinations =
        await FirestoreService().getListDestination();
    setState(() {
      destinations = _destinations;
      current = _current;
      isLoading=false;
    });
  }

  bool isActiveInfo = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar() ,
      body: (isLoading)?Container(child:Center(child: CircularProgressIndicator(),)):Stack(children: [
        Positioned.fill(
            child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(current.latitude, current.longitude),
                    zoom: 10),
                markers: destinations
                    .map((Destination destination) => Marker(
                        markerId: MarkerId(destination.ref.id),
                        onTap: () {
                          setState(() {
                            isActiveInfo = true;
                            activeDestinationInfo = destination;
                            current = Position(
                                longitude: destination.long,
                                latitude: destination.lat);
                          });
                        },
                        position: LatLng(destination.lat, destination.long)))
                    .toSet())),
        AnimatedPositioned(
          child: (isActiveInfo)
              ? Container(
                width: size.width,
                  height: 200,
                  padding: EdgeInsets.all(10),
                  child: Card(
                      child: Stack(
                    children: [
                      Hero(
                        tag: activeDestinationInfo.ref.id,
                                              child: Container(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  activeDestinationInfo.name ?? ' ',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                Text(activeDestinationInfo.place ?? ' '),
                                Align(
                                  alignment: Alignment.bottomRight,
                                                                  child: FlatButton(
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                Detail(activeDestinationInfo,activeDestinationInfo.ref.id))),
                                    child: Text('lihat detail'),
                                    color: Colors.blueAccent[100],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                                              child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isActiveInfo = false;
                              });
                            }),
                      )
                    ],
                  )),
                )
              : Container(),
          bottom: (isActiveInfo) ? 10 : -500,
          duration: Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
        )
      ]),
    );
  }
}
