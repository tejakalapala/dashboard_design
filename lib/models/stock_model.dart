class StockModel{
  String? name;
  String? type;
  String? price;
  String? fullName;
  String? change;
  String? changePerc;
  StockModel({this.name,this.type,this.price,this.fullName,this.change,this.changePerc});
}

class Symbols {
  String? baseSym;
  String? companyName;
  String? dispSym;
  String? excToken;
  String? haircut;
  String? isin;
  String? mCap;
  String? sector;
  Sym? sym;
  bool? ttEligibility;

  Symbols(
      {this.baseSym,
      this.companyName,
      this.dispSym,
      this.excToken,
      this.haircut,
      this.isin,
      this.mCap,
      this.sector,
      this.sym,
      this.ttEligibility});
}

class Sym {
  String? asset;
  String? exc;
  String? expiry;
  String? id;
  String? instrument;
  String? lotSize;
  String? multiplier;
  String? optionType;
  String? streamSym;
  String? strike;
  String? tickSize;

  Sym(
      {this.asset,
      this.exc,
      this.expiry,
      this.id,
      this.instrument,
      this.lotSize,
      this.multiplier,
      this.optionType,
      this.streamSym,
      this.strike,
      this.tickSize});
}