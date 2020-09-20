import 'package:flutter/material.dart';
import 'package:paradise/models/destination.dart';
import 'package:paradise/screens/detail_destination.dart';
import 'package:paradise/services/firestore_service.dart';

import '../constant.dart';

class RecommendDestination extends StatefulWidget {
  @override
  _RecommendDestinationState createState() => _RecommendDestinationState();
}

class _RecommendDestinationState extends State<RecommendDestination> {
  List<Destination> destinations = [];
  bool isLoading = false;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: destinations.length,
                        itemBuilder: (ctx, index) => Container(
                              padding: EdgeInsets.all(10),
                              child: InkWell(
                                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Detail(destinations[index],destinations[index].ref.id))),
                                                              child: Hero(
                                  tag: destinations[index].ref.id,
                                                                child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                destinations[index].listImage[0]),
                                            fit: BoxFit.cover)),
                                    width: 150,
                                    child: Stack(children: [
                                      Positioned.fill(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(100),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: textGrey.withAlpha(150),
                                              borderRadius: BorderRadius.vertical(
                                                  bottom: Radius.circular(15))),
                                          height: 50,
                                          width: 180,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      destinations[index].name,
                                                      style: TextStyle(
                                                          color: backColor),
                                                    )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.place,
                                                      size: 15,
                                                      color: backColor,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      destinations[index]
                                                          .place
                                                          .split(',')
                                                          .first,
                                                      style: TextStyle(
                                                          color: backColor),
                                                    )),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            )),
                    onRefresh: () async{
                      loadData();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    List<Destination> _destinations =
        await FirestoreService().getListDestination();
    setState(() {
      destinations = _destinations;
      isLoading = false;
    });
  }
}
