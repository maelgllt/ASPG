import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'MenuBurger.dart';
import 'ModifProfilPage.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var session = Supabase.instance.client.auth.currentSession;
    var user_json = session?.toJson();

    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      appBar: AppBar(
        title: Text(
          'ASPG : Mon compte',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF164863),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MenuBurger(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.0),
            CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    user_json?['user']['user_metadata']['avatar_url'] ?? '',
                    fit: BoxFit.cover,
                    width: 120.0,
                    height: 120.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Photo de profil',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Nom d\'utilisateur : ${user_json?['user']['user_metadata']['user_name'] ?? 'Nom d\'utilisateur inconnu'}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Nom complet: ${user_json?['user']['user_metadata']['full_name'] ?? 'Nom complet inconnu'}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Email : ${user_json?['user']['user_metadata']['email'] ?? 'Email inconnu'}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ModifProfilPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF164863),
              ),
              child: Text(
                'Modifier les informations personels',
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
}
