import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/models/first_token.dart';
import 'package:nafith/raqi_app/modules/payment/cubit/states.dart';
import 'package:nafith/raqi_app/modules/payment/visacard.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:nafith/raqi_app/shared/network/dio.dart';

class PaymentCubit extends Cubit<PaymobStates>{
  PaymentCubit() : super(PaymobInitState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  FirstToken? firstToken;
  Future getFirstToken(int price , String firstName , String lastName , String email , String phone,context)async{
    DioHelperPayment.postData(url: 'auth/tokens', data: {'api_key' : PaymobApiKey})
        .then((value) {
          PaymobToken = value.data['token'];
          print('First Token : ${PaymobToken}');
          getOrderId(price, firstName, lastName, email, phone,context);
          emit(PaymobSuccessState());
    })
        .catchError((error){
          emit(PaymobErrorState(error));

    });
  }

  Future getOrderId(int price , String firstName , String lastName , String email , String phone,context)async{
    DioHelperPayment.postData(url: 'ecommerce/orders',
        data: {
          'auth_token' : PaymobToken,
          'delivery_needed' : 'false',
          "amount_cents": price,
          "currency": "EGP",
          "items" : []
    }
    ).then((value) {
      PaymobOrderId = value.data['id'].toString();
      print('Order ID : ${PaymobOrderId}');
      getFinalTokenCard(price, firstName, lastName, email, phone,context);
      emit(PaymobOrderIdSuccessState());

    })
        .catchError((error){
      emit(PaymobOrderIdErrorState(error));

    });
  }

  Future getFinalTokenCard(int price , String firstName , String lastName , String email , String phone,context)async{
    DioHelperPayment.postData(url: 'acceptance/payment_keys',
        data: {
          "auth_token": PaymobToken,
          "amount_cents": price*100,
          "expiration": 36000,
          "order_id": PaymobOrderId,
          "billing_data": {
            "apartment": "NA",
            "email": email,
            "floor": "NA",
            "first_name": firstName,
            "street": "NA",
            "building": "NA",
            "phone_number": lastName,
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "last_name": firstName.split(" ").last,
            "state": RaqiCubit.get(context).userModel!.uId
          },
          "currency": "EGP",
          "integration_id": IntegrationIDCard,
          "lock_order_when_paid": "false"
        }
    ).then((value) {
      PaymobFinalToken = value.data['token'].toString();
      print('Final Token Card : ${PaymobFinalToken}');
      navigateTo(context, VisaCardScreen());
      emit(PaymobRequestTokenSuccessState());

    })
        .catchError((error){
      emit(PaymobRequestTokenErrorState(error.toString()));
      print(error);

    });
  }


  int pakka = 2 ;
  void emitPakka(int myPakka){
    pakka = myPakka ;
    if(pakka == 1){
      emit(RaqiFirstPakka());
    }
    if(pakka == 2){
      emit(RaqiSecPakka());
    }
    if(pakka == 3){
      emit(RaqiThirdPakka());
    }
  }

  List coupons = [];
  int dis = 0;
  bool copExist = false;
  getCoupon(String coupon){
    FirebaseFirestore.instance.collection("coupons").get().then((value) {
      value.docs.forEach((element) {
        if(element.id == coupon){
          dis = int.parse(element.data()["discount"]);
          copExist = true ;
        }
      });
    });
    if(copExist == true){
      showToast(text: "Coupon Done", state: ToastStates.SUCCESS);
    }if(copExist == false){
      showToast(text: "not exist", state: ToastStates.ERROR);
    }
    print(dis);
    print("==========================================================");
    emit(RaqiGetCoupons());
  }
}