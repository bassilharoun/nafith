import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nafith/raqi_app/modules/store/widgets/added_to_cart_message_screen.dart';
import 'package:nafith/raqi_app/modules/store/widgets/cart_button.dart';
import 'package:nafith/raqi_app/modules/store/widgets/custom_modal_bottom_sheet.dart';
import 'package:nafith/raqi_app/modules/store/widgets/network_image_with_loader.dart';
import 'package:nafith/raqi_app/modules/store/widgets/product_quantity.dart';
import 'package:nafith/raqi_app/modules/store/widgets/selected_colors.dart';
import 'package:nafith/raqi_app/modules/store/widgets/selected_size.dart';
import 'package:nafith/raqi_app/modules/store/widgets/unit_price.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: 269.4,
        title: "Add to cart",
        subTitle: "Total price",
        press: () {
          customModalBottomSheet(
            context,
            isDismissible: false,
            child: const AddedToCartMessageScreen(),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  "Sleeveless Ruffle",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(productDemoImg1),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: UnitPrice(
                            price: 145,
                            priceAfterDiscount: 134.7,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: 2,
                          onIncrement: () {},
                          onDecrement: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: const [
                      Color(0xFFEA6262),
                      Color(0xFFB1CC63),
                      Color(0xFFFFBF5F),
                      Color(0xFF9FE1DD),
                      Color(0xFFC482DB),
                    ],
                    selectedColorIndex: 2,
                    press: (value) {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: const ["S", "M", "L", "XL", "XXL"],
                    selectedIndex: 1,
                    press: (value) {},
                  ),
                ),
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                //   sliver: ProductListTile(
                //     title: "Size guide",
                //     svgSrc: "assets/icons/Sizeguid.svg",
                //     isShowBottomBorder: true,
                //     press: () {
                //       customModalBottomSheet(
                //         context,
                //         height: MediaQuery.of(context).size.height * 0.9,
                //         child: const SizeGuideScreen(),
                //       );
                //     },
                //   ),
                // ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Select a size to check store availability and In-Store pickup options.")
                      ],
                    ),
                  ),
                ),
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                //   sliver: ProductListTile(
                //     title: "Check stores",
                //     svgSrc: "assets/icons/Stores.svg",
                //     isShowBottomBorder: true,
                //     press: () {
                //       customModalBottomSheet(
                //         context,
                //         height: MediaQuery.of(context).size.height * 0.92,
                //         child: const LocationPermissonStoreAvailabilityScreen(),
                //       );
                //     },
                //   ),
                // ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
