import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_1/auth/login_screen.dart';
import 'package:firebase_1/firestore/add_firestore_data.dart';
import 'package:firebase_1/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final editcontroller = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('User').snapshots();
  final CollectionReference ref = FirebaseFirestore.instance.collection('User');
  //final ref1 =FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Firestore')),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if (snapshot.hasError) return Text('Some Error');

                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final title =
                            snapshot.data!.docs[index]['title'].toString();

                        if (searchFilter.text.isEmpty) {
                          return ListTile(
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                          title,
                                          snapshot.data!.docs[index]['id']
                                              .toString(),
                                          context,
                                          snapshot.data!,
                                        );
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .doc(snapshot
                                                .data!.docs[index]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Utils().toastMessage('Post Deleted');
                                        }).onError((error, stackTrace) {
                                          Utils()
                                              .toastMessage(error.toString());
                                        });
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ))
                              ],
                            ),
                          );
                        } else if (title.toLowerCase().contains(
                            searchFilter.text.toLowerCase().toLowerCase())) {
                          return ListTile(
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                          );
                        } else {
                          return Container();
                        }
                      }),
                );
              }),
        ],
      ),

      //fetch data from firesbase using Animated list............

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFirestoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //this is only for when the user can click on edit button he goes to the next one screen easily
  // to edit the code

  Future<void> showMyDialog(String title, String id, BuildContext context,
      QuerySnapshot snapshot) async {
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editcontroller,
                decoration: InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel ')),
              TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    ref.doc(id).update({
                      'title': editcontroller.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Post Updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}
