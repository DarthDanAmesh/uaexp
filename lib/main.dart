import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uaexpense/transaction_response.dart';

import 'transactions.dart';
import 'constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // Keys are IDs for widgets.
  // the use of Key ? key is so that the flutter engine knows/keeps track of widgets, e.g., which widget(s) got removed etc.
  const MyApp({Key ? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}): super (key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  Future<TransactionResponse> ? response;

  @override
  void initState(){
    super.initState();

    response = fetchTransactions();

  }

  Future<TransactionResponse> fetchTransactions() async {
    // read from the json file
    String resultJson = await rootBundle.loadString(Constants.transactionsURL);

    // parse the string using jsonDecode
    Map<String, dynamic> result = jsonDecode(resultJson);

    // assign the json object to type TransactionResponse
    TransactionResponse transactionResponse = TransactionResponse.fromJson(result);
    return transactionResponse;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: AppBarRow(),
            backgroundColor: Constants.appBarBackgroundColor,
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 210.0,
            flexibleSpace: FlexibleSpaceBar(
              background: FlexibleBar(),
            ),
          ),

          SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return FutureBuilder(
                future: response,
                builder: (BuildContext context,
                    AsyncSnapshot<TransactionResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Transactions response =
                    snapshot.data!.transactionsList[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          response.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(response.type),
                        trailing: response.amount.isNegative? Text(
                          "${response.amount.toString()}\$",
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                            : Text(
                          "${response.amount.toString()}\$",
                          style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),

                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }, childCount: 17),
          ),
        ],
      ),
    );
  }
}




class FlexibleBar extends StatelessWidget{
  const FlexibleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Total Balance',
              style: TextStyle(color: Constants.appBarTextColor, fontSize: 15.0),
            ),
            Text(
              "\$10,048",
              style: TextStyle(color: Constants.appBarTextColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.more_horiz
            ),
            Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 5.0),
            child: Row(
              children: [
                Text(
                  "\$10,048",
                  style: TextStyle(color: Constants.appBarTextColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  "USD",
                  style: TextStyle(color: Constants.appBarTextColor,
                ),
                ),
                Spacer(),
                Text(
                  "KES \$10,800",
                  style: TextStyle(color: Constants.appBarTextColor,
                ),
            ),
              ],
            ),
            ),
            Padding(padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
              child: LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Constants.linearProgressIndicatorColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Constants.appBarTextColor,
                ),
                value: 0.8,
              ),),
          ],
        ),
    );
  }
}

class AppBarRow extends StatelessWidget{
  const AppBarRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.circle_outlined,color: Constants.appBarTextColor,
        ),

        Text(
          'My Spending',
          style: TextStyle(color: Constants.appBarTextColor, fontSize: 20.0),

        ),
        Icon(
          Icons.calendar_today,color: Constants.appBarTextColor,
        ),
      ],
    );
  }
}
