class Products {
  final int id ;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;


  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
  });

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: json["image"],
      description: json['description'],
      category: json['category'],
      rating: json['rating']['rate'].toDouble(),
      );
      
  }
}