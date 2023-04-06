part of 'watchlist_bloc.dart';


abstract class WatchlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class WatchlistLoadingState extends WatchlistState{}
class WatchlistInitial extends WatchlistState {}
class WatchlistLoadedState extends WatchlistState{
  final List<Symbols> symbols;
  WatchlistLoadedState(this.symbols);
  @override
  List<Object> get props => [symbols];
}
class SearchLoadedState extends WatchlistState{
  final List<Symbols> symbols;
  SearchLoadedState(this.symbols);
  @override
  List<Object> get props => [symbols];
}

class GroupLoadedState extends WatchlistState{
  final List<Symbols> symbols;
  GroupLoadedState(this.symbols);
  @override
  List<Object> get props => [symbols];
}
class WatchlistSortedState extends WatchlistState{
  final List<Symbols> symbols;
  WatchlistSortedState(this.symbols);
  @override
  List<Object> get props => [symbols];
}

class WatchlistFailureState extends WatchlistState{}