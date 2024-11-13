import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/models/raqi_user_model.dart';
import 'package:nafith/raqi_app/shared/colors.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';

class FollowersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RaqiCubit, RaqiStates>(
      listener: (context, state){},
      builder: (context, state){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    child: MaterialButton(
                      height: 50,
                      onPressed: (){
                        _showDialog(context);
                      },
                      child: Row(
                        children: [
                          Text("${getLang(context,"addAffiliate")}",
                            style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Icon(Icons.person_add_alt_outlined,color: Colors.white,),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: buttonsColor,
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text("${getLang(context,"affiliateNum")}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      Text("${RaqiCubit.get(context).myFollowers.length}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15,),
              Expanded(
                child: ConditionalBuilder(
                    condition: RaqiCubit.get(context).myFollowers.length > 0,
                    builder: (context) => ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context , index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildFollowerItem(context,RaqiCubit.get(context).myFollowers[index]),
                        ),
                        separatorBuilder: (context , index) => myDivider(),
                        itemCount: RaqiCubit.get(context).myFollowers.length
                    ),
                    fallback: (context) => Center(child: Icon(Icons.no_accounts_outlined,color: Colors.grey,size: 100,),),
                  ),
                ),


            ],
          ),
        );
      },
    );



  }
  _showDialog(BuildContext contex)
  {
    BlurryAdd  alert = BlurryAdd();

    showDialog(
      context: contex,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}

buildFollowerItem(context, UserModel? model){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: buttonsColor,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(model!.image) ,
                ),
              ),
            ],
          ),
          SizedBox(width: 15,),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text("${getLang(context,"name")}: ",overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 1,)),
                    Flexible(child: Text(model.name,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 1,)),
                  ],
                ),
                Row(
                  children: [
                    Flexible(child: Text("${getLang(context,"phone")}: ",overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 1,)),
                    Flexible(child: Text(model.phone,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 1,)),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Expanded(child: IconButton(onPressed: (){
            RaqiCubit.get(context).deleteFollower(model.uId);
          }, icon: Icon(Icons.delete_sweep,color: Colors.red,)))
        ],
      ),
    ),
  );

}



