class ApiURL {
  static const String publicTestKey =
      'pk_test_51OOkCzLLjsDD7g7b0sBcRBgQvaimzoiBHdg3NK7UOqXvbml1WwnaZC4OdF5ncpwyStO1CFpWmUuwHAxhwM95O5G000Qp2heWf9';
  static const String secretKey =
      'sk_test_51OOkCzLLjsDD7g7bk234ordeohpGUGhPvooaHsWhRT6IJ7eWA1ddNdW1yDUlfDIVc1pI0pxZaZyLpQEPeBGlmDgB004NhYwMv1';
  static const String stripeBaseUrl = 'https://api.stripe.com/v1';
  static const String getToken = '$stripeBaseUrl/tokens';
  static const String addCustomer = '$stripeBaseUrl/customers';
  static const String pay = '$stripeBaseUrl/charges';
}
