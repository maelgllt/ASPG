import 'package:flutter/material.dart';
import 'package:flutter_supabase_twitter_sign_in/Account.dart';
import 'package:flutter_supabase_twitter_sign_in/CreateProgram.dart';
import 'package:flutter_supabase_twitter_sign_in/Home.dart';
import 'package:flutter_supabase_twitter_sign_in/MenuBurger.dart';
import 'package:flutter_supabase_twitter_sign_in/Program.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late Future<String> _lastProgrammeTitle;
  Map<String, dynamic>? userJson;

  @override
  void initState() {
    super.initState();
    _lastProgrammeTitle = getLastProgrammeTitle();
    var session = Supabase.instance.client.auth.currentSession;
    userJson = session?.toJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      appBar: AppBar(
        title: Text(
          'ASPG : Accueil',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bonjour ${userJson?['user']['user_metadata']['preferred_username'] ?? 'Utilisateur'}',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            FutureBuilder<String>(
              future: _lastProgrammeTitle,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Ce compte ne possède pas encore de programme');
                }
                return Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Dernier programme : ${snapshot.data}',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Program()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF164863),
              ),
              child: Text(
                'Consulter vos programmes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateProgram()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF164863),
              ),
              child: Text(
                'Ajouter un programme',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AccountPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF164863),
              ),
              child: Text(
                'Accéder au profil',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Supabase.instance.client.auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF164863),
              ),
              child: Text(
                'Se déconnecter',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> getLastProgrammeTitle() async {
    return await Supabase.instance.client.rpc('getLastProgrammeTitle',
        params: {'user_id_arg': await Supabase.instance.client.auth.currentSession?.user.id});
  }
}
