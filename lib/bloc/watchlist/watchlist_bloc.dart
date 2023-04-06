
import 'package:dashboard_design/models/stock_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/repositories.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _watchlistRepository;
  WatchlistBloc(this._watchlistRepository) : super(WatchlistInitial()) {
    on<FetchWatchlistEvent>((event, emit) async {
      emit(WatchlistLoadingState());
      try {
        final symbols = await _watchlistRepository.getSymbols();
        emit(WatchlistLoadedState(symbols));
      } catch (e) {
        emit(WatchlistFailureState());
      }
    });
    on<SortWatchlistEvent>((event, emit) async {
      emit(WatchlistLoadingState());
      try {
        List<Symbols> symbols = event.symbols;
        if(event.sortIndex == 0){
        symbols.sort((a, b) => a.dispSym!.compareTo(b.dispSym!)
    );
        }else if(event.sortIndex == 1){
          symbols.sort((b, a) => a.dispSym!.compareTo(b.dispSym!));
        }
        else if(event.sortIndex == 2){
          symbols.sort((a, b) => int.parse(a.excToken!).compareTo(int.parse(b.excToken!)));
        }
        else if(event.sortIndex == 3){
          symbols.sort((b, a) => int.parse(a.excToken!).compareTo(int.parse(b.excToken!)));
        }
        emit(WatchlistSortedState(symbols));
      } catch (e) {
        emit(WatchlistFailureState());
      }
    });
    on<SearchEvent>((event, emit) async {
      emit(WatchlistLoadingState());
      List<Symbols> searchSymbols = [];
      for (var element in event.symbols) {
        if(element.companyName!.toLowerCase().contains(event.searchQuery.toLowerCase()) || 
        element.dispSym!.toLowerCase().contains(event.searchQuery.toLowerCase())){
          searchSymbols.add(element);
        }
      }
      emit(SearchLoadedState(searchSymbols));
    });
    on<FetchGroupSymbolsEvent>((event, emit) async {
      emit(WatchlistLoadingState());
      List<Symbols> groupSymbols = [];
      for (int i = (event.index) * 4; i < (event.index) * 4 + 4; i++) {
       groupSymbols.add(event.symbols[i]);
      }
      emit(GroupLoadedState(groupSymbols));
    });
  }

}