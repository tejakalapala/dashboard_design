part of 'watchlist_bloc.dart';


abstract class WatchlistEvent extends Equatable {}
class FetchWatchlistEvent extends WatchlistEvent{
  @override
  List<Object> get props => [];
}
class SortWatchlistEvent extends WatchlistEvent{
  final List<Symbols> symbols;
  final int sortIndex;
   SortWatchlistEvent({required this.sortIndex,this.symbols = const <Symbols>[]});
  @override
  List<Object> get props => [symbols];
}
class FetchGroupSymbolsEvent extends WatchlistEvent{
  final List<Symbols> symbols;
  final int index;
  FetchGroupSymbolsEvent({required this.symbols,required this.index});
  @override
  
  List<Object?> get props => [symbols];

}
class SearchEvent extends WatchlistEvent{
  final List<Symbols> symbols;
  final String searchQuery;
  SearchEvent({required this.symbols,required this.searchQuery});
  @override
  List<Object?> get props => [symbols];

}