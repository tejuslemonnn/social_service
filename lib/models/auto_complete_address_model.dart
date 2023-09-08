class AutoCompleteAddress {
  List<AutoCompleteAddressResult>? results;

  AutoCompleteAddress({
    this.results,
  });

  factory AutoCompleteAddress.fromJson(Map<String, dynamic> json) =>
      AutoCompleteAddress(
        results: List<AutoCompleteAddressResult>.from(
            json["results"].map((x) => AutoCompleteAddressResult.fromJson(x))),
      );
}

class AutoCompleteAddressResult {
  Datasource? datasource;
  String? name;
  String? country;
  String? countryCode;
  String? region;
  String? state;
  String? city;
  String? village;
  String? postcode;
  String? district;
  String? neighbourhood;
  String? street;
  double? lon;
  double? lat;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  String? plusCode;
  String? plusCodeShort;
  String? resultType;
  String? placeId;

  AutoCompleteAddressResult({
    this.datasource,
    this.name,
    this.country,
    this.countryCode,
    this.region,
    this.state,
    this.city,
    this.village,
    this.postcode,
    this.district,
    this.neighbourhood,
    this.street,
    this.lon,
    this.lat,
    this.formatted,
    this.addressLine1,
    this.addressLine2,
    this.plusCode,
    this.plusCodeShort,
    this.resultType,
    this.placeId,
  });

  factory AutoCompleteAddressResult.fromJson(Map<String, dynamic> json) =>
      AutoCompleteAddressResult(
        datasource: Datasource.fromJson(json["datasource"]),
        name: json["name"],
        country: json["country"],
        countryCode: json["country_code"],
        region: json["region"],
        state: json["state"],
        city: json["city"],
        village: json["village"],
        postcode: json["postcode"],
        district: json["district"],
        neighbourhood: json["neighbourhood"],
        street: json["street"],
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
        formatted: json["formatted"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        plusCode: json["plus_code"],
        plusCodeShort: json["plus_code_short"],
        resultType: json["result_type"],
        placeId: json["place_id"],
      );
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Datasource({
    this.sourcename,
    this.attribution,
    this.license,
    this.url,
  });

  factory Datasource.fromJson(Map<String, dynamic> json) => Datasource(
        sourcename: json["sourcename"],
        attribution: json["attribution"],
        license: json["license"],
        url: json["url"],
      );
}
