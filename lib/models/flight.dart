class Flight {
  final String origin;
  final String destination;
  final String originCity;
  final String destinationCity;
  final String airline;
  final double price;
  final String currency;
  final String departureAt;
  final String? returnAt;
  final int transfers;
  final String flightNumber;
  final String link;

  Flight({
    required this.origin,
    required this.destination,
    required this.originCity,
    required this.destinationCity,
    required this.airline,
    required this.price,
    required this.currency,
    required this.departureAt,
    this.returnAt,
    required this.transfers,
    required this.flightNumber,
    required this.link,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      originCity: json['origin_city'] as String? ?? '',
      destinationCity: json['destination_city'] as String? ?? '',
      airline: json['airline'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'RUB',
      departureAt: json['departure_at'] as String? ?? '',
      returnAt: json['return_at'] as String?,
      transfers: json['transfers'] as int? ?? 0,
      flightNumber: json['flight_number'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }
}
