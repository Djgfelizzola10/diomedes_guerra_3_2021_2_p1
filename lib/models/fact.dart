class Fact {
  int factId=0;
  String fact='';

  Fact({
    required this.factId,
    required this.fact
    });

  Fact.fromJson(Map<String, dynamic> json) {
    factId = json['fact_id'];
    fact = json['fact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> fact = new Map<String, dynamic>();
    fact['fact_id'] = this.factId;
    fact['fact'] = this.fact;
    return fact;
  }
}