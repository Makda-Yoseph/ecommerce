import 'package:ecommerce_app/Domain/Entities/product_model.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;

  const ProductWidget({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(product.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            height: 4.0,
          ),
          Text(product.category,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              )),
          SizedBox(
            height: 4.0,
          ),
          Text("${product.price.toString()} ETB",
              style: TextStyle(
                fontSize: 14.0,
              )),
        ],
      ),
    );
  }
}
