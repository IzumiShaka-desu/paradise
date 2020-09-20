import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:paradise/models/destination.dart';
import 'package:paradise/screens/pagecontainer.dart';
import 'package:paradise/services/firestorage_service.dart';

import '../constant.dart';
import '../utils.dart';
import 'add_or_edit.dart';

class Detail extends StatefulWidget {
  Detail(this.destination,this.tags); 
  final Destination destination;
  final String tags;
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  double currentPosition = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPosition = _pageController.page;
      });
    });
    super.initState();
  }

  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(
        title: Text(widget.destination.name),
        actions: [
          IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) =>
                      AddOrEdit(destination: widget.destination)))),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                bool result = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.redAccent,
                              ),
                              Text('Peringatan'),
                            ],
                          ),
                          content: Text('Anda yakin akan menghapus data ini?'),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('batal'),
                              color: Colors.blueAccent,
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Ok'),
                              color: Colors.redAccent,
                            )
                          ],
                        ));
                if (result) {
                  try {
                    
                    FireStorageService service = FireStorageService();
                    DocumentReference ref = widget.destination.ref;

                    widget.destination.listImage.forEach((path) {
                       service.delete(path);
                    });
                   
                    ref.delete();
                    _sk.currentState
                        .showSnackBar(createSnackbar('data berhasil dihapus'));
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => PageContainer()));
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                }
              })
        ],
      ),
      body: Container(
        
          child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.tags,
                          child: Container(
                width: size.width,
                height: size.width * 0.7,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.destination.listImage.length,
                    itemBuilder: (ctx, index) => Container(
                          child:
                              Image.network(widget.destination.listImage[index]),
                        )),
              ),
            ),
            Container(
                child: DotsIndicator(
              dotsCount: widget.destination.listImage.length,
              position: currentPosition,
              decorator: DotsDecorator(
                  activeColor: primaryGreen, activeSize: Size(18.0, 9.0)),
            )),
            Container(
              padding: EdgeInsets.all(10),
                child: Row(
              children: [
                Icon(Icons.place),
                SizedBox(width: 10),
                Expanded(child: Text(widget.destination.place))
              ],
            )),
            Container(
              padding: EdgeInsets.all(10),
                child: Row(
              children: [Text('Detail',style: TextStyle(fontSize:18),)],
            )),
            Container(
              padding: EdgeInsets.all(10),
                child: Row(
              children: [
                Expanded(
                  child: Text(widget.destination.details),
                )
              ],
            ))
          ],
        ),
      )),
    );
  }
}
