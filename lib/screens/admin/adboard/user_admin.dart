import 'package:eshop/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:eshop/models/user.dart';
import 'package:eshop/models/api_response.dart';
import 'package:intl/intl.dart';
//import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Utilisateur'),
      ),
      body: FutureBuilder<ApiResponse>(
        future: getUserDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return Center(
                child: Text(
                    'Aucun détail trouvé. Vérifiez votre token ou contactez le support.'));
          } else {
            final user = snapshot.data!.data as User;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nom: ${user.nomGest}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mobile: ${user.mobile}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date de création: ${DateFormat('dd/MM/yyyy').format(user.createdAt!)}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
