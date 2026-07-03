import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';
import '../models/hotel.dart';
import '../utils/constants.dart';

class TravelApiService {
  final String _baseUrl = AppConstants.baseUrl;

  Future<List<Flight>> searchFlights({
    required String origin,
    required String destination,
    required String departDate,
    String? returnDate,
    int passengers = 1,
  }) async {
    final params = <String, String>{
      'origin': origin,
      'destination': destination,
      'depart_date': departDate,
      'passengers': passengers.toString(),
    };
    if (returnDate != null) {
      params['return_date'] = returnDate;
    }

    final uri =
        Uri.parse('$_baseUrl/api/v1/flights/search').replace(queryParameters: params);
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Flight.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search flights: ${response.statusCode}');
    }
  }

  Future<List<Hotel>> searchHotels({
    required String location,
    required String checkIn,
    required String checkOut,
    int guests = 1,
  }) async {
    final params = {
      'location': location,
      'check_in': checkIn,
      'check_out': checkOut,
      'guests': guests.toString(),
    };

    final uri =
        Uri.parse('$_baseUrl/api/v1/hotels/search').replace(queryParameters: params);
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Hotel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search hotels: ${response.statusCode}');
    }
  }

  Future<List<Flight>> getPopularFlights() async {
    final uri = Uri.parse('$_baseUrl/api/v1/flights/popular');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Flight.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
