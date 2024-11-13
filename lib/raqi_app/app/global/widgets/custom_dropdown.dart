import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:nafith/raqi_app/app/global/styles/styles.dart';
import 'package:nafith/raqi_app/modules/signup/cubit/cubit.dart';

class CustomDropdown extends StatefulWidget {
  final void Function(int?)? onChanged;
  final List<String>? options;

  final int initialSelectedValue;
  const CustomDropdown(
      {super.key, this.onChanged, this.options, this.initialSelectedValue = 0});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.sp),
        border: Border.all(
          color: ColorNeutrals.grey4,
          width: 1.sp,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          icon: Container(
            decoration: BoxDecoration(
                color: ColorRaqi.purple10,
                borderRadius: BorderRadius.circular(4)),
            child: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: ColorRaqi.purple100,
            ),
          ),
          dropdownColor: Colors.white,
          value: selectedValue,
          items: widget.options!
              .map((String paymentMethod) => DropdownMenuItem<int>(
                    value: widget.options!.indexOf(paymentMethod),
                    child: Text(
                      paymentMethod,
                      style: AppStyles.style16Medium(
                          FontFamily.Cairo, context,
                          color: ColorNeutrals.secondaryText),
                    ),
                  ))
              .toList(),
          onChanged: (int? newValue) {
            setState(() {
              selectedValue = newValue ?? 0;
              if (widget.onChanged != null) widget.onChanged!(newValue);
              RaqiSignupCubit.get(context)
                  .changeDropdown(widget.options![newValue!]);
                  
            });
          },
        ),
      ),
    );
  }
}
