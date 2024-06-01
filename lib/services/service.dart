import 'dart:convert';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/models/country_model.dart';
import 'package:nubida_front/models/plan_model.dart';
import 'package:nubida_front/models/recommend_country_model.dart';
import 'package:nubida_front/models/review_model.dart';
import 'package:nubida_front/models/supply_model.dart';
import 'package:nubida_front/models/travel_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/models/traveler_model.dart';

class Service {
  static String baseUrl = serverUrl;

  Future<String> getCurrentUserToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    if (token != null) {
      return token;
    } else {
      return '';
    }
  }

  Future<String> getCurrentUserRole() async {
    const storage = FlutterSecureStorage();
    String? role = await storage.read(key: 'role');

    if (role != null) {
      return role;
    } else {
      return '';
    }
  }

  Future<List<TravelModel>> getAllTravel() async {
    List<TravelModel> travelInstances = [];

    Uri url;

    url = Uri.parse('$baseUrl/travel/allTravel');

    // print(url);
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> travels = jsonDecode(utf8.decode(response.bodyBytes));
      print(travels);
      for (var travel in travels) {
        travelInstances.add(TravelModel.fromJson(travel));
      }
      travelInstances.sort((a, b) => a.startdate.compareTo(b.startdate));
      return travelInstances;
    }
    throw Error();
  }

  Future<List<TravelModel>> getTravel() async {
    List<TravelModel> travelInstances = [];
    DateTime now = DateTime.now();

    List<TravelModel> travels = await getAllTravel();
    for (var travel in travels) {
      if (DateTime.parse(travel.returndate).isBefore(now)) {
        continue;
      }
      travelInstances.add(travel);
    }
    return travelInstances;
  }

  Future<TravelModel?> getNextTravel() async {
    List<TravelModel> travelInstances = await getTravel();

    if (travelInstances.isNotEmpty) {
      return travelInstances[0];
    }
    return null;
  }

  Future<List<PlanModel>> getPlan(int travelId) async {
    List<PlanModel> planInstances = [];

    Uri url = Uri.parse('$baseUrl/plan/getPlans?id=$travelId');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> plans = jsonDecode(utf8.decode(response.bodyBytes));

      for (var plan in plans) {
        planInstances.add(PlanModel.fromJson(plan));
      }
      planInstances.sort((a, b) => a.start_date.compareTo(b.start_date));
      return planInstances;
    }
    throw Error();
  }

  Future<List<ReviewModel>> getAllReview() async {
    List<ReviewModel> reviewInstances = [];

    Uri url = Uri.parse('$baseUrl/review/getAll');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> reviews = jsonDecode(utf8.decode(response.bodyBytes));
      print(reviews);
      for (var review in reviews) {
        reviewInstances.add(ReviewModel.fromJson(review));
      }
      print(reviewInstances);
      return reviewInstances;
    }
    throw Error();
  }

  Future<BigInt> getTravelerId() async {
    BigInt id;

    Uri url;

    url = Uri.parse('$baseUrl/traveler/getId');

    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      id = BigInt.from(jsonDecode(utf8.decode(response.bodyBytes)));
      print(id);
      return id;
    }
    throw Error();
  }

  Future<List<TravelModel>> getAdminTravel() async {
    List<TravelModel> travelInstances = [];

    Uri url;
    url = Uri.parse('$baseUrl/travel/adminTravel');
    // print(url);
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> travels = jsonDecode(utf8.decode(response.bodyBytes));
      for (var travel in travels) {
        travelInstances.add(TravelModel.fromJson(travel));
      }
      return travelInstances;
    }
    throw Error();
  }

  Future<Map<String, dynamic>> getReview(int travelId) async {
    Uri url;
    url = Uri.parse('$baseUrl/travel/viewReview?id=$travelId');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final review = jsonDecode(utf8.decode(response.bodyBytes));
      print(review);
      return review;
    }
    throw Error();
  }

  Future<List<TravelerModel>> getAllTraveler() async {
    List<TravelerModel> travelerInstances = [];

    Uri url;
    url = Uri.parse('$baseUrl/traveler/getAllTraveler');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> travelers =
          jsonDecode(utf8.decode(response.bodyBytes));
      // print(travelers);
      for (var traveler in travelers) {
        travelerInstances.add(TravelerModel.fromJson(traveler));
        print(traveler);
      }
      return travelerInstances;
    }
    throw Error();
  }

  Future<List<RecommendCountryModel>> getRecommendCountry() async {
    List<RecommendCountryModel> countryInstances = [];

    Uri url;
    url = Uri.parse('$baseUrl/country/getRecommend');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> countries =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(countries);
      for (var country in countries) {
        try {
          var countryInstance = RecommendCountryModel.fromJson(country);
          countryInstances.add(countryInstance);
          print('Parsed country: $countryInstance');
        } catch (e) {
          print('Error parsing country: $country');
          print(e);
        }
      }
      return countryInstances;
    }
    print(countryInstances);
    throw Error();
  }

  Future<List<SupplyModel>> getSupplies(int id) async {
    List<SupplyModel> supplyInstances = [];

    Uri url;
    url = Uri.parse('$baseUrl/travel/supply/getAll?id=$id');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> supplies =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(supplies);
      for (var supply in supplies) {
        supplyInstances.add(SupplyModel.fromJson(supply));
        print(supply);
      }
      return supplyInstances;
    }
    throw Error();
  }

  Future<List<CountryModel>> getAllCountry() async {
    List<CountryModel> countryInstances = [];

    Uri url;
    url = Uri.parse('$baseUrl/country/allCountry');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List<dynamic> countries =
          jsonDecode(utf8.decode(response.bodyBytes));
      for (var country in countries) {
        countryInstances.add(CountryModel.fromJson(country));
      }
      return countryInstances;
    }
    throw Error();
  }

  Future<List<Map<String, dynamic>>> getTransportation() async {
    List<Map<String, dynamic>> transportInstances = [];

    Uri url = Uri.parse('$baseUrl/transportation/getAll');
    final token = await getCurrentUserToken();
    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      try {
        final List<dynamic> transports =
            jsonDecode(utf8.decode(response.bodyBytes));
        for (var transport in transports) {
          if (transport is Map<String, dynamic>) {
            transportInstances.add(transport);
          }
        }
        return transportInstances;
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future<String> getCountry(int id) async {
    Uri url;
    url = Uri.parse('$baseUrl/country/getCountry?id=$id');
    final token = await getCurrentUserToken();

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(utf8.decode(response.bodyBytes));
        return result['name'];
      } else {
        throw Exception();
      }
    }
    throw Exception();
  }

  Future<Map<String, dynamic>> getTravelInfo(int id) async {
    Uri url;
    url = Uri.parse('${Service.baseUrl}/travel/allInfo?id=$id');
    final token = await getCurrentUserToken();

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(utf8.decode(response.bodyBytes));
        return result;
      } else {
        throw Exception();
      }
    }
    throw Exception();
  }

  Future<List<Map<String, dynamic>>> getTravelTravelerInfo(int id) async {
    Uri url;
    url = Uri.parse('${Service.baseUrl}/travel/traveler?id=$id');
    final token = await getCurrentUserToken();

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        List<Map<String, dynamic>> result =
            jsonList.map((item) => item as Map<String, dynamic>).toList();

        return result;
      } else {
        throw Exception();
      }
    }
    throw Exception();
  }

  Future<List<String>> getCountryNames() async {
    List<CountryModel> countries = await getAllCountry();
    List<String> countryNames =
        countries.map((country) => country.name).toList();
    return countryNames;
  }

  Future<Map<String, dynamic>> getCurrency(String currencyCode) async {
    Uri url = Uri.parse(
        'https://quotation-api-cdn.dunamu.com/v1/forex/recent?codes=FRX.KRW$currencyCode');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      return result[0];
    }
    throw Exception();
  }

  // Future<List<dynamic>> getBudgetInfo(int travel_id) async {
  //   Uri url = Uri.parse('$baseUrl/plan/viewBudgetInfo?travel_id=$travel_id');
  //   final token = await getCurrentUserToken();

  //   final response = await http.get(url, headers: {'Authorization': token});
  //   if (response.statusCode == 200) {
  //     final List<dynamic> plans = jsonDecode(utf8.decode(response.bodyBytes));

  //     for (var plan in plans) {
  //       planInstances.add(PlanModel.fromJson(plan));
  //     }
  //     planInstances.sort((a, b) => a.start_date.compareTo(b.start_date));
  //     return planInstances;
  //   }
  //   throw Error();
  // }
}
