import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pucardpg/app/bloc/registration_login_bloc/registration_login_event.dart';
import 'package:pucardpg/app/bloc/registration_login_bloc/registration_login_state.dart';
import 'package:pucardpg/app/data/models/individual-search/individual_search_model.dart';
import 'package:pucardpg/app/data/models/logout-model/logout_model.dart';
import 'package:pucardpg/app/data/models/otp-models/otp_model.dart';
import 'package:pucardpg/app/domain/usecase/login_usecase.dart';
import 'package:pucardpg/core/constant/constants.dart';
import 'package:pucardpg/core/resources/data_state.dart';

class RegistrationLoginBloc extends Bloc<RegistrationLoginEvent, RegistrationLoginState> {

  final LoginUseCase _loginUseCase;

  RegistrationLoginBloc(this._loginUseCase): super(InitialState()) {
    on<InitialEvent>(initialEvent);
    on<RequestOtpEvent>(requestOtpEvent);
    on<ResendOtpEvent>(resendOtpEvent);
    on<SubmitRegistrationOtpEvent>(sendRegistrationOtpEvent);
    on<SendLoginOtpEvent>(sendLoginOtpEvent);
    on<SubmitIndividualProfileEvent>(submitIndividualProfile);
    on<SubmitAdvocateProfileEvent>(submitAdvocateProfile);
    on<SubmitAdvocateClerkProfileEvent>(submitAdvocateClerkProfile);
    // on<SubmitAdvocateIndividualEvent>(submitAdvocateIndividual);
    // on<SubmitAdvocateClerkIndividualEvent>(submitAdvocateClerkIndividual);
  }

  Future<void> initialEvent(InitialEvent event,
      Emitter<RegistrationLoginState> emit) async {

  }

  Future<void> requestOtpEvent(RequestOtpEvent event,
      Emitter<RegistrationLoginState> emit) async {

      emit(LoadingState());
      dynamic dataState;

      if (event.type == 'login') {
        dataState = await _loginUseCase.requestOtp(event.mobileNumber, event.type);
      } else if (event.type == 'register') {
        dataState = await _loginUseCase.requestOtp(event.mobileNumber, event.type);
      }

      if(dataState is DataSuccess){
        emit(OtpGenerationSuccessState(type: event.type));
      }
      if(dataState is DataFailed){
        emit(RequestOtpFailedState(errorMsg: dataState.error?.message ?? "",));
      }

  }

  Future<void> resendOtpEvent(ResendOtpEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.requestOtp(event.mobileNumber, event.type);

    if(dataState is DataSuccess){
      emit(ResendOtpGenerationSuccessState(type: event.type));
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: dataState.error?.message ?? "",));
    }

  }

  Future<void> sendRegistrationOtpEvent(SubmitRegistrationOtpEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.createCitizen(event.username, event.otp, event.userModel);

    if(dataState is DataSuccess){
      emit(OtpCorrectState(authResponse: dataState.data!));
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: dataState.error?.message ?? "",));
    }

  }

  // Future<void> logoutUserEvent(SubmitLogoutUserEvent event,
  //     Emitter<RegistrationLoginState> emit) async {
  //
  //   emit(LoadingState());
  //
  //   final dataState = await _loginUseCase.logoutUser(event.authToken);
  //
  //   if(dataState is DataSuccess){
  //       emit(LogoutSuccessState(data: dataState.data!));
  //   }
  //   if(dataState is DataFailed){
  //     emit(LogoutFailedState(data: dataState.data!));
  //   }
  // }

  Future<void> sendLoginOtpEvent(SendLoginOtpEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.getAuthResponse(event.username, event.password, event.userModel);

    if(dataState is DataSuccess){
      final dataStateSearchIndividual = await _loginUseCase.searchIndividual(event.userModel);
      if (dataStateSearchIndividual is DataSuccess) {
        if (dataStateSearchIndividual.data!.individual.isEmpty) {
          emit(IndividualSearchSuccessState(individualSearchResponse: dataStateSearchIndividual.data!));
        } else {
          if (event.userModel.userType == 'LITIGANT') {
            emit(IndividualSearchSuccessState(individualSearchResponse: dataStateSearchIndividual.data!));
          }
          if (event.userModel.userType == 'ADVOCATE') {
            final dataStateSearchAdvocate = await _loginUseCase.searchAdvocate(event.userModel);
            if(dataState is DataSuccess){
              emit(AdvocateSearchSuccessState(advocateSearchResponse: dataStateSearchAdvocate.data!));
            }
            if(dataState is DataFailed){
              emit(RequestFailedState(errorMsg: "",));
            }
          }
          if (event.userModel.userType == 'ADVOCATE_CLERK') {
            final dataStateSearchAdvocateClerk = await _loginUseCase.searchAdvocateClerk(event.userModel);
            if(dataState is DataSuccess){
              emit(AdvocateClerkSearchSuccessState(advocateClerkSearchResponse: dataStateSearchAdvocateClerk.data!));
            }
            if(dataState is DataFailed){
              emit(RequestFailedState(errorMsg: "",));
            }
          }
        }
      }
      if(dataStateSearchIndividual is DataFailed){
        emit(RequestFailedState(errorMsg: dataState.error?.message ?? "",));
      }
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: dataState.error?.message ?? "",));
    }

  }

  Future<void> submitIndividualProfile(SubmitIndividualProfileEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.registerLitigant(event.userModel);

    if(dataState is DataSuccess){
      if (event.userModel.userType == 'ADVOCATE') {
        final dataState1 = await _loginUseCase.registerAdvocate(event.userModel);
        if(dataState1 is DataSuccess){
          emit(AdvocateSubmissionSuccessState());
        }
        if(dataState1 is DataFailed){
          emit(RequestFailedState(errorMsg: "",));
        }
      } else if (event.userModel.userType == 'ADVOCATE_CLERK') {
        final dataState2 = await _loginUseCase.registerAdvocateClerk(event.userModel);

        if(dataState2 is DataSuccess){
          emit(AdvocateSubmissionSuccessState());
        }
        if(dataState2 is DataFailed){
          emit(RequestFailedState(errorMsg: "",));
        }
      } else {
        emit(LitigantSubmissionSuccessState(litigantResponseModel: dataState.data!));
      }
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: "",));
    }

  }

  // Future<void> submitAdvocateIndividual(SubmitAdvocateIndividualEvent event,
  //     Emitter<RegistrationLoginState> emit) async {
  //
  //   emit(LoadingState());
  //
  //   final dataState = await _loginUseCase.registerLitigant(event.userModel, advocate);
  //
  //   if(dataState is DataSuccess){
  //     final dataState1 = await _loginUseCase.logoutUser(event.userModel.authToken ?? "");
  //
  //     if(dataState1 is DataSuccess){
  //       emit(LogoutSuccessState(data: dataState1.data!));
  //     }
  //     if(dataState1 is DataFailed){
  //       emit(LogoutFailedState(errorMsg: ""));
  //     }
  //   }
  //   if(dataState is DataFailed){
  //     emit(RequestFailedState(errorMsg: "",));
  //   }
  //
  // }
  //
  // Future<void> submitAdvocateClerkIndividual(SubmitAdvocateClerkIndividualEvent event,
  //     Emitter<RegistrationLoginState> emit) async {
  //
  //   emit(LoadingState());
  //
  //   final dataState = await _loginUseCase.registerLitigant(event.userModel, clerk);
  //
  //   if(dataState is DataSuccess){
  //     final dataState1 = await _loginUseCase.logoutUser(event.userModel.authToken ?? "");
  //
  //     if(dataState1 is DataSuccess){
  //       emit(LogoutSuccessState(data: dataState1.data!));
  //     }
  //     if(dataState1 is DataFailed){
  //       emit(LogoutFailedState(errorMsg: ""));
  //     }
  //   }
  //   if(dataState is DataFailed){
  //     emit(RequestFailedState(errorMsg: "",));
  //   }
  //
  // }

  Future<void> submitAdvocateProfile(SubmitAdvocateProfileEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.registerAdvocate(event.userModel);

    if(dataState is DataSuccess){
      emit(AdvocateSubmissionSuccessState());
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: "",));
    }

  }

  Future<void> submitAdvocateClerkProfile(SubmitAdvocateClerkProfileEvent event,
      Emitter<RegistrationLoginState> emit) async {

    emit(LoadingState());

    final dataState = await _loginUseCase.registerAdvocateClerk(event.userModel);

    if(dataState is DataSuccess){
      emit(AdvocateSubmissionSuccessState());
    }
    if(dataState is DataFailed){
      emit(RequestFailedState(errorMsg: "",));
    }

  }

}