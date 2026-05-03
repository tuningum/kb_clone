import 'package:flutter/material.dart';

class Transaction {
  String counterpart;
  int amount; // negative = 출금, positive = 입금
  String date;
  int balanceAfter;

  Transaction({
    required this.counterpart,
    required this.amount,
    required this.date,
    required this.balanceAfter,
  });
}

class AppState extends ChangeNotifier {
  // 편집 모드
  bool _editMode = false;
  bool get editMode => _editMode;

  // 3탭 트리거
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void registerTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds > 800) {
      _tapCount = 0;
    }
    _tapCount++;
    _lastTapTime = now;

    if (_tapCount >= 3) {
      _editMode = !_editMode;
      _tapCount = 0;
      notifyListeners();
    }
  }

  // 사용자 정보
  String userName = '김용주';
  String gradeLabel = '그랜드';

  // 계좌 정보
  String accountName = '직장인우대통장-저축예금';
  String accountNumber = '567602-01-190182';
  int balance = 5091862;

  // 거래 내역
  List<Transaction> transactions = [
    Transaction(
      counterpart: '급여',
      amount: 3500000,
      date: '04.25',
      balanceAfter: 5091862,
    ),
    Transaction(
      counterpart: '스타벅스',
      amount: -4500,
      date: '04.24',
      balanceAfter: 1591862,
    ),
    Transaction(
      counterpart: '쿠팡',
      amount: -32000,
      date: '04.23',
      balanceAfter: 1596362,
    ),
    Transaction(
      counterpart: '카카오페이',
      amount: -15000,
      date: '04.22',
      balanceAfter: 1628362,
    ),
    Transaction(
      counterpart: 'GS25 편의점',
      amount: -3200,
      date: '04.21',
      balanceAfter: 1643362,
    ),
  ];

  // 잔액 포맷
  String get formattedBalance {
    return _formatCurrency(balance);
  }

  String _formatCurrency(int amount) {
    String str = amount.abs().toString();
    StringBuffer result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        result.write(',');
      }
    }
    return result.toString().split('').reversed.join('');
  }

  String formatAmount(int amount) {
    String formatted = _formatCurrency(amount.abs());
    return amount >= 0 ? '+$formatted' : '-$formatted';
  }

  // 편집 메서드
  void updateBalance(int newBalance) {
    balance = newBalance;
    notifyListeners();
  }

  void updateAccountName(String name) {
    accountName = name;
    notifyListeners();
  }

  void updateAccountNumber(String number) {
    accountNumber = number;
    notifyListeners();
  }

  void updateUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void updateTransaction(int index, {String? counterpart, int? amount, String? date, int? balanceAfter}) {
    if (index < transactions.length) {
      if (counterpart != null) transactions[index].counterpart = counterpart;
      if (amount != null) transactions[index].amount = amount;
      if (date != null) transactions[index].date = date;
      if (balanceAfter != null) transactions[index].balanceAfter = balanceAfter;
      notifyListeners();
    }
  }
}
