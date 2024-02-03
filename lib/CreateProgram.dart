import 'package:flutter/material.dart';
import 'package:flutter_supabase_twitter_sign_in/Account.dart';
import 'package:flutter_supabase_twitter_sign_in/MenuBurger.dart';
import 'package:flutter_supabase_twitter_sign_in/Program.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class CreateProgram extends StatefulWidget {
  @override
  _CreateProgramState createState() => _CreateProgramState();
}

class _CreateProgramState extends State<CreateProgram> {
  final _formKey = GlobalKey<FormState>();
  String _goal = '';
  String _title = '';
  bool _hasGymSubscription = false;
  bool _hasSportEquipment = false;
  int? _sessionsPerWeek;
  String _minDuration = '';
  String _maxDuration = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    var user_json = supabase.auth.currentSession?.toJson();

    return Scaffold(
      backgroundColor: Color(0xFF427D9D),
      appBar: AppBar(
        title: Text(
          'ASPG : Créer programme',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF164863),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: user_json?['user']['user_metadata']['avatar_url'] != null
                ? Image.network(
                    user_json!['user']['user_metadata']['avatar_url'])
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
                  labelText: 'Titre de votre programme :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Titre du programme' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Objectif recherché :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer votre objectif' : null,
                onSaved: (value) => _goal = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Durée minimum d\'un entrainement en minutes :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors
                      .white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer la durée minimum' : null,
                onSaved: (value) => _minDuration = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Durée maximum d\'un entrainement en minutes :',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors
                      .white,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Entrer la durée maximum' : null,
                onSaved: (value) => _maxDuration = value!,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Nombre d\'entrainement par semaine',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                items: [1, 2, 3, 4, 5, 6, 7]
                    .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _sessionsPerWeek = newValue;
                  });
                },
                validator: (value) => value == null
                    ? 'Sélectionnez le nombre d\'entrainements par semaine'
                    : null,
              ),
              SwitchListTile(
                title: Text(
                  'Avez-vous un abonnement à une salle de musculation ?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: _hasGymSubscription,
                onChanged: (bool value) {
                  setState(() {
                    _hasGymSubscription = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(
                  'Possédez-vous de l\'équipement sportif ?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: _hasSportEquipment,
                onChanged: (bool value) {
                  setState(() {
                    _hasSportEquipment = value;
                  });
                },
              ),
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
                              var programme = await createProgram();
                              await supabase.from('Programme').insert({
                                'user_id': user_json?['user']['id'],
                                'description': programme,
                                'titre': _title
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Program()));
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

  Future<Map<int, PostgrestMap>> getUser() async {
    var user_id =
        await Supabase.instance.client.auth.currentUser?.id.toString();
    var user = await Supabase.instance.client
        .from('User')
        .select('*')
        .eq('user_id', user_id as Object);

    return user.asMap();
  }

  Future<String> createProgram() async {
    Map<int, PostgrestMap> user = await getUser();
    var userInfo = user[0];

    String? age = userInfo?['age'];
    String? poids = userInfo?['poids'];
    String? sport = userInfo?['sport'];
    int? frequenceSport = userInfo?['frequence_sport'];
    String? taille = userInfo?['taille'];

    String prompt = "";

    if (age!.isNotEmpty) {
      prompt += "Age : $age \n";
    }
    if (taille!.isNotEmpty) {
      prompt += "Taille : $taille \n";
    }
    if (poids!.isNotEmpty) {
      prompt += "Poids : $poids \n";
    }
    if (sport!.isNotEmpty) {
      prompt += "Sport Pratiqué : $sport ";
    }
    if (frequenceSport! > 0) {
      prompt += "à la fréquence de $frequenceSport fois par semaine \n";
    }

    prompt += "Objectif: $_goal "
        "Durée minimum d'entrainement: $_minDuration "
        "Durée maximum d'entrainement: $_maxDuration "
        "Sessions par semaine: ${_sessionsPerWeek.toString()} "
        "Abonnement à la salle de sport: ${_hasGymSubscription ? 'Oui' : 'Non'} "
        "Équipement sportif: ${_hasSportEquipment ? 'Oui' : 'Non'}"
        "Tu dois me créer un programme sportif en accord avec les données ci dessus, la réponse doit"
        "être bien formulée pour être compréhensible par tout le monde avec le titre du programme, la durée des séances, la fréquence de celle-ci et la description des séances détaillé avec des exercices spécifiques s'il te plait. ";

    final openaiApiKey = 'API-KEY';
    final openai = OpenAI(
      apiKey: openaiApiKey,
      defaultOptions: const OpenAIOptions(temperature: 1, maxTokens: 1000),
    );

    final result = await openai(prompt);
    return result;
  }
}
