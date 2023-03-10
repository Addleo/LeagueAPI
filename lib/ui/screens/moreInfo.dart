import 'package:flutter/material.dart';

class MoreInfo extends StatefulWidget {
  MoreInfo({Key? key}) : super(key: key);

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeagueApi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addCompany');

          //if (company != null) {
          //  setState(() {
          //    _companies.add(company);
          //  });
          //}

          // Navigator.of(context).pushNamed<Company?>('/addCompany').then((company) {
          //
          // });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
