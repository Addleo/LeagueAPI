import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchSummoner extends StatefulWidget {
  SearchSummoner({Key? key}) : super(key: key);

  @override
  State<SearchSummoner> createState() => _SearchSummonerState();
}

class _SearchSummonerState extends State<SearchSummoner> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    var api_key = '';
    var username = arguments['username'];

    Future<String> fetchResultsByUsername(username, api_key) async {
      final response = await http.get(Uri.parse(
          'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$username?api_key=$api_key'));
      if (response.statusCode == 200) {
        return (response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load');
      }
    }

    Future<String> fetchMatchesByPuuid(puuid, api_key) async {
      final response = await http.get(Uri.parse(
          'https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/$puuid/ids?start=0&count=10&api_key=$api_key'));
      if (response.statusCode == 200) {
        return (response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load');
      }
    }

    Future<String> fetchMatchesById(match_id, api_key) async {
      final response = await http.get(Uri.parse(
          'https://europe.api.riotgames.com/lol/match/v5/matches/$match_id?api_key=$api_key'));
      if (response.statusCode == 200) {
        return (response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load');
      }
    }

    Future<List<dynamic>> getData(username, api_key) async {
      var match_history =
          fetchResultsByUsername(username, api_key).then((String result) {
        var split_result = result.split(',');
        var puuid = split_result[2].substring(9);
        puuid = puuid.substring(0, 78);
        var match_history =
            fetchMatchesByPuuid(puuid, api_key).then((String result) {
          result = result.replaceAll(RegExp('"'), '');
          result = result.substring(0, result.length - 1);
          result = result.substring(1);
          var matches_id = result.split(',');
          var match_history = [];
          matches_id.forEach((String match_id) {
            fetchMatchesById(match_id, api_key).then((String result) {
              var data = jsonDecode(result);

              for (var i = 0; i < 10; i++) {
                if (data['info']['participants'][i]['summonerName'] ==
                    username) {
                  if (data['info']['participants'][i]['win'] == true) {
                    match_history.add(data['info']['participants'][i]
                            ['summonerName'] +
                        ' ' +
                        data['info']['participants'][i]['teamPosition'] +
                        ' ' +
                        data['info']['participants'][i]['championName'] +
                        ' ' +
                        data['info']['participants'][i]['kills'].toString() +
                        '/' +
                        data['info']['participants'][i]['deaths'].toString() +
                        '/' +
                        data['info']['participants'][i]['assists'].toString() +
                        ' win');
                  } else {
                    match_history.add(data['info']['participants'][i]
                            ['summonerName'] +
                        ' ' +
                        data['info']['participants'][i]['teamPosition'] +
                        ' ' +
                        data['info']['participants'][i]['championName'] +
                        ' ' +
                        data['info']['participants'][i]['kills'].toString() +
                        '/' +
                        data['info']['participants'][i]['deaths'].toString() +
                        '/' +
                        data['info']['participants'][i]['assists'].toString() +
                        ' lose');
                  }
                }
              }
              return match_history;
            });
          });
          return match_history;
        });
        return match_history;
      });
      return match_history;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['username']),
      ),
      body: FutureBuilder(
        future: getData(username, api_key),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data?[index] ?? "got null");
              },
            );
          }
          else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/moreInfo');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
