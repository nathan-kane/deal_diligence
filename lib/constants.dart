//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

/// Responsive UI constants
double kTitleTextFontSize = 14.sp;
double kTextFieldTextFontSize = 8.sp;
double kTextFieldHintFontSize = 6.sp;
double kTextButtonFontSize = 8.sp;
double kListHeaderFontSize = 6.sp;
double kListBodyFontSize = 4.sp;

const kDefaultPadding = 20.0;
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const appBarBackColor = Colors.blueAccent;

const List kBusinessType = [
  'Real Estate',
  'Solar Sales',
];

const List kFrequencyList = ['daily', 'weekly', 'monthly', 'yearly'];

const List kTrxnStatus = [
  'Select Status',
  'Prospect',
  'Listed',
  'Under Contract',
  'On Hold',
  'Closed',
  'Archived'
];

const List kClientType = ['Choose Client Type', 'Buyer', 'Seller'];

const List kStates = [
  'Choose State',
  'AL',
  'AK',
  'AZ',
  'AR',
  'CA',
  'CO',
  'CT',
  'DE',
  'FL',
  'GA',
  'HI',
  'ID',
  'IL',
  'IN',
  'IA',
  'KS',
  'KY',
  'LA',
  'ME',
  'MD',
  'MA',
  'MI',
  'MN',
  'MS',
  'MO',
  'MT',
  'NE',
  'NV',
  'NH',
  'NJ',
  'NM',
  'NY',
  'NC',
  'ND',
  'OH',
  'OK',
  'OR',
  'PA',
  'RI',
  'SC',
  'SD',
  'TN',
  'TX',
  'UT',
  'VT',
  'VA',
  'WA',
  'WV',
  'WY'
];
