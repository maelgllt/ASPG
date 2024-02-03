import 'package:flutter/material.dart';

import 'Auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
          0xFF427D9D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image
            Image.asset(
              'logo_ASPG.png',
              width: 350.0,
              height: 350.0,
            ),
            // Titre
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Text(
                'Bienvenue sur AI Sport Program Generator',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SupabaseAuth.buildSupabaseAuth(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
