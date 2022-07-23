import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:log_in/shared/constants.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/progress.dart';
import '../initial_screen/initial_screen.dart';
import 'components/user_result.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
////////////////////////////////////////////////////////
/// Widget defines external parameters
////////////////////////////////////////////////////////
class Search extends StatefulWidget {
  const Search();

  @override
  _SearchController createState() => _SearchController();
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////
class _SearchController extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<List<QuerySnapshot>>? searchResultsFuture;
  Future<QuerySnapshot>? allUsersFuture; // contains a collection of all the users in the database
  final AuthService _auth = AuthService();

  String? queryString;

  @override
  Widget build(BuildContext context) {
    return _SearchView(this);
  }

  handleSearch(String query) {
    if (!query.isEmpty) {
      print("Handling search");
      queryString = query.toLowerCase();
      Future<QuerySnapshot> allUsers = usersRef.get();
      print("Got users ref");
      print(allUsers.toString());

      // Future<QuerySnapshot> matchingUsers = usersRef
      //     .where("username_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
      //     .where("username_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
      //     .get();
      //
      // Future<QuerySnapshot> matchingTag1 = usersRef
      //     .where("tag1_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
      //     .where("tag1_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
      //     .get();
      //
      // Future<QuerySnapshot> matchingTag2 = usersRef
      //     .where("tag2_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
      //     .where("tag2_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
      //     .get();
      //
      // Future<QuerySnapshot> matchingTag3 = usersRef
      //     .where("tag3_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
      //     .where("tag3_lowercase", isLessThanOrEqualTo: "$query\uf7ff".toLowerCase())
      //     .get();

      // setState(() {
      //   searchResultsFuture = Future.wait([matchingUsers, matchingTag1, matchingTag2, matchingTag3]);
      // });

      setState(() {
        allUsersFuture = allUsers;
        print("Has set state");
      });
    }
  }

  logout() async {
    await _auth.authSignOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InitialPage()));
  }

  AppBar buildSearchField() {
    return AppBar(
      automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Find user by name/ acad info/ tags",
            hintMaxLines: 1,
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() {
                searchController.clear();
                allUsersFuture = null;
                // searchResultsFuture = null;
                // logout();
              } ),
            ),
          ),
          onFieldSubmitted: handleSearch,
        ),
    );
  }

  bool dataEmpty(AsyncSnapshot<QuerySnapshot> snapshot) {
    /*bool dataEmpty = true;
    if() {
      dataEmpty = false;
    }*/
    return snapshot.data?.docs == null;
  }
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////
class _SearchView extends StatelessWidget {
  final _SearchController state;
  const _SearchView(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[700],
        appBar: state.buildSearchField(),
    body: //SearchBody(searchResultsFuture:searchResultsFuture)
    // state.searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
      state.allUsersFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }

  Container buildNoContent() {
    print("Built no content");
    final Orientation orientation = MediaQuery.of(state.context).orientation; // get orientation of device
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

  Container buildNoUser() {
    print("Built no content");
    final Orientation orientation = MediaQuery.of(state.context).orientation; // get orientation of device
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // SvgPicture.asset(
            //   'assets/images/search.svg',
            //   // 300 in portrait mode, 200 in landscape mode
            //   height: orientation == Orientation.portrait ? 300.0 : 200.0,
            // ),
            SizedBox(height: 20,),
            Text(
              "No matching results",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: state.allUsersFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> allUsersSnapshot) {
        if (!allUsersSnapshot.hasData || state.dataEmpty(allUsersSnapshot)) {
          print("No Search results");
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        allUsersSnapshot.data?.docs.forEach((userDoc) {
          print("Has Search results");
          String username_lowercase = userDoc["username_lowercase"];
          String acadInfo_lowercase = userDoc["acad_info_lowercase"];
          String tag1_lowercase = userDoc["tag1_lowercase"];
          String tag2_lowercase = userDoc["tag2_lowercase"];
          String tag3_lowercase = userDoc["tag3_lowercase"];
          print(username_lowercase);
          print(acadInfo_lowercase);
          print(tag1_lowercase);
          print(tag2_lowercase);
          print(tag3_lowercase);
          if ( (state.queryString != null)
              && (username_lowercase.contains(state.queryString!)
                || acadInfo_lowercase.contains(state.queryString!)
                    || tag1_lowercase.contains(state.queryString!)
                        || tag2_lowercase.contains(state.queryString!)
                            || tag3_lowercase.contains(state.queryString!)) ) {

            TheUser matchingUser = TheUser.fromDocument(userDoc);
            UserResult searchResult = UserResult(matchingUser);
            // check for duplicates
            if (!searchResults.contains(searchResult)) {
              searchResults.add(searchResult);
            }
          }
        });
        return ListView(
          children: searchResults.isEmpty ? [buildNoUser()] : searchResults,
        );
      },
    );
  }
}