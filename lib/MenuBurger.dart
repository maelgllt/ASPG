import 'package:flutter/material.dart';
import 'package:flutter_supabase_twitter_sign_in/CreateProgram.dart';
import 'package:flutter_supabase_twitter_sign_in/Main.dart';
import 'package:flutter_supabase_twitter_sign_in/Program.dart';

class MenuBurger extends StatelessWidget {
  const MenuBurger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF164863),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
          ListTile(
            title: Text('Créer un programme'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateProgram()));
            },
          ),
          ListTile(
            title: Text('Liste des programmes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Program()));
            },
          ),
        ],
      ),
    );
  }
}
