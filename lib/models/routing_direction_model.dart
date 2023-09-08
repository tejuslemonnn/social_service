import 'package:equatable/equatable.dart';

class RoutingDirection extends Equatable {
  List<Feature>? features;
  RoutingDirectionProperties? properties;
  String? type;

  RoutingDirection({
    this.features,
    this.properties,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        "features": List<dynamic>.from(features!.map((x) => x.toJson())),
        "properties": properties!.toJson(),
        "type": type,
      };

  factory RoutingDirection.fromJson(Map<String, dynamic> json) =>
      RoutingDirection(
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        properties: RoutingDirectionProperties.fromJson(json["properties"]),
        type: json["type"],
      );

  @override
  List<Object?> get props => [features, properties, type];
}

class Feature extends Equatable {
  String? type;
  FeatureProperties? properties;
  Geometry? geometry;

  Feature({
    this.type,
    this.properties,
    this.geometry,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties!.toJson(),
        "geometry": geometry!.toJson(),
      };

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        properties: FeatureProperties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  @override
  List<Object?> get props => [type, properties, geometry];
}

class Geometry extends Equatable {
  String? type;
  List<List<List<double>>>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates!.map((x) =>
            List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<List<List<double>>>.from(json["coordinates"].map(
            (x) => List<List<double>>.from(
                x.map((x) => List<double>.from(x.map((x) => x.toDouble())))))),
      );

  @override
  List<Object?> get props => [type, coordinates];
}

class FeatureProperties extends Equatable {
  String? mode;
  List<PurpleWaypoint>? waypoints;
  String? units;
  int? distance;
  String? distanceUnits;
  double? time;

  FeatureProperties({
    this.mode,
    this.waypoints,
    this.units,
    this.distance,
    this.distanceUnits,
    this.time,
  });

  Map<String, dynamic> toJson() => {
        "mode": mode,
        "waypoints": List<dynamic>.from(waypoints!.map((x) => x.toJson())),
        "units": units,
        "distance": distance,
        "distance_units": distanceUnits,
        "time": time,
      };

  factory FeatureProperties.fromJson(Map<String, dynamic> json) =>
      FeatureProperties(
        mode: json["mode"],
        waypoints: List<PurpleWaypoint>.from(
            json["waypoints"].map((x) => PurpleWaypoint.fromJson(x))),
        units: json["units"],
        distance: json["distance"],
        distanceUnits: json["distance_units"],
        time: json["time"],
      );

  @override
  List<Object?> get props =>
      [mode, waypoints, units, distance, distanceUnits, time];
}

class PurpleWaypoint extends Equatable {
  List<double>? location;
  int? originalIndex;

  PurpleWaypoint({
    this.location,
    this.originalIndex,
  });

  Map<String, dynamic> toJson() => {
        "location": List<dynamic>.from(location!.map((x) => x)),
        "originalIndex": originalIndex,
      };

  factory PurpleWaypoint.fromJson(Map<String, dynamic> json) => PurpleWaypoint(
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        originalIndex: json["originalIndex"],
      );

  @override
  List<Object?> get props => [location, originalIndex];
}

class RoutingDirectionProperties extends Equatable {
  String? mode;
  List<FluffyWaypoint>? waypoints;
  String? units;

  RoutingDirectionProperties({
    this.mode,
    this.waypoints,
    this.units,
  });

  Map<String, dynamic> toJson() => {
        "mode": mode,
        "waypoints": List<dynamic>.from(waypoints!.map((x) => x.toJson())),
        "units": units,
      };

  factory RoutingDirectionProperties.fromJson(Map<String, dynamic> json) =>
      RoutingDirectionProperties(
        mode: json["mode"],
        waypoints: List<FluffyWaypoint>.from(
            json["waypoints"].map((x) => FluffyWaypoint.fromJson(x))),
        units: json["units"],
      );

  @override
  List<Object?> get props => [mode, waypoints, units];
}

class FluffyWaypoint extends Equatable {
  double? lat;
  double? lon;

  FluffyWaypoint({
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };

  factory FluffyWaypoint.fromJson(Map<String, dynamic> json) => FluffyWaypoint(
        lat: json["lat"] is int ? (json["lat"] as int).toDouble() : json["lat"],
        lon: json["lon"] is int ? (json["lon"] as int).toDouble() : json["lon"],
      );

  @override
  List<Object?> get props => [lat, lon];
}
