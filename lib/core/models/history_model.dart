class HistoryModel {
  String? status;
  List<String>? title;
  List<int>? price;
  List<int>? quantity;
  String? date;
  String? time;
  final images;

  HistoryModel({
    this.status,
    this.title,
    this.price,
    this.quantity,
    this.images,
    this.time,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': this.status,
      'title': this.title,
      'price': this.price,
      'quantity': this.quantity,
      'date': this.date,
      'time': this.time,
      'images': this.images,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      status: map['status'] as String,
      title: map['title'] as List<String>,
      price: map['price'] as List<int>,
      quantity: map['quantity'] as List<int>,
      date: map['date'] as String,
      time: map['time'] as String,
      images: map['images'] as List<List<String>>,
    );
  }
}
