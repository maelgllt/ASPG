import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'Account.dart';
import 'MenuBurger.dart';

class ModifProfilPage extends StatefulWidget {
  @override
  _ModifProfilPageState createState() => _ModifProfilPageState();
}

class _ModifProfilPageState extends State<ModifProfilPage> {
  final _formKey = GlobalKey<FormState>();
  String age = '';
  String poids = '';
  String taille = '';
  bool practiceSport = false;
  String sportPratique = '';
  int? frequencePratique;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    var userJson = supabase.auth.currentSession?.toJson();

    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      appBar: AppBar(
        title: Text(
          'Modifier les informations personels',
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
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountPage()));
            },
          ),
        ],
      ),
      drawer: MenuBurger(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer votre age' : null,
                onSaved: (value) => age = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Poid :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer votre poid' : null,
                onSaved: (value) => poids = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Taille (en cm) :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer votre taille en cm' : null,
                onSaved: (value) => taille = value!,
              ),
              SwitchListTile(
                title: Text(
                  'Pratiquez-vous un sport ?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: practiceSport,
                onChanged: (bool value) {
                  setState(() {
                    practiceSport = value;
                  });
                },
              ),
              if (practiceSport) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Lequel ?',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value!.isEmpty
                      ? 'Entrez le sport que vous pratiquez'
                      : null,
                  onSaved: (value) => sportPratique = value!,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Nombre d\'entrainement par semaine',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Color(0xFF164863)),
                  items: [1, 2, 3, 4, 5, 6, 7]
                      .map((int value) => DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          ))
                      .toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      frequencePratique = newValue;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Sélectionnez le nombre d\'entrainements par semaine'
                      : null,
                ),
              ],
              SizedBox(height: 40.0),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(
                          'Soumettre',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF164863),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState!.save();
                            try {
                              await supabase.from('User').upsert({
                                'user_id': userJson?['user']['id'],
                                'poids': poids,
                                'sport': sportPratique,
                                'frequence_sport': frequencePratique,
                                'age': age,
                                'taille': taille
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountPage()));
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
