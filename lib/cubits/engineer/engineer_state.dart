part of 'engineer_cubit.dart';

enum EngineerLocationStatus { initial, loaded, error }

class EngineerProcess extends Equatable {
  final Position? position;
  final EngineerLocationStatus liveUserStatus;
  final bool isOnline;
  final bool showProfile;

  @override
  List<Object?> get props => [position, liveUserStatus, isOnline, showProfile];

  const EngineerProcess({
    this.position,
    this.liveUserStatus = EngineerLocationStatus.initial,
    this.isOnline = false,
    this.showProfile = false,
  });

  factory EngineerProcess.inital() {
    return const EngineerProcess(
      position: null,
      liveUserStatus: EngineerLocationStatus.initial,
      isOnline: false,
      showProfile: false,
    );
  }

  EngineerProcess copyWith({
    Position? position,
    EngineerLocationStatus? liveUserStatus,
    bool? isOnline,
    bool? showProfile,
  }) {
    return EngineerProcess(
      position: position ?? this.position,
      liveUserStatus: liveUserStatus ?? this.liveUserStatus,
      isOnline: isOnline ?? this.isOnline,
      showProfile: showProfile ?? this.showProfile,
    );
  }
}
