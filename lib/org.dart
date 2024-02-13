import 'package:difund_admin/details.dart';
import 'package:flutter/material.dart';
//cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';
//import auth
import 'package:firebase_auth/firebase_auth.dart';

class OrgPage extends StatefulWidget {
  const OrgPage({super.key});

  @override
  State<OrgPage> createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {
  //current user email
  final email = FirebaseAuth.instance.currentUser!.email;
  //controller for name and details
  TextEditingController namecontroller = TextEditingController();
  TextEditingController details = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0xff5D57EB),
        elevation: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 180,
            ),
          ],
        ),
        //go to profile page

        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2EAAFA), Color(0xff8C04DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: //get name and total from all documents of the collection 'organizations'
            Stack(children: [
          //add button at the bottom center
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController descriptionController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Add Organization'),
                        content: SizedBox(
                          height: 120,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    hintText: "Enter organization name"),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                    hintText: "Enter organization description"),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('organizations')
                                  .add({
                                'name': nameController.text,
                                'desc': descriptionController.text,
                                'image':
                                    'https://firebasestorage.googleapis.com/v0/b/difund-app.appspot.com/o/care.png?alt=media&token=ed349303-1d49-43ed-a1a3-1556c04266ab',
                                'total': '0'
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: OvalBorder(),
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 11, 11, 11)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('organizations')
                    .orderBy('total', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff121438)),
                            child: GestureDetector(
                              onTap: () {
                                //navigate to details page with current doc id using Navigator.push
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                              docid: document.id,
                                            )));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Image.network(
                                        data['image'],
                                        height: 100,
                                        width: 103,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data['name'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white)),
                                            Text(
                                              '₹  ' +
                                                  data['total'].toString() +
                                                  '  collected',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
