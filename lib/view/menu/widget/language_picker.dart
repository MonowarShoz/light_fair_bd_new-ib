import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/localization/language_constraints.dart';
import 'package:light_fair_bd_new/provider/localization_provider.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:provider/provider.dart';

class CurrencyDialog extends StatelessWidget {
  const CurrencyDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _valueList = [];
    for (var language in AppConstants.languages) {
      _valueList.add(language.languageName!);
    }
    int index;

    index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Text(getTranslated('language', context),
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        SizedBox(
          height: 150,
          child: CupertinoPicker(
            itemExtent: 40,
            useMagnifier: true,
            magnification: 1.2,
            scrollController: FixedExtentScrollController(initialItem: index),
            onSelectedItemChanged: (int i) {
              index = i;
            },
            children: _valueList.map((value) {
              return Center(child: Text(value, style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)));
            }).toList(),
          ),
        ),
        Divider(height: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: ColorResources.getHint(context)),
        Row(children: [
          Expanded(
              child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getTranslated('cancel', context),
                style: robotoRegular.copyWith(color: ColorResources.getYellow(context))),
          )),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: VerticalDivider(width: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: Theme.of(context).hintColor),
          ),
          Expanded(
              child: TextButton(
            onPressed: () {
              Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                AppConstants.languages[index].languageCode!,
                AppConstants.languages[index].countryCode,
              ));

              Navigator.pop(context);
            },
            child: Text(
              getTranslated('ok', context),
            ),
          )),
        ]),
      ]),
    );
  }
}
