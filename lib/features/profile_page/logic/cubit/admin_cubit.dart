import 'package:bloc/bloc.dart';
import 'package:english_app/core/networking/api_result.dart';
import 'package:english_app/features/profile_page/data/repos/admin_repo.dart';
import 'package:english_app/features/profile_page/logic/cubit/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;

  AdminCubit(this.adminRepo) : super(const AdminState.initial());

  void emitGetAdminData() async {
    emit(const AdminState.loading());
    final response = await adminRepo.getAdminData();
    response.when(
      success: (admins) {
        emit(AdminState.success(admins));
      },
      failure: (error) {
        emit(
          AdminState.error(
            error: error.apiErrorModel.message ?? 'Unknown error',
          ),
        );
      },
    );
  }
}
