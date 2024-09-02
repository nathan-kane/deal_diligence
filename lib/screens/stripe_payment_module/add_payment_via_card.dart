import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/stripe_payment_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/stripe_payment_module/show_card_list.dart';
import 'package:deal_diligence/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPaymentViaCard extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const AddPaymentViaCard(this.email, this.password, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddPaymentViaCardState();
}

class AddPaymentViaCardState extends ConsumerState<AddPaymentViaCard> {
  String errorMessage = "";
  final _auth = FirebaseAuth.instance;
  bool registrationFail = false;

  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool saveCard = false;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: CreditCardWidget(
                        enableFloatingCard: useFloatingAnimation,
                        glassmorphismConfig: _getGlassmorphismConfig(),
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        // bankName: 'Axis Bank',
                        frontCardBorder: useGlassMorphism
                            ? null
                            : Border.all(color: Colors.grey),
                        backCardBorder: useGlassMorphism
                            ? null
                            : Border.all(color: Colors.grey),
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardBgColor: isLightTheme
                            ? AppColors.cardBgLightColor
                            : AppColors.cardBgColor,
                        backgroundImage: null,
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {},
                        customCardTypeIcons: <CustomCardTypeIcon>[
                          CustomCardTypeIcon(
                            cardType: CardType.mastercard,
                            cardImage: Image.asset(
                              'lib/assets/images/mastercard.png',
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        inputConfiguration: const InputConfiguration(
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: InputDecoration(
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            labelText: 'Card Holder',
                          ),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       const Text('Glassmorphism'),
                        //       const Spacer(),
                        //       Switch(
                        //         value: useGlassMorphism,
                        //         inactiveTrackColor: Colors.grey,
                        //         activeColor: Colors.white,
                        //         activeTrackColor: AppColors.colorE5D1B2,
                        //         onChanged: (bool value) => setState(() {
                        //           useGlassMorphism = value;
                        //         }),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       const Text(
                        //         'Save Card',
                        //         style: TextStyle(color: Colors.black),
                        //       ),
                        //       // const Spacer(),
                        //       Switch(
                        //         value: saveCard,
                        //         inactiveTrackColor: Colors.grey,
                        //         activeColor: Colors.white,
                        //         activeTrackColor: AppColors.colorE5D1B2,
                        //         onChanged: (bool value) => setState(() {
                        //           saveCard = value;
                        //         }),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       const Text('Floating Card'),
                        //       const Spacer(),
                        //       Switch(
                        //         value: useFloatingAnimation,
                        //         inactiveTrackColor: Colors.grey,
                        //         activeColor: Colors.white,
                        //         activeTrackColor: AppColors.colorE5D1B2,
                        //         onChanged: (bool value) => setState(() {
                        //           useFloatingAnimation = value;
                        //         }),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _onValidate,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 80),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Pay with new card',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ShowCardList()));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 80),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Pay with existing card',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      // print('valid!');
      var responseData = await ref
          .read(getStripeTokenProvider.notifier)
          .getStripeToken(
              userName: cardHolderName,
              cardNumber: cardNumber,
              cvc: cvvCode,
              month: expiryDate.split('/').first,
              year: expiryDate.split('/').last);
      print('+++++$responseData');
      if (responseData) {
        handleSuccessResponse();
      }
    } else {
      print('invalid!');
    }
  }

  handleSuccessResponse() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Paid successfully")),
    );
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      if (newUser != null) {
        final userNotifier = ref.read(usersNotifierProvider.notifier);
        final globalsNotifier = ref.read(globalsNotifierProvider.notifier);

        userNotifier.updateuserID(newUser.user!.uid);
        userNotifier.updateEmail(newUser.user!.email!);
        globalsNotifier.updatenewUser(true);
        globalsNotifier.updatenewCompany(true);

        // Navigate to VerifyEmailScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const VerifyEmailScreen(),
          ),
        );
      } else {
        setState(() {
          registrationFail = true;
        });
      }

      // setState(() {
      //   showSpinner = false;
      // });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "email-already-in-use":
          errorMessage = "Email is already in use.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "weak-password":
          errorMessage = "Weak password";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened. Please try again.";
      }

      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w900),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 10,
            right: 10,
          ),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class AppColors {
  AppColors._();

  static const Color cardBgColor = Color(0xff363636);
  static const Color cardBgLightColor = Color(0xff999999);
  static const Color colorB58D67 = Color(0xffB58D67);
  static const Color colorE5D1B2 = Color(0xffE5D1B2);
  static const Color colorF9EED2 = Color(0xffF9EED2);
  static const Color colorEFEFED = Color(0xffEFEFED);
}
