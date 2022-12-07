class Extra {
  int? id;

  final String extraword;

  Extra({
    required this.extraword,
  });

  Map<String, dynamic> toMap() {
    return {'extra': extraword};
  }

  factory Extra.fromMap({required Map<String, dynamic> map}) {
    return Extra(
      extraword: map['extraword'],
    );
  }
}
