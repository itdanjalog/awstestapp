import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://springweb-env.eba-mkz5qjhp.ap-northeast-2.elasticbeanstalk.com/api"));

  Future<String> rest() async {
    final res = await dio.get("/rest");
    return res.data;
  }

  Future<List<dynamic>> rds(String content) async {
    final res = await dio.post("/rds?content=$content");
    return res.data;
  }

  Future<List<dynamic>> cache(String content) async {
    final res = await dio.post("/cache?content=$content");
    return res.data;
  }

  Future<String> uploadToS3(String filePath) async {
    final form = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath),
    });
    final res = await dio.post("/s3", data: form);
    return res.data;
  }
}
