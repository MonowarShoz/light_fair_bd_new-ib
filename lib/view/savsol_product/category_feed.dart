// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/model/ret_sale_item.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/util/color_resources.dart';
import 'package:light_fair_bd_new/util/theme/custom_themes.dart';
import 'package:light_fair_bd_new/view/order/pdf_preview_screen.dart';
import 'package:light_fair_bd_new/view/savsol_product/category_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryFeed extends StatefulWidget {
  final String categoryCode;
  final String categoryTitle;
  static const routeName = '/categoryFeed';
  const CategoryFeed(
      {Key? key, required this.categoryCode, required this.categoryTitle})
      : super(key: key);

  @override
  State<CategoryFeed> createState() => _CategoryFeedState();
}

class _CategoryFeedState extends State<CategoryFeed> {
  List<RetItemSale> _searchlist = [];
  late TextEditingController _searchTextEditingController;
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchTextEditingController = TextEditingController();
    _searchTextEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<MobilFeedProvider>(context, listen: false);

    // final categoryID = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    // final prodList = productProvider.findByCateGory(categoryID.categoryID!);
    final prodList = productProvider.findByCateGory(widget.categoryCode);

    return Scaffold(
      appBar: AppBar(
        leading: const CupertinoNavigationBarBackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              String dir = (await getExternalStorageDirectory())!.path;
              var bytes = await prodCategory(
                  PdfPageFormat.legal, prodList, widget.categoryTitle
                  // categoryID.reportTitle!,
                  );
              final file = File('$dir/category.pdf');
              await file.writeAsBytes(bytes);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PdfPreviewScreen(
                      path: '$dir/category.pdf',
                      title: 'Product List Pdf',
                      isResponsive: true,
                      file: file)));
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
        title: FittedBox(
          child: Text(
            ' ${widget.categoryTitle}',
            //' ${categoryID.reportTitle}',
            style: chakraPetch.copyWith(fontSize: 17, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: TextField(
                //controller: widget.prodSearchController,
                style:
                    robotoRegular.copyWith(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                    hintText: 'Search Products',
                    focusColor: Colors.green,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    // suffixIcon: mobilP.isnsearch
                    //     ? IconButton(
                    //     onPressed: () {
                    //       widget.prodSearchController!.text = '';
                    //       mobilP.newSearchCheckProd('');
                    //     },
                    //     icon: Icon(Icons.close,color: Colors.red,))
                    //   : Icon(Icons.search,color: Colors.black,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xFFFC6A57)))),
                onChanged: (query) {
                  setState(() {
                    _searchlist = productProvider.searchQuery(query, prodList);
                  });
                },
              ),
            ),
            _searchlist.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: _searchlist.length,
                        itemBuilder: ((context, index) {
                          return ChangeNotifierProvider.value(
                            value: _searchlist[index],
                            child: Card(
                              child: ListTile(
                                onTap: () async {
                                  await productProvider.searchUriFromInternet(
                                      uriName: _searchlist[index].sirdesc!,
                                      isLogin: false);
                                },
                                title: Text(
                                  '${_searchlist[index].sirdesc}',
                                  style: poppinRegular.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                subtitle: Text(
                                  "ID : ${_searchlist[index].sircode}",
                                  // "${product.sircode}",
                                  //"${mobilP.retItemSale![index].sircode} ",
                                  style: chakraPetch.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: prodList.length,
                        itemBuilder: ((context, index) {
                          return ChangeNotifierProvider.value(
                            value: prodList[index],
                            child: const ProductFeed(),
                          );
                        })),
                  ),
          ],
        ),
      ),
    );
  }
}

class ProductFeed extends StatefulWidget {
  const ProductFeed({Key? key}) : super(key: key);

  @override
  _ProductFeedState createState() => _ProductFeedState();
}

class _ProductFeedState extends State<ProductFeed> {
  Uri? uri;

  Future<void> _launchUrl() async {
    if (!await launchUrl(uri!)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final prodAttribute = Provider.of<RetItemSale>(context);
    return Consumer<MobilFeedProvider>(builder: (context, mp, child) {
      return InkWell(
        onTap: () {
          // Navigator.pushNamed(context, ProductDetailScreen.routeName,
          //     arguments: prodAttribute.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Card(
            margin: const EdgeInsets.all(2),
            child: ListTile(
              onTap: () async {
                await mp.searchUriFromInternet(uriName: prodAttribute.sirdesc!);
                // final String prodDetailsUrl = 'https://www.google.com/search?q=${prodAttribute.sirdesc}';
                // setState(() {
                //   uri = Uri.parse(prodDetailsUrl);
                // });
                // if (await launchUrl(uri!)) {
                //   await launchUrl(uri!, mode: LaunchMode.externalApplication);
                // } else {
                //   throw 'Could not launch $uri!';
                // }
              },
              //leading: Image.asset(Images.savsol_logo),
              title: Text(
                //"${product.sirdesc}",
                "${prodAttribute.sirdesc}",
                style: poppinRegular.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: ColorResources.getTextBgGreen(context),
                ),
                //"${mobilP.retItemSale![index].sirdesc}",
                // style: robotoBold.copyWith(
                //   fontSize: 13,
                //   color: Colors.black,
                // ),
              ),
              subtitle: Text(
                "ID : ${prodAttribute.sircode}",
                // "${product.sircode}",
                //"${mobilP.retItemSale![index].sircode} ",
                style: poppinRegular.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: ColorResources.getTextBg(context),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
