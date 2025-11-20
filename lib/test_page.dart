import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final api = ApiService();

  String restResult = "";
  List<dynamic> rdsResult = [];
  List<dynamic> cacheResult = [];
  String s3Result = "";
  String? s3ImageUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20,100,20,20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 1. REST
          ElevatedButton(
            onPressed: () async {
              restResult = await api.rest();
              setState(() {});
            },
            child: const Text("1. REST 호출"),
          ),
          if (restResult.isNotEmpty) Text("결과: $restResult"),

          const Divider(),

          // 2. RDS
          ElevatedButton(
            onPressed: () async {
              final content = await _inputDialog("RDS Content?");
              if (content == null) return;

              rdsResult = await api.rds(content);
              setState(() {});
            },
            child: const Text("2. RDS 호출"),
          ),
          if (rdsResult.isNotEmpty)
            Text("결과:\n${rdsResult.toString()}"),

          const Divider(),

          // 3. Redis 캐싱
          ElevatedButton(
            onPressed: () async {
              final content = await _inputDialog("캐싱 Content?");
              if (content == null) return;

              cacheResult = await api.cache(content);
              setState(() {});
            },
            child: const Text("3. Redis 캐싱"),
          ),
          if (cacheResult.isNotEmpty)
            Text("결과:\n${cacheResult.toString()}"),

          const Divider(),

          // 4. S3 업로드
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked == null) return;

              s3Result = await api.uploadToS3(picked.path);

              if (s3Result.startsWith("http")) {
                s3ImageUrl = s3Result;
              }

              setState(() {});
            },
            child: const Text("4. S3 업로드"),
          ),

          if (s3Result.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("업로드 결과: $s3Result"),
                if (s3ImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.network(s3ImageUrl!, width: 200),
                  )
              ],
            ),

        ],
      ),
    );
  }

  Future<String?> _inputDialog(String title) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }
}
