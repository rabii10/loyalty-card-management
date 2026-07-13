import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LosersList extends StatelessWidget {
  Future<String> _getUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['UserName'] ?? 'No Name';
    } else {
      return 'No Name';
    }
  }
  Future<void> _deletePlayer(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Player deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete player')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
          ),
          child: Center(
            child: Text('Losers List'),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isPassed', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;

              return FutureBuilder(
                future: _getUserName(user.id),
                builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                  if (!usernameSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                      subtitle: Text(
                        'Score: ${userData['score'] ?? 'No Score'}',
                      ),
                    );
                  }

                  return ListTile(
                    title: Text(usernameSnapshot.data ?? 'No Name'),
                    subtitle: Text(
                      'Score: ${userData['score'] ?? 'No Score'}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePlayer(context, user.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
