import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_twitter_sign_in/FirstPage.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SupabaseAuth {
  static Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: 'https://hophkdajvwrwgjzfmzsm.supabase.co',
      anonKey:
          '',
    );
  }

  static Widget buildSupabaseAuth(BuildContext context) {
    return Container(
      width: 300.0,
      child: SupaSocialsAuth(
        socialProviders: [OAuthProvider.twitter],
        showSuccessSnackBar: false,
        colored: true,
        redirectUrl: kIsWeb ? null : 'http://localhost:3000',
        onSuccess: (Session response) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FirstPage()));
        },
        onError: (error) {},
      ),
    );
  }
}
