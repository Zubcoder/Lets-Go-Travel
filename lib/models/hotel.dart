class Hotel {
  final String name;
  final String location;
  final double priceFrom;
  final String currency;
  final double rating;
  final int stars;
  final String photoUrl;
  final String link;

  Hotel({
    required this.name,
    required this.location,
    required this.priceFrom,
    required this.currency,
    required this.rating,
    required this.stars,
    required this.photoUrl,
    required this.link,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      priceFrom: (json['price_from'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'RUB',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stars: json['stars'] as int? ?? 0,
      photoUrl: json['photo_url'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }
}
