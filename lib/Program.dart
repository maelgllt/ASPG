import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'Account.dart';
import 'MenuBurger.dart';

class Program extends StatefulWidget {
  @override
  _ProgramState createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  late Future<Map<int, PostgrestMap>> _getProgrammesByUserId;
  Map<String, dynamic>? userJson;

  @override
  void initState() {
    super.initState();
    _getProgrammesByUserId = getProgrammesTitleByUserId();
    var session = Supabase.instance.client.auth.currentSession;
    userJson = session?.toJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      appBar: AppBar(
        title: Text(
          'Liste des programmes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF164863),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: userJson?['user']['user_metadata']['avatar_url'] != null
                ? Image.network(
                    userJson!['user']['user_metadata']['avatar_url'])
                : Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountPage()));
            },
          ),
        ],
      ),
      drawer: MenuBurger(),
      body: Center(
        child: FutureBuilder<Map<int, PostgrestMap>>(
          future: _getProgrammesByUserId,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final key = snapshot.data?.keys.elementAt(index);
                    var value = snapshot.data?[key].toString();
                    final titre = value?.replaceAll('{titre: ', '');
                    return InkWell(
                      onTap: () async {
                        var description = await getProgrammeDescriptionByTitle(
                            titre!.replaceAll('}', ''));
                        var descriptionText = description.values.first
                            .toString()
                            .replaceAll('{description: ', '')
                            .replaceAll('}', '');
                        _showDescriptionDialog(
                            titre.replaceAll('}', ''), descriptionText);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          '${titre?.replaceAll('}', '')}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF164863),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('Aucune donnée disponible');
            }
          },
        ),
      ),
    );
  }

  Future<void> _showDescriptionDialog(String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<Map<int, PostgrestMap>> getProgrammesTitleByUserId() async {
    var user_id =
        await Supabase.instance.client.auth.currentUser?.id.toString();

    var titres = await Supabase.instance.client
        .from('Programme')
        .select('titre')
        .eq('user_id', user_id as Object);

    return titres.asMap();
  }

  static Future<Map<int, PostgrestMap>> getProgrammeDescriptionByTitle(String titre) async {
    var description = await Supabase.instance.client
        .from('Programme')
        .select('description')
        .eq('titre', titre);

    return description.asMap();
  }
}
