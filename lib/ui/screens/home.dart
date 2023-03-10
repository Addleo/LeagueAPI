// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeagueApi'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              // ignore: sort_child_properties_last
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: Icon(Icons.person_search),
                ),
                controller: usernameController,
              ),
              margin: new EdgeInsets.all(10) ,
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushNamed('/searchSummoner', arguments: {'username': usernameController.text});
              },
              child: const Text('Rechercher'),
            )
          ],
        ),
      )
    );
  }
}
