import 'package:gradely/Calculations/manager.dart';

import 'calculator.dart';
import 'term.dart';

class Year {
  List<Term> terms = [];

  double result = 0;

  Year() {
    addTerms();

    calculate();
  }

  void addTerms() {
    for (int i = 0; i < Manager.maxTerm; i++) {
      terms.add(Term());
    }
  }

  void calculate() {
    List<double> results = [];
    List<double> coefficients = [];

    for (Term t in terms) {
      t.calculate();

      results.add(t.result);
      coefficients.add(1.0);
    }

    result = Calculator.calculate(results, coefficients);
  }

  String getResult() {
    if (result > -1) {
      return Calculator.format(result);
    } else {
      return "-";
    }
  }

  Year.fromJson(Map<String, dynamic> json) {
    var termList = json["terms"] as List;
    List<Term> t = termList.map((termJson) => Term.fromJson(termJson)).toList();

    terms = t;
  }

  Map<String, dynamic> toJson() => {
        "terms": terms,
      };
}
