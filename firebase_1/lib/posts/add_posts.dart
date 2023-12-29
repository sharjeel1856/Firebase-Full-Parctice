import 'package:firebase_1/Widgets/round_button.dart';
import 'package:firebase_1/posts/post_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: 'Add',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  databaseRef.child(id).set({
                    'title': postController.text.toString(),
                    'rollno': id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
