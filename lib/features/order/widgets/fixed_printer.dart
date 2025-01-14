import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/price_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class InvoiceDialogggd extends StatelessWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  // final Function(i.Image? image) onPrint;
  const InvoiceDialogggd({
    super.key,
    required this.order,
    required this.orderDetails,
  });

  String _priceDecimal(double price) {
    return price.toStringAsFixed(
        Get.find<SplashController>().configModel!.digitAfterDecimalPoint!);
  }

  @override
  Widget build(BuildContext context) {
    ///Todo: window changes to (PlatformDispatcher.instance.views.first)
    double fontSize = 20;

    ScreenshotController controllerfsg = ScreenshotController();
    Restaurant restaurant =
        Get.find<ProfileController>().profileModel!.restaurants![0];

    double itemsPrice = 0;
    double addOns = 0;

    for (OrderDetailsModel orderDetails in orderDetails!) {
      for (AddOn addOn in orderDetails.addOns!) {
        addOns = addOns + (addOn.price! * addOn.quantity!);
      }
      itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
    }
// Your existing code...

    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.window),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          body: SingleChildScrollView(
            // padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                        spreadRadius: 1,
                        blurRadius: 5)
                  ],
                ),
                // width: 800,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Screenshot(
                  controller: controllerfsg,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(restaurant.name!,
                            style:
                                robotoMediumprint.copyWith(fontSize: fontSize)),
                        Text(restaurant.address!,
                            style: robotoRegularprint.copyWith(
                                fontSize: fontSize)),
                        Text(restaurant.phone!,
                            style:
                                robotoRegularprint.copyWith(fontSize: fontSize),
                            textDirection: TextDirection.ltr),
                        // Text(restaurant.email!, style: robotoRegularprint.copyWith(fontSize: fontSize)),
                        const SizedBox(height: 10),

                        Wrap(children: [
                          Row(children: [
                            Text('${'order_id'.tr}:',
                                style: robotoRegularprint.copyWith(
                                    fontSize: fontSize)),
                            const SizedBox(width: 5),
                            Text(order!.id.toString(),
                                style: robotoMediumprint.copyWith(
                                    fontSize: fontSize)),
                          ]),
                          Text(
                              DateConverter.dateTimeStringToMonthAndTime(
                                  order!.createdAt!),
                              style: robotoRegularprint.copyWith(
                                  fontSize: fontSize)),
                        ]),

                        order!.scheduled == 1
                            ? Text(
                                '${'scheduled_order_time'.tr} ${DateConverter.dateTimeStringToDateTime(order!.scheduleAt!)}',
                                style: robotoRegularprint.copyWith(
                                    fontSize: fontSize),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 5),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order!.orderType!.tr,
                                  style: robotoRegularprint.copyWith(
                                      fontSize: fontSize)),
                              Text(order!.paymentMethod!.tr,
                                  style: robotoRegularprint.copyWith(
                                      fontSize: fontSize)),
                            ]),
                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${order!.customer!.fName} ${order!.customer!.lName}',
                                  style: robotoRegularprint.copyWith(
                                      fontSize: fontSize)),
                              Text(order!.deliveryAddress?.address ?? '',
                                  style: robotoRegularprint.copyWith(
                                      fontSize: fontSize)),
                              Text(
                                  order!.deliveryAddress?.contactPersonNumber ??
                                      '',
                                  style: robotoRegularprint.copyWith(
                                      fontSize: fontSize)),
                            ]),
                        const SizedBox(height: 10),

                        Row(children: [
                          Expanded(
                              flex: 1,
                              child: Text('sl'.tr.toUpperCase(),
                                  style: robotoMediumprint.copyWith(
                                      fontSize: fontSize))),
                          Expanded(
                              flex: 5,
                              child: Text('item_info'.tr,
                                  style: robotoMediumprint.copyWith(
                                      fontSize: fontSize))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                'qty'.tr,
                                style: robotoMediumprint.copyWith(
                                    fontSize: fontSize),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                'price'.tr,
                                style: robotoMediumprint.copyWith(
                                    fontSize: fontSize),
                                textAlign: TextAlign.right,
                              )),
                        ]),
                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),

                        ListView.builder(
                          itemCount: orderDetails!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            String addOnText = '';
                            for (var addOn in orderDetails![index].addOns!) {
                              addOnText =
                                  '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} X ${addOn.quantity} = ${addOn.price! * addOn.quantity!}';
                            }

                            String? variationText = '';
                            if (orderDetails![index].variation!.isNotEmpty) {
                              for (Variation variation
                                  in orderDetails![index].variation!) {
                                variationText =
                                    '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                                for (VariationOption value
                                    in variation.variationValues!) {
                                  variationText =
                                      '${variationText!}${variationText.endsWith('(') ? '' : ', '}${value.level}';
                                }
                                variationText = '${variationText!})';
                              }
                            } else if (orderDetails![index]
                                .oldVariation!
                                .isNotEmpty) {
                              variationText =
                                  orderDetails![index].oldVariation![0].type;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeExtraSmall),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: robotoRegularprint.copyWith(
                                              fontSize: fontSize),
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orderDetails![index]
                                                    .foodDetails!
                                                    .name!,
                                                style:
                                                    robotoMediumprint.copyWith(
                                                        fontSize: fontSize),
                                              ),
                                              const SizedBox(height: 2),
                                              addOnText.isNotEmpty
                                                  ? Text(
                                                      '${'addons'.tr}: $addOnText',
                                                      style: robotoRegularprint
                                                          .copyWith(
                                                              fontSize:
                                                                  fontSize),
                                                    )
                                                  : const SizedBox(),
                                              (orderDetails![index]
                                                              .foodDetails!
                                                              .variations !=
                                                          null &&
                                                      orderDetails![index]
                                                          .foodDetails!
                                                          .variations!
                                                          .isNotEmpty)
                                                  ? Text(
                                                      '${'variations'.tr}: ${variationText!}',
                                                      style: robotoRegularprint
                                                          .copyWith(
                                                              fontSize:
                                                                  fontSize),
                                                    )
                                                  : const SizedBox(),
                                            ])),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          orderDetails![index]
                                              .quantity
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: robotoRegularprint.copyWith(
                                              fontSize: fontSize),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          _priceDecimal(
                                              orderDetails![index].price!),
                                          textAlign: TextAlign.right,
                                          style: robotoRegularprint.copyWith(
                                              fontSize: fontSize),
                                        )),
                                  ]),
                            );
                          },
                        ),
                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),

                        PriceWidget(
                            title: 'item_price'.tr,
                            value: _priceDecimal(itemsPrice),
                            fontSize: fontSize),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),

                        // addOns > 0
                        //     ? PriceWidget(
                        //         title: 'add_ons'.tr,
                        //         value: _priceDecimal(addOns),
                        //         fontSize: fontSize)
                        //     : const SizedBox(),
                        // SizedBox(
                        //     height: addOns > 0
                        //         ? Dimensions.paddingSizeExtraSmall
                        //         : 0),

                        // PriceWidget(
                        //     title: 'subtotal'.tr,
                        //     value: _priceDecimal(itemsPrice + addOns),
                        //     fontSize: fontSize),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),

                        // PriceWidget(
                        //     title: 'discount'.tr,
                        //     value:
                        //         _priceDecimal(order!.restaurantDiscountAmount!),
                        //     fontSize: fontSize),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),

                        // PriceWidget(
                        //     title: 'coupon_discount'.tr,
                        //     value: _priceDecimal(order!.couponDiscountAmount!),
                        //     fontSize: fontSize),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),

                        // PriceWidget(
                        //   title: '${'vat_tax'.tr}',
                        //   value: _priceDecimal(order!.totalTaxAmount!),
                        //   fontSize: fontSize,
                        // ),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),

                        // PriceWidget(
                        //     title: 'delivery_man_tips'.tr,
                        //     value: _priceDecimal(order!.dmTips!),
                        //     fontSize: fontSize),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),

                        PriceWidget(
                            title: 'delivery_fee'.tr,
                            value: _priceDecimal(order!.deliveryCharge!),
                            fontSize: fontSize),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),

                        (order!.additionalCharge != null &&
                                order!.additionalCharge! > 0)
                            ? PriceWidget(
                                title: Get.find<SplashController>()
                                    .configModel!
                                    .additionalChargeName!,
                                value: _priceDecimal(order!.additionalCharge!),
                                fontSize: fontSize,
                              )
                            : const SizedBox(),

                        order!.paymentMethod == 'partial_payment'
                            ? Column(children: [
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                PriceWidget(
                                    title: 'paid_by_wallet'.tr,
                                    value: _priceDecimal(
                                        order!.payments![0].amount!),
                                    fontSize: fontSize),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                PriceWidget(
                                    title:
                                        '${order!.payments![1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order!.payments![1].paymentMethod?.toString().replaceAll('_', ' ')})',
                                    value: _priceDecimal(
                                        order!.payments![1].amount!),
                                    fontSize: fontSize),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                              ])
                            : const SizedBox(),

                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),
                        PriceWidget(
                            title: 'total_amount'.tr,
                            value: _priceDecimal(order!.orderAmount!),
                            fontSize: fontSize + 2),
                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),

                        Text('thank_you'.tr,
                            style: robotoRegularprint.copyWith(
                                fontSize: fontSize)),
                        Divider(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            thickness: 1),

                        // Text(
                        //   '${Get.find<SplashController>().configModel!.businessName}. ${Get.find<SplashController>().configModel!.footerText}',
                        //   style: robotoRegularprint.copyWith(fontSize: fontSize),
                        // ),
                      ]),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              // CustomButtonWidget(
              //     buttonText: 'print_invoice'.tr,
              //     height: 40,
              //     onPressed: () async {
              //       controllerfsg
              //           .capture(delay: Duration(milliseconds: 100), pixelRatio: 3.0
              //         )
              //           .then((value) => print(value));
              //     }),
            ]),
          )),
    );
  }
}

// Helper function to print text with alignment
Future<void> printTextWithAlignment(
  String text,
  SunmiPrintAlign alignment, [
  SunmiFontSize fontSize = SunmiFontSize.SM,
]) async {
  await SunmiPrinter.setAlignment(alignment);
  await SunmiPrinter.setFontSize(fontSize);
  await SunmiPrinter.printText(text);
}
