import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchResultsByUsername(username, String api_key) async {
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

Future<String> fetchMatchesByPuuid(puuid, String api_key) async {
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

Future<String> fetchMatchById(match_id, String api_key) async {
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

Future<List<String>> fetchMatches(
    List<String> matches_id, String api_key, username) async {
  List<String> match_history = [];
  for (var i = 0; i < matches_id.length; i++) {
    List<String> returnedValue =
        await fetchMatchById(matches_id[i], api_key).then((String result) {
      var data = jsonDecode(result);
      for (var i = 0; i < 10; i++) {
        if (data['info']['participants'][i]['summonerName'] == username) {
          if (data['info']['participants'][i]['win'] == true) {
            String match_result = (data['info']['participants'][i]
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
            match_history.add(match_result);
          } else {
            String match_result = (data['info']['participants'][i]
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
                ' loss');
            match_history.add(match_result);
          }
        }
      }
      return match_history;
    });
  }
  return match_history;
}

Future<String> fetchWinrate(
    List<String> matches_id, String api_key, username) async {
  int wrPercent = 0;
  for (var i = 0; i < matches_id.length; i++) {
    int returnedValue =
        await fetchMatchById(matches_id[i], api_key).then((String result) {
      var data = jsonDecode(result);
      for (var i = 0; i < 10; i++) {
        if (data['info']['participants'][i]['summonerName'] == username) {
          if (data['info']['participants'][i]['win'] == true) {
            wrPercent += 10;
          }
        }
      }
      return wrPercent;
    });
  }
  return "Vous avez $wrPercent % de victoires sur vos 10 dernières parties.";
}

class UserDataRepository {
  Future<String> getWinrate(username, String api_key) async {
    var UserPUUID =
        await fetchResultsByUsername(username, api_key).then((String result) {
      var split_result = result.split(',');
      var puuid = split_result[2].substring(9);
      puuid = puuid.substring(0, 78);
      return puuid;
    });

    List<String> matches_id =
        await fetchMatchesByPuuid(UserPUUID, api_key).then((String result) {
      result = result.replaceAll(RegExp('"'), '');
      result = result.substring(0, result.length - 1);
      result = result.substring(1);
      var matches_id = result.split(',');
      return matches_id;
    });

    String winrate = await fetchWinrate(matches_id, api_key, username);

    return winrate;
  }

  Future<List> getUserData(username, String api_key) async {
    var UserPUUID =
        await fetchResultsByUsername(username, api_key).then((String result) {
      var split_result = result.split(',');
      var puuid = split_result[2].substring(9);
      puuid = puuid.substring(0, 78);
      return puuid;
    });

    List<String> matches_id =
        await fetchMatchesByPuuid(UserPUUID, api_key).then((String result) {
      result = result.replaceAll(RegExp('"'), '');
      result = result.substring(0, result.length - 1);
      result = result.substring(1);
      var matches_id = result.split(',');
      return matches_id;
    });

    List<String> match_history =
        await fetchMatches(matches_id, api_key, username);

    return match_history;
  }
}
