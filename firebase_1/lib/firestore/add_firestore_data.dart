import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_1/Widgets/round_button.dart';
import 'package:firebase_1/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('User');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Add Firestore Data'),
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
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('post added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
