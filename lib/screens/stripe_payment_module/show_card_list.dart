import 'package:deal_diligence/Providers/stripe_payment_provider.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_card_list_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowCardList extends ConsumerStatefulWidget {
  const ShowCardList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ShowCardListState();
}

class ShowCardListState extends ConsumerState<ShowCardList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getStripeTokenProvider.notifier).getCustomerList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Credit Cards'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final cardList = ref.watch(
            getStripeTokenProvider.select((state) => state.getCardList?.data));
        if (cardList == null) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while fetching data
        }
        if (cardList.isEmpty) {
          return Center(child: Text('No cards available')); // Handle empty list
        }
        return ListView.builder(
          itemCount: cardList.length,
          itemBuilder: (context, index) {
            return card(cardList[index]);
          },
        );
      }),
    );
  }

  Widget card(Datum? data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.last4 ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data?.name ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                ref
                    .read(getStripeTokenProvider.notifier)
                    .payPayment(cust: data!.customer, source: data.id);
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                alignment: Alignment.center,
                child: const Text(
                  'Pay ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
