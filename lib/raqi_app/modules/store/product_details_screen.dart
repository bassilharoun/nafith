import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nafith/raqi_app/models/product_model.dart';
import 'package:nafith/raqi_app/modules/store/product_returns_screen.dart';
import 'package:nafith/raqi_app/modules/store/widgets/cart_button.dart';
import 'package:nafith/raqi_app/modules/store/widgets/custom_modal_bottom_sheet.dart';
import 'package:nafith/raqi_app/modules/store/widgets/notify_me_card.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_buy_now_screen.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_card.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_images.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_info.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_list_tile.dart';
import 'package:nafith/raqi_app/modules/store/widgets/review_card.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(
      {super.key, this.isProductAvailable = true, required this.product});

  final bool isProductAvailable;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isProductAvailable
          ? CartButton(
              price: 140,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductBuyNowScreen(),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            ProductImages(
              images: [product.image],
            ),
            ProductInfo(
              brand: product.brandName,
              title: product.title,
              isAvailable: isProductAvailable,
              description:
                  "this product will be available soon, please check back later",
              rating: 4.4,
              numOfReviews: 126,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {},
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {},
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                // Navigator.pushNamed(context, productReviewsScreenRoute);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProductReturnsScreen();
                }));
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == 4 ? defaultPadding : 0),
                    child: ProductCard(
                      image: demoPopularProducts[index].image,
                      brandName: demoPopularProducts[index].brandName,
                      title: demoPopularProducts[index].title,
                      price: demoPopularProducts[index].price,
                      priceAfetDiscount:
                          demoPopularProducts[index].priceAfetDiscount,
                      dicountpercent: demoPopularProducts[index].dicountpercent,
                      press: () {
                        // Navigator.pushNamed(context, productDetailsScreenRoute,
                        //     arguments: index.isEven);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductDetailsScreen(
                            product: demoPopularProducts[index],
                          );
                        }));
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
