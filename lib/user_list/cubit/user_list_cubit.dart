import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user_list_cubit/user_list/model/user.dart';

part "user_list_state.dart";

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(const UserListState.initial());

  // Fetch users from the API
  fetchUser() async {
    try {
      emit(const UserListState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<User> users = res.data.map<User>((d) {
          return User.fromJson(d);
        }).toList();

        emit(UserListState.success(users));
      } else {
        emit(UserListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(UserListState.error("Error loading data: ${e.toString()}"));
    }
  }

  // Fungsi untuk menghapus user berdasarkan long press
  void removeData(User user) {
    if (state is UserListSuccess) {
      final currentState = state as UserListSuccess;
      final updatedUsers = List<User>.from(currentState.users)..remove(user);

      // Emit state baru dengan daftar pengguna yang sudah diperbarui
      emit(UserListState.success(updatedUsers));
    }
  }
}
