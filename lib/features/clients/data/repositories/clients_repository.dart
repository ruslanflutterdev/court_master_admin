import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/client_model.dart';

class ClientsRepository {
  final ApiClient apiClient;

  ClientsRepository(this.apiClient);

  Future<List<ClientModel>> getClients() async {
    try {
      final response = await apiClient.dio.get('/clients');
      return (response.data as List)
          .map((json) => ClientModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка загрузки клиентов',
      );
    }
  }

  Future<ClientModel> getClientDetails(String clientId) async {
    try {
      final response = await apiClient.dio.get('/clients/$clientId');
      return ClientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка загрузки профиля');
    }
  }

  Future<void> addPayment(
    String clientId,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      await apiClient.dio.post(
        '/clients/$clientId/payments',
        data: paymentData,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при проведении платежа',
      );
    }
  }

  Future<void> addSubscription(
    String clientId,
    Map<String, dynamic> subData,
  ) async {
    try {
      await apiClient.dio.post(
        '/clients/$clientId/subscriptions',
        data: subData,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при добавлении абонемента',
      );
    }
  }

  Future<void> quickSale(Map<String, dynamic> saleData) async {
    try {
      await apiClient.dio.post('/clients/quick-sale', data: saleData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при быстрой продаже',
      );
    }
  }

  Future<void> refundTransaction(String transactionId) async {
    try {
      await apiClient.dio.post(
        '/transactions/refund',
        data: {'transactionId': transactionId},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при выполнении возврата',
      );
    }
  }

  Future<Map<String, dynamic>> getDebtors() async {
    try {
      final response = await apiClient.dio.get('/analytics/debts');
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка загрузки списка должников',
      );
    }
  }
}
