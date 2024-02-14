//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Globals {
  final String? currentUid;
  final String? currentUEmail;
  final String? userDocumentId;
  final String? companyId;
  final String? mlsId;
  final String? currentTrxnId;
  final String? currentCompanyName;
  final String? currentCompanyState;
  final String? currentUserId;
  final String? currentUserState;
  final String? currentUserName;
  final String? selectedState;
  final String? selectedUserState;
  final String? selectedTrxnState;
  final String? selectedCompany;
  final String? selectedUser;
  final String? userBusinessType;
  final int? targetScreen;
  final bool? newEvent;
  final bool? newTrxn;
  final bool? newUser;
  final bool? newClient;
  final bool? newInspector;
  final bool? isNewAppraiserCompany;
  final bool newCompany;
  final bool? newMortgageCompany;
  final bool? isNewTitleCompany;
  final bool? addCompany;

  Globals({
    this.currentUid,
    this.currentUEmail,
    this.userDocumentId,
    this.companyId,
    this.mlsId,
    this.currentTrxnId,
    this.currentCompanyName,
    this.currentCompanyState,
    this.currentUserId,
    this.currentUserState,
    this.currentUserName,
    this.selectedState,
    this.selectedUserState,
    this.selectedTrxnState,
    this.selectedCompany,
    this.selectedUser,
    this.userBusinessType,
    this.targetScreen,
    this.newEvent,
    this.newTrxn,
    this.newUser,
    this.newClient,
    this.newInspector,
    this.isNewAppraiserCompany,
    this.newMortgageCompany,
    this.isNewTitleCompany,
    this.addCompany,
    required this.newCompany,
  });

  Globals copyWith({
    String? currentUid,
    String? currentUEmail,
    String? userDocumentId,
    String? companyId,
    String? mlsId,
    String? currentTrxnId,
    String? currentCompanyName,
    String? currentCompanyState,
    String? currentUserId,
    String? currentUserState,
    String? currentUserName,
    String? selectedState,
    String? selectedUserState,
    String? selectedTrxnState,
    String? selectedCompany,
    String? selectedUser,
    String? userBusinessType,
    int? targetScreen,
    bool newEvent = true,
    bool? newTrxn = true,
    bool newUser = true,
    bool newClient = true,
    bool newInspector = true,
    bool isNewAppraiserCompany = true,
    bool newCompany = true,
    bool newMortgageCompany = true,
    bool isNewTitleCompany = true,
    bool addCompany = false,
  }) {
    return Globals(
      currentUid: currentUid ?? this.currentUid,
      currentUEmail: currentUEmail ?? this.currentUEmail,
      userDocumentId: userDocumentId ?? this.userDocumentId,
      companyId: companyId ?? this.companyId,
      mlsId: mlsId ?? this.mlsId,
      currentTrxnId: currentTrxnId ?? this.currentTrxnId,
      currentCompanyName: currentCompanyName ?? this.currentCompanyName,
      currentCompanyState: currentCompanyState ?? this.currentCompanyState,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserState: currentUserState ?? this.currentUserState,
      currentUserName: currentUserName ?? this.currentUserName,
      selectedState: selectedState ?? this.selectedState,
      selectedUserState: selectedUserState ?? this.selectedUserState,
      selectedTrxnState: selectedTrxnState ?? this.selectedTrxnState,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      selectedUser: selectedUser ?? this.selectedUser,
      userBusinessType: userBusinessType ?? this.userBusinessType,
      targetScreen: targetScreen ?? this.targetScreen,
      newEvent: newEvent,
      newTrxn: newTrxn,
      newUser: newUser,
      newClient: newClient,
      newInspector: newInspector,
      isNewAppraiserCompany: isNewAppraiserCompany,
      newCompany: newCompany,
      newMortgageCompany: newMortgageCompany,
      isNewTitleCompany: isNewTitleCompany,
      addCompany: addCompany,
      // newEvent: newEvent ?? this.newEvent,
      // newTrxn: newTrxn ?? this.newTrxn,
      // newUser: newUser ?? this.newUser,
      // newCompany: newCompany ?? this.newCompany,
    );
  }
}

class GlobalsNotifier extends Notifier<Globals> {
  @override
  Globals build() {
    return Globals(
      currentUid: '',
      currentUEmail: '',
      userDocumentId: '',
      companyId: '',
      mlsId: '',
      currentTrxnId: '',
      currentCompanyName: '',
      currentCompanyState: '',
      currentUserId: '',
      currentUserName: '',
      currentUserState: '',
      selectedCompany: '',
      selectedState: '',
      selectedTrxnState: '',
      selectedUser: '',
      selectedUserState: '',
      userBusinessType: '',
      targetScreen: 0,
      newCompany: true,
      newEvent: true,
      newTrxn: true,
      newUser: true,
      newClient: true,
      newInspector: true,
      isNewAppraiserCompany: true,
      newMortgageCompany: true,
      isNewTitleCompany: true,
      addCompany: false,
    );
  }

  // functions to update class members
  void updatecurrentUid(String newcurrentUid) {
    state = state.copyWith(currentUid: newcurrentUid);
  }

  void updatecurrentUEmail(String? newcurrentUEmail) {
    state = state.copyWith(currentUEmail: newcurrentUEmail);
  }

  void updateuserDocumentId(String newuserDocumentId) {
    state = state.copyWith(userDocumentId: newuserDocumentId);
  }

  void updatecompanyId(String newcompanyId) {
    state = state.copyWith(companyId: newcompanyId);
  }

  void updatemlsId(String newmlsId) {
    state = state.copyWith(mlsId: newmlsId);
  }

  void updatecurrentTrxnId(String? newcurrentTrxnId) {
    state = state.copyWith(currentTrxnId: newcurrentTrxnId);
  }

  void updatecurrentCompanyName(String newcurrentCompanyName) {
    state = state.copyWith(currentCompanyName: newcurrentCompanyName);
  }

  void updatecurrentCompanyState(String newcurrentCompanyState) {
    state = state.copyWith(currentCompanyState: newcurrentCompanyState);
  }

  void updatecurrentUserId(String newcurrentUserId) {
    state = state.copyWith(currentUserId: newcurrentUserId);
  }

  void updatecurrentUserState(String newcurrentUserState) {
    state = state.copyWith(currentUserState: newcurrentUserState);
  }

  void updatecurrentUserName(String newcurrentUserName) {
    state = state.copyWith(currentUserName: newcurrentUserName);
  }

  void updateselectedState(String newselectedState) {
    state = state.copyWith(selectedState: newselectedState);
  }

  void updateselectedUserState(String newselectedUserState) {
    state = state.copyWith(selectedUserState: newselectedUserState);
  }

  void updateselectedTrxnState(String newselectedTrxnState) {
    state = state.copyWith(selectedTrxnState: newselectedTrxnState);
  }

  void updateselectedCompany(String newselectedCompany) {
    state = state.copyWith(selectedCompany: newselectedCompany);
  }

  void updateselectedUser(String newselectedUser) {
    state = state.copyWith(selectedUser: newselectedUser);
  }

  void updateUserBusinessType(String newUserBusinessType) {
    state = state.copyWith(userBusinessType: newUserBusinessType);
  }

  void updatetargetScreen(int newtargetScreen) {
    state = state.copyWith(targetScreen: newtargetScreen);
  }

  void updatenewEvent(bool newNewEvent) {
    state = state.copyWith(newEvent: newNewEvent);
  }

  void updatenewTrxn(bool newNewTrxn) {
    state = state.copyWith(newTrxn: newNewTrxn);
  }

  void updatenewUser(bool newNewUser) {
    state = state.copyWith(newUser: newNewUser);
  }

  void updatenewClient(bool newNewClient) {
    state = state.copyWith(newClient: newNewClient);
  }

  void updatenewInspector(bool newNewInspector) {
    state = state.copyWith(newInspector: newNewInspector);
  }

  void updateIsNewAppraiserCompany(bool newIsNewAppraiserCompany) {
    state = state.copyWith(isNewAppraiserCompany: newIsNewAppraiserCompany);
  }

  void updatenewCompany(bool newNewCompany) {
    state = state.copyWith(newCompany: newNewCompany);
  }

  void updateAddCompany(bool newAddCompany) {
    state = state.copyWith(addCompany: newAddCompany);
  }

  void updatenewMortgageCompany(bool newMortgageCompany) {
    state = state.copyWith(newMortgageCompany: newMortgageCompany);
  }

  void updateIsNewTitleCompany(bool newIsNewTitleCompany) {
    state = state.copyWith(isNewTitleCompany: newIsNewTitleCompany);
  }
}

final globalsNotifierProvider = NotifierProvider<GlobalsNotifier, Globals>(() {
  return GlobalsNotifier();
});
