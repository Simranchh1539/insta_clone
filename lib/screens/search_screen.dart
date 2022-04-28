import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/profile_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isUserSearch = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Container(
          //width: 360,
          height: 35,
          margin: EdgeInsets.only(bottom: 10, top: 5),
          padding: EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Colors.white12, width: 0.5),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            controller: _searchController,
            textAlign: TextAlign.left,
            style: TextStyle(color: Theme.of(context).iconTheme.color),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              icon: Icon(
                Icons.search_outlined,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ),
              border: InputBorder.none,
              labelText: 'Search',
              labelStyle: TextStyle(
                color: Theme.of(context).iconTheme.color.withOpacity(0.6),
              ),
            ),
            onChanged: (_) {
              setState(() {
                isUserSearch = true;
              });
            },
            onFieldSubmitted: (_) {
              isUserSearch = false;
            },
          ),
        ),
      ),
      body: isUserSearch
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: (snapshot.data as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          );
                          setState(() {
                            _searchController.text = "";
                          });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              (snapshot.data as dynamic).docs[index]
                                  ['photoUrl'],
                            ),
                          ),
                          title: Text(
                            (snapshot.data as dynamic).docs[index]['username'],
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) => CachedNetworkImage(
                    imageUrl: (snapshot.data as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                );
              }),
    );
  }
}
