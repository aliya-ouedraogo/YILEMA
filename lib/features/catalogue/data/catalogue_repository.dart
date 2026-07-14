import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'content_model.dart';

class CatalogueRepository {
  final _client = ApiClient();

  Future<List<ContentModel>> getContents() async {
    final response = await _client.dio.get(ApiConstants.contents);
    final List results = response.data['results'] ?? response.data;
    return results.map((json) => ContentModel.fromJson(json)).toList();
  }

  Future<ContentModel> getContentDetail(int id) async {
    final response = await _client.dio.get(ApiConstants.contentDetail(id));
    return ContentModel.fromJson(response.data);
  }
}
