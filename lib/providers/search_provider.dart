import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../models/hotel.dart';
import '../services/travel_api_service.dart';

class SearchProvider extends ChangeNotifier {
  final TravelApiService _apiService = TravelApiService();

  List<Flight> _flights = [];
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _error;

  List<Flight> get flights => _flights;
  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchFlights({
    required String origin,
    required String destination,
    required String departDate,
    String? returnDate,
    int passengers = 1,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _flights = await _apiService.searchFlights(
        origin: origin,
        destination: destination,
        departDate: departDate,
        returnDate: returnDate,
        passengers: passengers,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchHotels({
    required String location,
    required String checkIn,
    required String checkOut,
    int guests = 1,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _hotels = await _apiService.searchHotels(
        location: location,
        checkIn: checkIn,
        checkOut: checkOut,
        guests: guests,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Flight>> getPopularFlights() async {
    try {
      return await _apiService.getPopularFlights();
    } catch (e) {
      return [];
    }
  }

  void clearResults() {
    _flights = [];
    _hotels = [];
    _error = null;
    notifyListeners();
  }
}
