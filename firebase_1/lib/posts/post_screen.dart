//import 'package:flutter/material.dart';

import 'package:firebase_1/auth/login_screen.dart';
import 'package:firebase_1/posts/add_posts.dart';
import 'package:firebase_1/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Post')),
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

          //fetch data from firesbase using Animated list............
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle:
                            Text(snapshot.child('rollno').value.toString()),
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
                                        snapshot
                                            .child('rollno')
                                            .value
                                            .toString(),
                                        context);
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
                                        .child(snapshot
                                            .child('rollno')
                                            .value
                                            .toString())
                                        .remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ))
                          ],
                        ));
                  } else if (title.toLowerCase().contains(
                      searchFilter.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('rollno').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //this is only for when the user can click on edit button he goes to the next one screen easily
  // to edit the code

  Future<void> showMyDialog(
      String title, String rollno, BuildContext context) async {
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
                    Navigator.pop(context);
                    ref.child(rollno).update({
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
// fetch data from firebase using the Stream builder

// Expanded(child: StreamBuilder(
//   builder: (context, snapshot) {
//     return ListTile.builder(itemBuilder: (context , index)){
//       title: Text('ASDFS'),
//     );
//   },
// )),
// Expanded(
//     child: StreamBuilder(
//   stream: ref.onValue,
//   builder: (context, AsyncSnapshot<DatabaseEvent> shapshot) {
//     if (!snapshot.hasData) {
//       return CircularProgressIndicator();
//     } else {
//       return ListView.builder(
//           itemCount: snapshot.data!.snapshot.children.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text('ASDFS '),
//             );
//           });
//     }
//     return ListView.builder(itemBuilder: (context, index) {
//       return ListTile(
//         title: Text('ASDFS'),
//       );
//     });
//   },
// )),
