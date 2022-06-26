import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'user_result.dart';
import '../../../models/user.dart';
import '../../../shared/progress.dart';

class SearchBody extends StatefulWidget {
  SearchBody({Key? key, required this.searchResultsFuture}) : super(key: key);
  Future<List<QuerySnapshot>>? searchResultsFuture;

  @override
  State<SearchBody> createState() => _SearchBodyState(searchResultsFuture: searchResultsFuture);
}

class _SearchBodyState extends State<SearchBody> {
  Future<List<QuerySnapshot>>? searchResultsFuture;
  _SearchBodyState({this.searchResultsFuture});

  @override
  Widget build(BuildContext context) {
    return searchResultsFuture == null ? buildNoContent() : buildSearchResults();
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation; // get orientation of device
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/1.png',
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