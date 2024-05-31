import 'package:eshop/constants.dart';
import 'package:eshop/models/Produit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  product.photos![0].isNotEmpty
                      ? product.photos![0]
                      : 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
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
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/images/empty.png',
                        fit: BoxFit.fill); // Your placeholder image path
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.nomPro,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "\$${product.prix}",
            //       style: const TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //         color: kPrimaryColor,
            //       ),
            //     ),
            //     InkWell(
            //       borderRadius: BorderRadius.circular(50),
            //       onTap: () {},
            //       child: Container(
            //         padding: const EdgeInsets.all(6),
            //         height: 24,
            //         width: 24,
            //         decoration: BoxDecoration(
            //           color: product.noSuchMethod()
            //               ? kPrimaryColor.withOpacity(0.15)
            //               : kSecondaryColor.withOpacity(0.1),
            //           shape: BoxShape.circle,
            //         ),
            //         child: SvgPicture.asset(
            //           "assets/icons/Heart Icon_2.svg",
            //           colorFilter: ColorFilter.mode(
            //               product.isFavourite
            //                   ? const Color(0xFFFF4848)
            //                   : const Color(0xFFDBDEE4),
            //               BlendMode.srcIn),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
