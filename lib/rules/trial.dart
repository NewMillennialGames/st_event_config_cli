// enum AppSection {
//   // major screens or app-areas that user may wish to configure
//   eventConfiguration,
//   eventSelection,
//   poolSelection,
//   marketView,
//   socialPools,
//   news,
//   leaderboard,
//   portfolio,
//   trading,
//   marketResearch,
// }

// void main() {
//   for (AppSection s in AppSection.values) {
//     print(s.name);
//   }
// }

Type typeOf<T>() => T;

class MyClass<T> {
  String genTyp() {
    // return T.runtimeType.toString();
    return typeOf<T>().toString();
  }

  bool get isStr => T == String;
  bool get isInt => T == int;
}

main() {
  Type type = typeOf<MyClass<int>>();
  print(type);
  var mc = MyClass<String>();
  print(mc.genTyp());
  print(mc.isStr);
  print(mc.isInt);
}
