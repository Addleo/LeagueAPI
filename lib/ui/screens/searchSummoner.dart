import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../repositories/userdata_repository.dart';

class SearchSummoner extends StatefulWidget {
  SearchSummoner({Key? key}) : super(key: key);

  @override
  State<SearchSummoner> createState() => _SearchSummonerState();
}

class _SearchSummonerState extends State<SearchSummoner> {

  UserDataRepository userDataRepository = UserDataRepository();

  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    Future<List<dynamic>>? dataFuture = userDataRepository.getUserData(arguments['username'], 'RGAPI-2059ecbc-397f-47c6-8762-c46a3206611d');

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['username']),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: dataFuture,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (snapshot.data?[index].toString().substring(
                        snapshot.data![index].toString().length - 4) ==
                    " win") {
                  return ListTile(
                    tileColor: Colors.blue,
                    title: Text(snapshot.data?[index] ?? "got null"),
                    textColor: Colors.white,
                  );
                } else {
                  return ListTile(
                    tileColor: Colors.red,
                    title: Text(snapshot.data?[index] ?? "got null"),
                    textColor: Colors.white,
                  );
                }
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/moreInfo', arguments: {'username': arguments['username']});
        },
        child: const Icon(Icons.addchart_outlined),
      ),
    );
  }
}
