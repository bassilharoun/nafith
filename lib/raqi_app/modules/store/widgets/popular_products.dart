import 'package:flutter/material.dart';
import 'package:nafith/raqi_app/models/product_model.dart';
import 'package:nafith/raqi_app/modules/store/product_details_screen.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_card.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),

        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: demoPopularProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == demoPopularProducts.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                image: demoPopularProducts[index].image,
                brandName: demoPopularProducts[index].brandName,
                title: demoPopularProducts[index].title,
                price: demoPopularProducts[index].price,
                priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
                dicountpercent: demoPopularProducts[index].dicountpercent,
                press: () {
                  // Navigator.pushNamed(context, productDetailsScreenRoute,
                  //     arguments: index.isEven);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return  ProductDetailsScreen(product: demoPopularProducts[index],);
                  }));
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
