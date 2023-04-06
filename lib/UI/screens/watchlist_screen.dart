import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dashboard_design/bloc/watchlist/watchlist_bloc.dart';
import 'package:dashboard_design/models/stock_model.dart';
import 'package:dashboard_design/UI/widgets/dash_line.dart';
import 'package:dashboard_design/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../constants/constants.dart';
import '../../cubit/theme/theme_cubit.dart';
import 'chart_screen.dart';

enum SortType { atoz, ztoa, idasc, iddesc }

enum ThemePref {
  dark,
  light,
  systemDefault;
}
enum WatchlistCategory{list1,list2,list3,list4}

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  
  List<Symbols> symbolsList = [];
  List<Symbols> duplicateList = [];
  List<Symbols> groupList = [];
  bool status = false;
  bool checkBoxValue = false;
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  ValueNotifier<bool> isSell = ValueNotifier<bool>(false);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchlistBloc>().add(FetchWatchlistEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: state.scaffoldBackgroundColor,
            // backgroundColor: Colors.grey.shade100,
            body: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 3.3,
                    color: state.colorScheme.background,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.nifty50,
                                    textAlign: TextAlign.right,
                                    style: state.textTheme.displayLarge,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '14,696.50 ',
                                      style: state.textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '(1.04%)',
                                          style: state.textTheme.bodySmall
                                              ?.copyWith(
                                                  color:
                                                      AppColors.negativeColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppConstants.sensex,
                                    textAlign: TextAlign.end,
                                    style: state.textTheme.displayLarge,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '48,690.80 ',
                                      style: state.textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '(0.96%)',
                                            style: state.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: AppColors
                                                        .negativeColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const DashLineSeparator(
                          height: 0.3,
                          color: AppColors.lineSeparatorColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: selectedIndex,
                                      builder: (context,value,_) {
                                        return Text(
                                          "My List${value+1}",
                                          style: state.textTheme.labelSmall,
                                        );
                                      }
                                    ),
                                    popUpWatchlistButton(context, state.iconTheme.color!)
                                  ],
                                ),
                                onTap: () {},
                              ),
                              popUpMenuButton(context, state.iconTheme.color!),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            onChanged: (value) {
                              context.read<WatchlistBloc>().add(SearchEvent(
                                  symbols: groupList, searchQuery: value));
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search_outlined,
                                  color: state.iconTheme.color,
                                ),
                                border: const OutlineInputBorder(),
                                hintText: "Search & Add",
                                suffix: const Text(
                                  "4/30",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: state.indicatorColor),
                                ),
                                focusColor: state.indicatorColor),
                          ),
                        ),
                        Expanded(
                          // scrollDirection: Axis.vertical,
                          child: BlocBuilder<WatchlistBloc, WatchlistState>(
                            builder: (context, state) {
                              if (state is WatchlistLoadingState) {
                                return const Center(
                                    child: CircularProgressIndicator(color: AppColors.sbiColor,));
                              } else if (state is WatchlistLoadedState) {
                                symbolsList = state.symbols;
                                duplicateList = symbolsList;
                                context.read<WatchlistBloc>().add(FetchGroupSymbolsEvent(symbols: symbolsList, index: 0));
                                return Container();
                              } else if(state is SearchLoadedState){
                                duplicateList = state.symbols;
                                return watchlistView();
                              }else if(state is GroupLoadedState){
                                groupList = state.symbols;
                                duplicateList = groupList;
                                return watchlistView();
                              }else if(state is WatchlistSortedState){
                                duplicateList = state.symbols;
                                return watchlistView();
                              }
                              else {
                                return const Center(
                                  child: Text(AppConstants.strDataFetchError),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: popUpThemeMenuButton(
                                  context, state.iconTheme.color!))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          height:
                              (MediaQuery.of(context).size.height * 0.6) - 15,
                          color: state.colorScheme.background,
                          child: Column(
                            children: [
                              Container(
                                color: state.colorScheme.background,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SBIN",
                                        style: state.textTheme.bodyMedium,
                                      ),
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showPopup(0);
                                              },
                                              style: state
                                                  .elevatedButtonTheme.style!
                                                  .copyWith(
                                                      backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                              AppColors
                                                                  .positiveColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ))),
                                              child: const Text(
                                                AppConstants.strBuy,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showPopup(1);
                                              },
                                              style: state
                                                  .elevatedButtonTheme.style!
                                                  .copyWith(
                                                      backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                              AppColors
                                                                  .negativeColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ))),
                                              child: const Text(
                                                AppConstants.strSell,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Container(
                                  color: state.colorScheme.background,
                                  height: ((MediaQuery.of(context).size.height -
                                              35) *
                                          0.6) -
                                      35,
                                  child: ChatScreen(),
                                ),
                              )
                            ],
                          )
                          // MyHomePage(),
                          ),
                    ),
                    Container(
                      height: 5,
                      color: state.scaffoldBackgroundColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5,
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.4 - 20,
                          color: state.colorScheme.background,
                          child: DefaultTabController(
                            length: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                PreferredSize(
                                  preferredSize: const Size.fromHeight(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TabBar(
                                            indicatorColor:
                                                state.indicatorColor,
                                            labelColor: state.indicatorColor,
                                            unselectedLabelColor:
                                                state.unselectedWidgetColor,
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            isScrollable: true,
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            tabs: const [
                                              // width: 30,
                                              Tab(
                                                text: AppConstants.strOverview,
                                              ),

                                              Tab(
                                                  text: AppConstants
                                                      .strTechnicals),
                                              Tab(
                                                  text:
                                                      AppConstants.strFutures),
                                              Tab(
                                                  text:
                                                      AppConstants.strOptions),
                                              Tab(text: AppConstants.strNews),
                                            ]),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: state.iconTheme.color,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  //Add this to give height
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: TabBarView(children: [
                                    Text(
                                      AppConstants.strOverview,
                                      style: state.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      AppConstants.strTechnicals,
                                      style: state.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      AppConstants.strFutures,
                                      style: state.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      AppConstants.strOptions,
                                      style: state.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      AppConstants.strNews,
                                      style: state.textTheme.bodyMedium,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ))
              ],
            ));
      },
    );
  }

  ListView watchlistView() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        
            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
                  child: Card(
                    child: Container(
                      color: state.colorScheme.secondaryContainer,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 10,),
                                RichText(
                                  text: TextSpan(
                                    text: '${duplicateList[index].dispSym} ',
                                    style: state.textTheme.bodyLarge,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${duplicateList[index].sym!.exc}',
                                          style: state.textTheme.bodySmall),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  duplicateList[index].companyName ?? "NA",
                                  style: state.textTheme.bodyMedium,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${duplicateList[index].excToken}',
                                  style: state.textTheme.bodyLarge,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '0.0 (0.0%)',
                                  style: state.textTheme.labelSmall,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        
      itemCount: duplicateList.length,
    );
  }

  void showPopup(int index) {
    showAlignedDialog(
        context: context,
        builder: _horizontalDrawerBuilder(index),
        followerAnchor: Alignment.topLeft,
        isGlobal: true,
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position:
                Tween(begin: const Offset(1, 0), end: const Offset(0.59, 0))
                    .animate(animation),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            ),
          );
        });
  }

  WidgetBuilder _horizontalDrawerBuilder(int index) {
    return (BuildContext context) {
      if(index == 1){
        isSell.value = true;
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.345,
        child: Drawer(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close)),
                        Text(
                          AppConstants.strSbi,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                    const DashLineSeparator(
                      height: 0.3,
                      color: AppColors.lineSeparatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: 'SBIN ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: AppConstants.strNse,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: const TextSpan(
                                      text: '189.00 ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '+3.00 (+1.80%)',
                                          style: TextStyle(
                                              color: AppColors.positiveColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ValueListenableBuilder(
                                builder: (context,value,_) {
                                  return FlutterSwitch(
                                    height: 40.0,
                                    width: 90.0,
                                    padding: 4.0,
                                    toggleSize: 25.0,
                                    borderRadius: 25.0,
                                    inactiveColor:  AppColors.positiveColor,
                                    activeColor: AppColors.negativeColor,
                                    value: isSell.value,
                                    inactiveText:  AppConstants.strBuy,
                                    showOnOff: true,
                                    activeText: AppConstants.strSell,
                                    inactiveTextColor: Colors.white,
                                    onToggle: (value) {
                                      isSell.value = value;
                                      },
                                  );
                                }, valueListenable: isSell,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                AppConstants.strProduct,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: Theme.of(context)
                                          .elevatedButtonTheme
                                          .style
                                          ?.copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      AppColors.sbiColor)),
                                      child: Text(
                                        AppConstants.strDelivery,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.white),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      AppConstants.strIntraday,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppConstants.strEMargin,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.black),
                                      )),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppConstants.strCover,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.black),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppConstants.strQuantity,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                width: 200,
                                height: 70,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppConstants.strPrice,
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                  // Checkbox(value: checkBoxValue, onChanged: (value){}),
                                  // Text("Mkt Price",style: Theme.of(context).textTheme.labelSmall,)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                width: 200,
                                height: 70,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Validity",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                               SizedBox(
                                width: 200,
                                height: 50,
                                child: Container(
                                  
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 66.67,
                                        // height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.sbiColor,
                                          border: Border.all(
                                            color: Colors.grey
                                          )
                                        ),
                                        child: const Center(child: Text("DAY")),
                                      ),
                                      Container(
                                        width: 66.66,
                                        // height:40,
                                        decoration: BoxDecoration(
                                          
                                          border: Border.all(
                                            color: Colors.grey,
                                          )
                                        ),
                                        
                                        child: const Center(child: Text("IOC")),
                                      ),
                                      Container(
                                        // height: 40,
                                        width: 66.67,
                                        decoration: BoxDecoration(

                                          border: Border.all(
                                            color: Colors.grey,
                                          )
                                        ),
                                        child: const Center(child: Text("GTC")),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Disclosed Quantity",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                width: 200,
                                height: 70,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100,
                      child: 
                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stoploss trigger Price",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  width: 200,
                                  height: 70,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "0",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:0.0,right: 0.0,bottom: 0.0,top: 100),

                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: InkWell(
                                
                                child: ValueListenableBuilder(
                                  builder: (context,value,_) {
                                    return Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      width:double.maxFinite ,
                                      color: isSell.value ? AppColors.negativeColor : AppColors.positiveColor,
                                      child:isSell.value ?  Text(AppConstants.strSell,
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: Colors.white
                                      ),
                                      ) : 
                                       Text(AppConstants.strBuy,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: Colors.white
                                      ),
                                       )
                                      
                                    );
                                  }, valueListenable: isSell,
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              )),
        ),
      );
    };
  }

  PopupMenuButton<SortType> popUpMenuButton(BuildContext context, Color color) {
    return PopupMenuButton<SortType>(
      offset: const Offset(0.0, 35),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: SortType.atoz,
          child: Text(
            AppConstants.strAtoZ,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: SortType.ztoa,
          child: Text(
            AppConstants.strZtoA,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: SortType.idasc,
          child: Text(
            AppConstants.str0to9,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: SortType.iddesc,
          child: Text(
            AppConstants.str9to0,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case SortType.atoz:
            context
                .read<WatchlistBloc>()
                .add(SortWatchlistEvent(sortIndex: 0, symbols: groupList));
            break;
          case SortType.ztoa:
            context
                .read<WatchlistBloc>()
                .add(SortWatchlistEvent(sortIndex: 1, symbols: groupList));
            break;
          case SortType.idasc:
            context
                .read<WatchlistBloc>()
                .add(SortWatchlistEvent(sortIndex: 2, symbols: groupList));
            break;
          case SortType.iddesc:
            context
                .read<WatchlistBloc>()
                .add(SortWatchlistEvent(sortIndex: 3, symbols: groupList));
            break;
          default:
        }
      },
      icon: Icon(Icons.sort, color: color),
    );
  }

  PopupMenuButton<WatchlistCategory> popUpWatchlistButton(BuildContext context, Color color) {
    return PopupMenuButton<WatchlistCategory>(
      offset: const Offset(0.0, 35),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: WatchlistCategory.list1,
          child: Text(
            "My List1",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: WatchlistCategory.list2,
          child: Text(
            "My List2",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: WatchlistCategory.list3,
          child: Text(
            "My List3",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: WatchlistCategory.list4,
          child: Text(
            "My List4",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case WatchlistCategory.list1:
            selectedIndex.value = 0;
            context
                .read<WatchlistBloc>()
                .add(FetchGroupSymbolsEvent(index: 0, symbols: symbolsList));
            break;
          case WatchlistCategory.list2:
          selectedIndex.value = 1;
            context
                .read<WatchlistBloc>()
                .add(FetchGroupSymbolsEvent(index: 1, symbols: symbolsList));
            break;
          case WatchlistCategory.list3:
          selectedIndex.value = 2;
            context
                .read<WatchlistBloc>()
                .add(FetchGroupSymbolsEvent(index: 2, symbols: symbolsList));
            break;
          case WatchlistCategory.list4:
          selectedIndex.value = 3;
            context
                .read<WatchlistBloc>()
                .add(FetchGroupSymbolsEvent(index: 3, symbols: symbolsList));
            break;
          default:
        }
      },
      icon: Icon(
         Icons.keyboard_arrow_down,
         color: color,
    )
    );
  }

  PopupMenuButton<ThemePref> popUpThemeMenuButton(
      BuildContext context, Color color) {
    return PopupMenuButton<ThemePref>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemePref.light,
          child: Text(
            "Light",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        PopupMenuItem(
          value: ThemePref.dark,
          child: Text(
            "Dark",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        //  PopupMenuItem(
        //   value: ThemePref.systemDefault,
        //   child: Text("System Settings",style: Theme.of(context).textTheme.labelSmall,),
        // )
      ],
      onSelected: (value) {
        switch (value) {
          case ThemePref.light:
            context.read<ThemeCubit>().setTheme(value);
            break;
          case ThemePref.dark:
            context.read<ThemeCubit>().setTheme(value);
            break;
          // case ThemePref.systemDefault:
          //   context.read<ThemeCubit>().setTheme(value);
          //   break;
          default:
        }
      },
      icon: Icon(
        Icons.brightness_6,
        size: 14,
        color: color,
      ),
    );
  }
}
