class ResultServiceModel {
  String? code;
  String? message;

  ResultServiceModel(this.code, this.message);

  factory ResultServiceModel.withError(String errorValue) =>
      new ResultServiceModel(null, errorValue);

  factory ResultServiceModel.fromJson(Map<String, dynamic> json) =>
      new ResultServiceModel(json['Code'], json['Message']);

  @override
  String toString() {
    return 'ResultServiceModel{code: $code, message: $message}';
  }
}
