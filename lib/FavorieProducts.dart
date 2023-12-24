import 'package:atelier4_a_zakari_iir5g2/Produit.dart';
import 'package:atelier4_a_zakari_iir5g2/ProduitDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavorieProducts extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("favorie").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Produit> favorieProducts = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: favorieProducts.length,
            itemBuilder: (context, index) {
              final favorieProduct = favorieProducts[index];
              return ListTile(
                title: Text(favorieProduct.designation),
                subtitle: Text(favorieProduct.marque),
                trailing: Text('${favorieProduct.prix} '),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProduitDetails(produit: favorieProduct),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
