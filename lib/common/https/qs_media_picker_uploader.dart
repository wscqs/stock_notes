// class QsMediaPickerUploader {
//   /// 选择图片/视频
//   Future<List<AssetEntity>?> pickMedia(BuildContext context,
//       {int maxAssets = 1}) async {
//     AssetPickerConfig pickerConfig = AssetPickerConfig(maxAssets: maxAssets);
//     if (maxAssets == 1) {
//       pickerConfig = const AssetPickerConfig(
//         maxAssets: 1,
//         // specialPickerType: SpecialPickerType.noPreview,
//         requestType: RequestType.image,
//       );
//     }
//     final List<AssetEntity>? result = await AssetPicker.pickAssets(
//       context,
//       pickerConfig: pickerConfig,
//     );
//     return result;
//   }
//
//   /// 将 AssetEntity 转换成 File
//   Future<List<File>> convertAssetsToFile(List<AssetEntity> assets) async {
//     List<File> files = [];
//     for (var asset in assets) {
//       File? file = await asset.originFile;
//       if (file != null) {
//         File? compressedFile = await compressImage(file!);
//         // files.add(file);
//         if (compressedFile != null) {
//           files.add(compressedFile);
//         }
//       }
//     }
//     return files;
//   }
//
//   /// 压缩图片（支持质量和尺寸调整）
//   Future<File?> compressImage(File file,
//       {int quality = 70, int minWidth = 800, int minHeight = 800}) async {
//     final directory = await getTemporaryDirectory();
//     final targetPath =
//         '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//
//     var result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       targetPath,
//       quality: quality, // 0 - 100（越高越清晰）
//       minWidth: minWidth, // 调整压缩后最小宽度
//       minHeight: minHeight, // 调整压缩后最小高度
//     );
//
//     if (result != null) {
//       return File(result.path);
//     }
//     return null;
//   }
//
//   /// 选择并上传
//   pickAndUpload(BuildContext context, String url,
//       {int maxAssets = 1,
//       Function(List<AssetEntity>? files)? isLocalSuccess,
//       required Function(bool isSuccess) isUploadSuccess}) async {
//     // 1. 选择媒体
//     List<AssetEntity>? assets = await pickMedia(context, maxAssets: maxAssets);
//     if (isLocalSuccess != null) {
//       isLocalSuccess(assets);
//     }
//     if (assets != null && assets.isNotEmpty) {
//       // 2. 转换为文件
//       List<File> files = await convertAssetsToFile(assets);
//       // 3. 上传文件
//       // await uploadFiles(files, url);
//       // await QsRequest.uploadFiles(files, url);
//       QsRequest.uploadFiles(
//           files: files,
//           url: url,
//           decodeType: EmptyModel(),
//           showHUD: true,
//           showErrorToast: true,
//           completionHandler: (model, error) {
//             if (model != null) {
//               isUploadSuccess(true);
//             } else {
//               isUploadSuccess(false);
//             }
//           });
//     }
//   }
// }
