import 'package:eshop/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/models/client_carte.dart';
import 'package:eshop/services/user/fetchville.dart';
import 'package:eshop/screens/init_screen.dart'; // Import InitScreen
import 'package:shimmer/shimmer.dart';

class ClientCardScreen extends StatefulWidget {
  final Client client;
  final bool rememberMatr;

  const ClientCardScreen({
    Key? key,
    required this.client,
    required this.rememberMatr,
  }) : super(key: key);

  @override
  _ClientCardScreenState createState() => _ClientCardScreenState();
}

class _ClientCardScreenState extends State<ClientCardScreen> {
  bool _isLoading = false;

  // Function to clear saved matricule
  Future<void> _clearSavedMatr(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedMatr');
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Matricule effacé')),
    );
    _navigateToInitScreen();
  }

  // Function to navigate to InitScreen
  void _navigateToInitScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitScreen()),
    );
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Êtes-vous sûr de vouloir effacer le matricule sauvegardé?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearSavedMatr(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte de fidélité'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<List<Ville>>(
                future: fetchVilles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No ville data found');
                  } else {
                    Ville? clientVille = snapshot.data!.firstWhere(
                        (ville) => ville.id == widget.client.villeId,
                        orElse: () => Ville(id: 0, libelle: 'Unknown'));

                    return ClientCardWidget(
                        client: widget.client, ville: clientVille);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              if (_isLoading)
                CircularProgressIndicator()
              else if (widget.rememberMatr) ...[
                OutlinedButton(
                  onPressed: _showConfirmationDialog,
                  child: const Text('Effacer mon  matricule'),
                ),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                  onPressed: _navigateToInitScreen,
                  child: const Text('Continuer à naviguer'),
                ),
              ] else
                ElevatedButton(
                  onPressed: _navigateToInitScreen,
                  child: const Text('Retour à l\'écran d\'accueil'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientCardWidget extends StatefulWidget {
  final Client client;
  final Ville ville;

  const ClientCardWidget({Key? key, required this.client, required this.ville})
      : super(key: key);

  @override
  _ClientCardWidgetState createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  bool _showTontineAmount = false;

  void _toggleTontineAmountVisibility() {
    setState(() {
      _showTontineAmount = !_showTontineAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/card_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.client.nom,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/card_provider_logo.png',
                height: 48,
                width: 48,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Sexe: ${widget.client.sexe ? 'Male' : 'Female'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            'Date de Naissance: ${widget.client.dateNaiss}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            'Ville: ${widget.ville.libelle}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            'Mobile: ${widget.client.mobile}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            'WhatsApp: ${widget.client.whatsapp == true ? 'Yes' : 'No'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            'Points: ${widget.client.point}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Text(
                _showTontineAmount
                    ? 'Montant Tontine: \XAF ${widget.client.montantTontine.toStringAsFixed(2)}'
                    : 'Montant Tontine: \XAF *****',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  _showTontineAmount ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: _toggleTontineAmountVisibility,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
