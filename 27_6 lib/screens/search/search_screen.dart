import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/progress.dart';
import '../initial_screen.dart';
import 'components/search_body.dart';
import 'components/user_result.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<List<QuerySnapshot>>? searchResultsFuture;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      appBar: buildSearchField(),
      body:   searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }

  handleSearch(String query) {
    if (!query.isEmpty) {
      Future<QuerySnapshot> matchingUsers = usersRef
          .where("username_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
          .where("username_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
          .get();

      Future<QuerySnapshot> matchingTag1 = usersRef
          .where("tag1_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
          .where("tag1_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
          .get();

      Future<QuerySnapshot> matchingTag2 = usersRef
          .where("tag2_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
          .where("tag2_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
          .get();

      Future<QuerySnapshot> matchingTag3 = usersRef
          .where("tag3_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
          .where("tag3_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
          .get();

      setState(() {
        searchResultsFuture = Future.wait([matchingUsers, matchingTag1, matchingTag2, matchingTag3]);
      });
    }
  }

  logout() async {
    await _auth.authSignOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => InitialPage()));
  }

  AppBar buildSearchField() {
    return AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search for a user...",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() {
                searchController.clear();
                searchResultsFuture = null;
                logout();
              } ),
            ),
          ),
          onFieldSubmitted: handleSearch,
        ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation; // get orientation of device
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              // 300 in portrait mode, 200 in landscape mode
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool dataEmpty(AsyncSnapshot<List<QuerySnapshot>> snapshot) {
    bool dataEmpty = true;
    snapshot.data?.forEach((content) {
      if(content.docs != null) {
        dataEmpty = false;
      }
    });
    return dataEmpty;
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if(!snapshot.hasData || dataEmpty(snapshot)) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data?.forEach((element) {
          element.docs.forEach((doc) {
            TheUser user = TheUser.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }
}
