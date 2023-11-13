
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/paytaps/domain/network/requests/paytabs_payment_request.dart';
import 'package:nafith/raqi_app/paytaps/domain/services/paytabs_service.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class PaymentViewModel {
  PayTabsService _payTabsService = PayTabsService();

  // makePayTabsPayment(double amount,String cartId) {
  //   FlutterPaytabsBridge.startPaymentWithSavedCards(
  //     _payTabsService.configPayment(
  //         payTabsPaymentRequest: PayTabsPaymentRequest(amount, 'USD', 'AE'),
  //         cartId : cartId,
  //         context:
  //     ),
  //         false,
  //     (event) {
  //       if (event["status"] == "success") {
  //         var transactionDetails = event["data"];
  //         if (transactionDetails["isSuccess"]) {
  //
  //         } else {
  //
  //         }
  //       } else if (event["status"] == "error") {
  //
  //       } else if (event["status"] == "event") {}
  //     },
  //   );
  // }

  int minEarning = 0 ;
  startCardPayment(double amount, String cartId,context){
    FlutterPaytabsBridge.startCardPayment(
        _payTabsService.configPayment(payTabsPaymentRequest: PayTabsPaymentRequest(amount, 'SAR', 'SA'), cartId : cartId,context: context), (event) {

        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);

          if (transactionDetails["isSuccess"]) {
            if(transactionDetails["cartAmount"] == "23.00"){
              minEarning = 20 + int.parse(RaqiCubit.get(context).userModel!.minutes);
              FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
              showToast(text: "مبارك, تم شحن 20 دقيقة", state: ToastStates.SUCCESS);
            }
            if(transactionDetails["cartAmount"] == "57.50"){
              minEarning = 50 + int.parse(RaqiCubit.get(context).userModel!.minutes);
              FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
              showToast(text: "مبارك, تم شحن 50 دقيقة", state: ToastStates.SUCCESS);
            }
            if(transactionDetails["cartAmount"] == "115.00"){
              minEarning = 100 + int.parse(RaqiCubit.get(context).userModel!.minutes);
              FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
              showToast(text: "مبارك, تم شحن 100 دقيقة", state: ToastStates.SUCCESS);
            }
            if(transactionDetails["cartAmount"] == "575.00"){
              minEarning = 500 + int.parse(RaqiCubit.get(context).userModel!.minutes);
              FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
              showToast(text: "مبارك, تم شحن 500 دقيقة", state: ToastStates.SUCCESS);
            }
            if(transactionDetails["cartAmount"] == "1150.00"){
              FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "10000"});
              showToast(text: "مبارك, تم شحن الباقة المفتوحة", state: ToastStates.SUCCESS);
            }
            FirebaseFirestore.instance.collection("payments").add({
              'amount': transactionDetails["cartAmount"],
              'dateTime': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
              'uId' : RaqiCubit.get(context).userModel!.uId
            });
            print(transactionDetails["cartAmount"]);
            print(minEarning);
          } else {
            showToast(text: "حدث خطأ ما, حاول لاحقا", state: ToastStates.ERROR);
            print("failed transaction");
          }
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }

    });
  }

  startApplePayment(double amount, String cartId,context){
    FlutterPaytabsBridge.startApplePayPayment(_payTabsService.configApple(payTabsPaymentRequest: PayTabsPaymentRequest(amount, 'SAR', 'SA'), cartId: cartId, context: context), (event) {

          if (event["status"] == "success") {
            // Handle transaction details here.
            var transactionDetails = event["data"];


            if (transactionDetails["isSuccess"]) {
              if(transactionDetails["cartAmount"] == "23.00"){
                minEarning = 20 + int.parse(RaqiCubit.get(context).userModel!.minutes);
                FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
                showToast(text: "مبارك, تم شحن 20 دقيقة", state: ToastStates.SUCCESS);
              }
              if(transactionDetails["cartAmount"] == "57.00"){
                minEarning = 50 + int.parse(RaqiCubit.get(context).userModel!.minutes);
                FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
                showToast(text: "مبارك, تم شحن 50 دقيقة", state: ToastStates.SUCCESS);
              }
              if(transactionDetails["cartAmount"] == "115.00"){
                minEarning = 100 + int.parse(RaqiCubit.get(context).userModel!.minutes);
                FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
                showToast(text: "مبارك, تم شحن 100 دقيقة", state: ToastStates.SUCCESS);
              }
              if(transactionDetails["cartAmount"] == "575.00"){
                minEarning = 500 + int.parse(RaqiCubit.get(context).userModel!.minutes);
                FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "$minEarning"});
                showToast(text: "مبارك, تم شحن 500 دقيقة", state: ToastStates.SUCCESS);
              }
              if(transactionDetails["cartAmount"] == "1150.00"){
                FirebaseFirestore.instance.collection("students").doc(RaqiCubit.get(context).userModel!.uId).update({'minutes' : "10000"});
                showToast(text: "مبارك, تم شحن الباقة المفتوحة", state: ToastStates.SUCCESS);
              }
              FirebaseFirestore.instance.collection("payments").add({
                'amount': transactionDetails["cartAmount"],
                'dateTime': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                'uId' : RaqiCubit.get(context).userModel!.uId
              });
              print(transactionDetails["cartAmount"]);
              print(minEarning);
            }

            print(transactionDetails);
          } else if (event["status"] == "error") {
            // Handle error here.
          } else if (event["status"] == "event") {
            // Handle events here.
          }

    });
  }

}
