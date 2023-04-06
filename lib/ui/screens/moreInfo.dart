import 'package:flutter/material.dart';
import '../../repositories/userdata_repository.dart';

class MoreInfo extends StatefulWidget {
  MoreInfo({Key? key}) : super(key: key);

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  UserDataRepository userDataRepository = UserDataRepository();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    Future<String>? dataFuture = userDataRepository.getWinrate(
        arguments['username'], 'RGAPI-bc4d5390-6ed4-4487-a35a-9a885ca29a52');

    return Scaffold(
      appBar: AppBar(
        title: const Text("More info"),
      ),
      body: FutureBuilder<String>(
        future: dataFuture,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: Text(snapshot.data ?? "got null"),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
