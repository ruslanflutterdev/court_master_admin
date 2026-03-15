import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/groups/data/models/group_model.dart';
import 'package:court_master_admin/features/groups/data/repositories/groups_repository.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_event.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_state.dart';

class MockGroupsRepository extends Mock implements GroupsRepository {}

void main() {
  group('GroupsBloc Tests', () {
    late GroupsBloc groupsBloc;
    late MockGroupsRepository mockRepo;

    setUp(() {
      mockRepo = MockGroupsRepository();
      groupsBloc = GroupsBloc(repository: mockRepo);
    });

    tearDown(() {
      groupsBloc.close();
    });

    test('Начальное состояние — GroupsInitial', () {
      expect(groupsBloc.state, isA<GroupsInitial>());
    });

    blocTest<GroupsBloc, GroupsState>(
      'Успешная загрузка списка групп: [GroupsLoading, GroupsLoaded]',
      build: () {
        when(() => mockRepo.getGroups()).thenAnswer(
          (_) async => [
            GroupModel(id: '1', name: 'Профи', scheduleText: '', coachId: ''),
          ],
        );
        return groupsBloc;
      },
      act: (bloc) => bloc.add(LoadGroupsEvent()),
      expect: () => [isA<GroupsLoading>(), isA<GroupsLoaded>()],
    );

    blocTest<GroupsBloc, GroupsState>(
      'Ошибка загрузки с сервера: [GroupsLoading, GroupsError]',
      build: () {
        when(() => mockRepo.getGroups()).thenThrow(Exception('Ошибка сети'));
        return groupsBloc;
      },
      act: (bloc) => bloc.add(LoadGroupsEvent()),
      expect: () => [isA<GroupsLoading>(), isA<GroupsError>()],
    );
  });
}
