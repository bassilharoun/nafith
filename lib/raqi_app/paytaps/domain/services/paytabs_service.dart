import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:raqi/raqi_app/app_cubit/app_cubit.dart';
import 'package:raqi/raqi_app/models/raqi_user_model.dart';
import 'package:raqi/raqi_app/paytaps/presentation/resources/asset_images.dart';

import '../network/requests/paytabs_payment_request.dart';

class PayTabsService {


  void getHttp(amount) async {
    final dio = Dio();
    final response = await dio.get('https://currencyapi.net/api/v1/convert?key=wM5d392NavPiaU1ugDiSdFCSLNWdQDTv2qTI&amount=99.87&from=GBP&to=BTC&output=JSON');
    print(response.data);
  }



  configPayment({required PayTabsPaymentRequest payTabsPaymentRequest,required String cartId,required BuildContext context}) {

    final billingInfo = BillingDetails(
      RaqiCubit.get(context).userModel!.name,
      RaqiCubit.get(context).userModel!.email,
      RaqiCubit.get(context).userModel!.phone,
      'ad line',
      RaqiCubit.get(context).userModel!.myCountryCode,
      RaqiCubit.get(context).userModel!.myCountryName,
      'st ate',
      '12325',
    );

    var configuration = PaymentSdkConfigurationDetails(
      profileId: "97684",
      serverKey: "SLJNGG6GTB-J6BLLBNK2B-GLJDG9K6R9",
      clientKey: "CKKMNP-92PG6G-2BB2QK-DR6PQ9",
      cartId: "cart_11111",
      cartDescription: "cart desc",
      merchantName: "Nafith",
      screentTitle: "Pay with Card",
      locale: PaymentSdkLocale.DEFAULT,
      amount: payTabsPaymentRequest.amount,
      currencyCode: payTabsPaymentRequest.currency,
      merchantCountryCode: payTabsPaymentRequest.countryCode,
      billingDetails: billingInfo,
      hideCardScanner: true,
    );
    print(configuration.amount);

    var theme = IOSThemeConfigurations();
    theme.logoImage = AssetImages.appLogo;

    configuration.iOSThemeConfigurations = theme;

    configuration.showBillingInfo = false;
    configuration.showShippingInfo = false;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  configApple({required PayTabsPaymentRequest payTabsPaymentRequest,required String cartId,required BuildContext context}){

    var configuration = PaymentSdkConfigurationDetails(
        profileId: "97684",
        serverKey: "SLJNGG6GTB-J6BLLBNK2B-GLJDG9K6R9",
        clientKey: "CKKMNP-92PG6G-2BB2QK-DR6PQ9",
        cartId: "cart_11111",
        cartDescription: "cart desc",
        merchantName: "Nafith",
        screentTitle: "Pay with Card",
        locale: PaymentSdkLocale.DEFAULT, //PaymentSdkLocale.EN or PaymentSdkLocale.DEFAULT
        amount: payTabsPaymentRequest.amount,
        currencyCode: payTabsPaymentRequest.currency,
        merchantCountryCode: payTabsPaymentRequest.countryCode,
        merchantApplePayIndentifier: "com.raqi.app",
        linkBillingNameWithCardHolderName: true
    );
    configuration.simplifyApplePayValidation = true;
    return configuration ;
  }
}
