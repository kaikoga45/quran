import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quran/core/data/method_channels/audio_player_services_method_channel.dart';

import '../../../mocks/mocks_data_test.mocks.dart';

void main() {
  const String noInternetErrorCode = 'NO_INTERNET_CONNECTION';
  const String noInternetErrorMessage = 'No internet connection';
  const String undefinedErrorCode = 'UNDEFINED_ERROR';

  late MethodChannel methodChannel;
  late AudioPlayerServicesMethodChannel audioPlayerService;

  setUp(() {
    methodChannel = MockMethodChannel();
    audioPlayerService = AudioPlayerServicesMethodChannel(methodChannel);
  });

  test('Play_CalledSuccessfully_ReturnsVoid', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.play.name))
        .thenAnswer((_) async => null);

    await audioPlayerService.play();

    verify(
      methodChannel.invokeMethod(AudioPlayerServicesAction.play.name),
    ).called(1);
  });

  test('Play_NoInternetConnection_ThrowsPlatformException', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.play.name))
        .thenThrow(
      PlatformException(
        code: noInternetErrorCode,
        message: noInternetErrorMessage,
      ),
    );

    expect(
      () => audioPlayerService.play(),
      throwsA(
        predicate((e) {
          return e is PlatformException &&
              e.code == noInternetErrorCode &&
              e.message == noInternetErrorMessage;
        }),
      ),
    );
  });

  test('Pause_CalledSuccessfully_ReturnsVoid', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.pause.name))
        .thenAnswer((_) async => null);

    await audioPlayerService.pause();

    verify(
      methodChannel.invokeMethod(AudioPlayerServicesAction.pause.name),
    ).called(1);
  });

  test('Pause_UndefinedError_ThrowsPlatformException', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.pause.name))
        .thenThrow(
      PlatformException(
        code: undefinedErrorCode,
      ),
    );

    expect(
      () => audioPlayerService.pause(),
      throwsA(
        predicate((e) {
          return e is PlatformException && e.code == undefinedErrorCode;
        }),
      ),
    );
  });

  test('SeekTo_CalledSuccesfuly_ReturnsNewPosition', () async {
    const double newPosition = 10.0;

    const Map<String, dynamic> payload = {'position': newPosition};
    when(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.seekTo.name,
        payload,
      ),
    ).thenAnswer((_) async => null);

    await audioPlayerService.seek(newPosition.toInt());

    verify(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.seekTo.name,
        payload,
      ),
    ).called(1);
  });

  test('SeekTo_InvalidPosition_ThrowsPlatformException', () async {
    const double invalidNewPosition = 10.0;

    const Map<String, dynamic> payload = {'position': invalidNewPosition};

    const String invalidPositionErrorCode = 'INVALID_POSITION';
    const String invalidPositionErrorMessage = 'Invalid seek position';

    when(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.seekTo.name,
        payload,
      ),
    ).thenThrow(
      PlatformException(
        code: invalidPositionErrorCode,
        message: invalidPositionErrorMessage,
      ),
    );

    expect(
      () => audioPlayerService.seek(invalidNewPosition.toInt()),
      throwsA(
        predicate((e) {
          return e is PlatformException &&
              e.code == invalidPositionErrorCode &&
              e.message == invalidPositionErrorMessage;
        }),
      ),
    );
  });

  test('Stop_CalledSuccessfully_ReturnsVoid', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.stop.name))
        .thenAnswer((_) async => null);

    await audioPlayerService.stop();

    verify(
      methodChannel.invokeMethod(AudioPlayerServicesAction.stop.name),
    ).called(1);
  });

  test('Stop_NoInternetConnection_ThrowsPlatformException', () async {
    when(methodChannel.invokeMethod(AudioPlayerServicesAction.stop.name))
        .thenThrow(
      PlatformException(
        code: noInternetErrorCode,
        message: noInternetErrorMessage,
      ),
    );

    expect(
      () => audioPlayerService.stop(),
      throwsA(
        predicate((e) {
          return e is PlatformException &&
              e.code == noInternetErrorCode &&
              e.message == noInternetErrorMessage;
        }),
      ),
    );
  });

  test('GetDuration_CalledSuccesfuly_ReturnsTotalDuration', () async {
    when(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.getDuration.name,
      ),
    ).thenAnswer((_) async => null);

    await audioPlayerService.getDuration();

    verify(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.getDuration.name,
      ),
    ).called(1);
  });

  test('GetDuration_InvalidPosition_ThrowsPlatformException', () async {
    when(
      methodChannel.invokeMethod(
        AudioPlayerServicesAction.getDuration.name,
      ),
    ).thenThrow(
      PlatformException(
        code: undefinedErrorCode,
      ),
    );

    expect(
      () => audioPlayerService.getDuration(),
      throwsA(
        predicate((e) {
          return e is PlatformException && e.code == undefinedErrorCode;
        }),
      ),
    );
  });

  test('GetCurrentPosition_CalledSuccessfully_ReturnsPositionNumber', () async {
    const double position = 10.0;
    when(
      methodChannel
          .invokeMethod(AudioPlayerServicesAction.getCurrentPosition.name),
    ).thenAnswer((_) async => position);

    final double positionResult = await audioPlayerService.getCurrentPosition();

    expect(positionResult, position);
  });

  test('GetCurrentPosition_UndefinedError_ThrowsPlatformException', () async {
    when(
      methodChannel
          .invokeMethod(AudioPlayerServicesAction.getCurrentPosition.name),
    ).thenThrow(
      PlatformException(
        code: undefinedErrorCode,
      ),
    );

    expect(
      () => audioPlayerService.getCurrentPosition(),
      throwsA(
        predicate((e) {
          return e is PlatformException && e.code == undefinedErrorCode;
        }),
      ),
    );
  });
}
