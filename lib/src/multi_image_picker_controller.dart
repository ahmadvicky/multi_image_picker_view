import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../multi_image_picker_view.dart';

/// Controller for the [MultiImagePickerView].
/// This controller contains all them images that the user has selected.
class MultiImagePickerController with ChangeNotifier {
  final List<String> allowedImageTypes;
  final int maxImages;

  MultiImagePickerController({
    this.allowedImageTypes = const ['png', 'jpeg', 'jpg'],
    this.maxImages = 10,
  }) {
    print('init');
  }

  final List<ImageFile> _images = <ImageFile>[];

  /// Returns [Iterable] of [ImageFile] that user has selected.
  Iterable<ImageFile> get images => _images;

  /// Returns true if user has selected no images.
  bool get hasNoImages => _images.isEmpty;

  /// manually pick images. i.e. on click on external button.
  /// this method open Image picking window.
  /// It returns [Future] of [bool], true if user has selected images.
  ///
  // VideoPlayerController videoPlayerController;
  // int _videoDuration = 0;
  // int _numberOfThumbnails = 5;

  Future<bool> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: allowedImageTypes);
    if (result != null && result.files.isNotEmpty) {

      // if (allowedImageTypes[0] == "mp4"){
      //   result.files.e
      //   final String _videoPath = video.path;
      //
      //   double _eachPart = _videoDuration / _numberOfThumbnails;
      //
      //   List<Uint8List> _byteList = [];
      //   // the cache of last thumbnail
      //   Uint8List _lastBytes;
      //
      //   for (int i = 1; i <= _numberOfThumbnails; i++) {
      //     Uint8List? _bytes;
      //     _bytes = await VideoThumbnail.thumbnailData(
      //       video: _videoPath,
      //       imageFormat: ImageFormat.JPEG,
      //       timeMs: (_eachPart * i).toInt(),
      //       quality: 75,
      //     );
      //
      //     // if current thumbnail is null use the last thumbnail
      //     if (_bytes != null) {
      //       _lastBytes = _bytes;
      //       _byteList.add(_bytes);
      //     } else {
      //       // _bytes = _lastBytes;
      //       // _byteList.add(_bytes);
      //     }
      //   }
      // }


      _addImages(result.files
          .where((e) =>
              e.extension != null &&
              allowedImageTypes.contains(e.extension?.toLowerCase()))
          .map((e) => ImageFile(
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null, pathThumbnail: '')));
      notifyListeners();
      return true;
    }
    return false;
  }

  void _addImages(Iterable<ImageFile> images) {
    int i = 0;
    while (_images.length < maxImages && images.length > i) {
      _images.add(images.elementAt(i));
      i++;
    }
  }

  /// Manually re-order image, i.e. move image from one position to another position.
  void reOrderImage(int oldIndex, int newIndex, {bool notify = true}) {
    final oldItem = _images.removeAt(oldIndex);
    oldItem.size;
    _images.insert(newIndex, oldItem);
    if (notify) {
      notifyListeners();
    }
  }

  /// Manually remove image from list.
  void removeImage(ImageFile imageFile) {
    _images.remove(imageFile);
    notifyListeners();
  }

  @override
  void dispose() {
    print(_images);
    print('dispose');
    super.dispose();
    print(_images);
  }
}
