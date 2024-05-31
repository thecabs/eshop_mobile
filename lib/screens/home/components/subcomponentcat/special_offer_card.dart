import 'package:eshop/constants.dart';
import 'package:eshop/models/categories.dart';
import 'package:eshop/size_config.dart';
import 'package:eshop/test/title_text.dart';
import 'package:flutter/material.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    // required this.image,
    //required this.numOfBrands,
    //required this.press,
  }) : super(key: key);

  final Category category;
  //final String image;
  //final String category, image;
  //final int numOfBrands;
  //final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth =
        screenWidth * 0.4; // Ajustez la taille proportionnelle au besoin
    double cardHeight = screenHeight * 0.1;

    return Padding(
      padding: EdgeInsets.all(16.0), // Marges autour de la carte
      child: SizedBox(
        width: cardWidth,
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // Utilisation de ClipPath pour la forme personnalisée
              ClipPath(
                clipper: CategoryCustomShape(),
                child: AspectRatio(
                  aspectRatio: 1.025,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 183, 201, 220), // Fond légèrement bleu
                      border: Border.all(
                        color:
                            Colors.lightBlue.shade300, // Couleur des bordures
                        width: 1, // Largeur des bordures
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          category.nomCat!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.network(
                    category.image!,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    double cornerSize = 15;

    // Début en bas à gauche
    path.lineTo(0, height - cornerSize);
    // Coin inférieur gauche arrondi
    path.quadraticBezierTo(0, height, cornerSize, height);
    // Ligne vers le coin inférieur droit
    path.lineTo(width - cornerSize, height);
    // Coin inférieur droit arrondi
    path.quadraticBezierTo(width, height, width, height - cornerSize);
    // Ligne vers le coin supérieur droit
    path.lineTo(width, cornerSize);
    // Coin supérieur droit arrondi
    path.quadraticBezierTo(width, 0, width - cornerSize, 0);
    // Ligne vers le coin supérieur gauche
    path.lineTo(cornerSize, 0);
    // Coin supérieur gauche arrondi
    path.quadraticBezierTo(0, 0, 0, cornerSize);
    // Fermer le chemin
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
