import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paradise/models/destination.dart';
import 'package:paradise/screens/pagecontainer.dart';
import 'package:paradise/services/firestorage_service.dart';
import 'package:paradise/services/firestore_service.dart';

import '../utils.dart';

class AddOrEdit extends StatefulWidget {
  AddOrEdit({this.destination});
  final Destination destination;
  @override
  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  bool isLoading = false;
  List<File> tempImageFiles = [];
  List<File> images = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  double lat = -6.200000;
  double long = 106.816666;
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  loadData() async {
   try{ setState(() {
      isLoading = true;
      debugPrint('loading');
    });
    FireStorageService storageService = FireStorageService();
    Destination destination = widget.destination;
    var _images=<File>[];
     try{ for (String url in destination.listImage) {
       File file=await storageService.getTempFile(url);
       _images.add(file);
     }}catch(e){
       print(e.toString());
     }
    setState(() {
      nameController.text = destination.name;
      detailsController.text = destination.details;
      placeController.text = destination.place;
      tempImageFiles = _images;
      lat = destination.lat;
      long = destination.long;
      isLoading = false;
    });}catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    if (widget.destination != null) {
      loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<File> allImages = tempImageFiles + images;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(
          title:
              Text((widget.destination == null) ? 'Tambah Data' : 'Edit Data')),
      body: Container(
          padding: EdgeInsets.all(15),
          child: (isLoading)
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      createTextField(nameController, 'nama', Icons.map,
                          border: OutlineInputBorder()),
                      SizedBox(height: 10),
                      createTextField(placeController, 'alamat', Icons.place,
                          border: OutlineInputBorder()),
                      SizedBox(height: 10),
                      createTextField(
                          detailsController, 'detail', Icons.details,
                          border: OutlineInputBorder()),
                      SizedBox(height: 10),
                      Container(
                        height: 98,
                        child: ListView.builder(
                            itemCount: allImages.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) => (index <
                                    allImages.length)
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: FileImage(images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(color: Colors.grey)),
                                    margin: EdgeInsets.only(right: 10),
                                    height: 98,
                                    width: 98,
                                  )
                                : Container(
                                    child: InkWell(
                                        onTap: () async {
                                          try {
                                            PickedFile pickedFile =
                                                await ImagePicker().getImage(
                                                    source:
                                                        ImageSource.gallery);
                                            setState(() {
                                              images.add(File(pickedFile.path));
                                            });
                                          } catch (e) {
                                            debugPrint(e.toString());
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          height: 98,
                                          width: 98,
                                          child: Center(
                                              child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.grey,
                                          )),
                                        )),
                                  )),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        width: size.width,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(lat, long), zoom: 12),
                          markers: {
                            Marker(
                                markerId: MarkerId('place'),
                                position: LatLng(lat, long))
                          },
                          onTap: (ltlg) {
                            setState(() {
                              lat = ltlg.latitude;
                              long = ltlg.longitude;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          FlatButton(
                            color: Colors.lightBlue,
                            child: Text('Simpan'),
                            onPressed: () => executeProcess(allImages),
                          )
                        ]),
                      )
                    ],
                  ),
                )),
    );
  }

  executeProcess(List<File> allImages) async {
    setState(() {
      isLoading = true;
    });
    String name = nameController.text;
    String place = placeController.text;
    String details = detailsController.text;
    FirestoreService _fireStoreService = FirestoreService();
    FireStorageService _fireStorageService = FireStorageService();
    List<String> imagesURL = [];
    if (name.isEmpty || place.isEmpty || details.isEmpty) {
      _sk.currentState
          .showSnackBar(createSnackbar('text field tidak boleh kosong'));
    } else {
      if (widget.destination != null) {
        DocumentReference reference = widget.destination.ref;
        String id = reference.id;
        String path = "$id/photo/";
        try {
          widget.destination.listImage.forEach((url) {
              
          _fireStorageService.delete(url);
           });
          if (allImages.length > 0) {
            for (int index = 0; index < allImages.length; index++) {
              String url = await _fireStorageService.uploadImage(
                  allImages[index], "$path$index");
              imagesURL.add(url);
            }
          }
          Destination destination = Destination(
              details: details,
              lat: lat,
              listImage: imagesURL,
              long: long,
              name: name,
              place: place);
          reference.update(destination.map);
        _sk.currentState
              .showSnackBar(createSnackbar('data berhasil diubah'));
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (c) => PageContainer()));
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        Destination destination = Destination(
            details: details,
            lat: lat,
            listImage: null,
            long: long,
            name: name,
            place: place);
        try {
          DocumentReference reference =
              await _fireStoreService.addDestination(destination);
          String id = reference.id;
          String path = "$id/photo/";
          if (allImages.length > 0) {
            for (int index = 0; index < allImages.length; index++) {
              String url = await _fireStorageService.uploadImage(
                  allImages[index], "$path$index.jpg");
              imagesURL.add(url);
            }
            destination.listImage = imagesURL;
            reference.update(destination.map);
          }
          _sk.currentState
              .showSnackBar(createSnackbar('data berhasil ditambahkan'));
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (c) => PageContainer()));
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }
}
