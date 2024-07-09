import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pinkpig_project_flutter/ui/main/transaction/_components/assets_keyboard.dart';
import 'package:pinkpig_project_flutter/ui/main/transaction/daily/viewmodel/transaction_type_viewmodel.dart';
import '../../../../data/dtos/transaction/transaction_request.dart';
import '../_components/category_in_keyboard.dart';
import '../_components/category_out_keyboard.dart';
import 'components/transaction_category_button.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

class TransactionWritePage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _categoryIn = TextEditingController();
  final _categoryOut = TextEditingController();
  final _assets = TextEditingController();
  final _description = TextEditingController();
  final _transactionType = TextEditingController();

  // var _dateTime;
  TimeOfDay? _selectedTime; // 시간을 저장할 변수
  DateTime? _selectedDate;

  TransactionWritePage({super.key});

  void _categoryOutKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategoryOutKeyboard(controller: _categoryOut);
      },
    );
  }

  void _categoryInKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategoryInKeyboard(controller: _categoryIn);
      },
    );
  }

  void _assetsKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AssetsKeyboard(controller: _assets);
      },
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final transactionType = ref.watch(transactionTypeProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(

        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TransactionCategoryButton(
                      text: "수입",
                      isSelected: transactionType.isIncomeSelected,
                      onTap: () {
                        ref
                            .read(transactionTypeProvider.notifier)
                            .selectIncome();
                      },
                    ),
                    TransactionCategoryButton(
                      text: "지출",
                      isSelected: transactionType.isExpenseSelected,
                      onTap: () {
                        ref
                            .read(transactionTypeProvider.notifier)
                            .selectExpense();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "날짜",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(0xFFFC7C9A),
                                      onPrimary: Color(0xFFFC7C9A),
                                      onSurface: Colors.black,
                                    ),
                                    dialogBackgroundColor: Colors.grey,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != selectedDate) {
                              ref
                                  .read(selectedDateProvider.notifier)
                                  .state =
                                  picked;
                              _selectedDate = picked;
                              print("날짜 확인 : ${DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate!)}");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate == null
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())
                                      : DateFormat('yyyy-MM-dd')
                                      .format(selectedDate),
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                const Icon(Icons.calendar_today,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null && picked != selectedTime) {
                              ref
                                  .read(selectedTimeProvider.notifier)
                                  .state =
                                  picked;
                              _selectedTime = picked;
                              print(
                                  "시간 확인 : ${_selectedTime?.format(context)}");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedTime == null
                                      ? TimeOfDay.now().format(context)
                                      : '${selectedTime.format(context)}',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                const Icon(Icons.access_time,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "금액",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _amount,
                          decoration: InputDecoration(
                            hintText: '금액을 입력하세요',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (transactionType.isIncomeSelected)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "분류",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _categoryIn,
                            readOnly: true,
                            // 기본 키보드 비활성화
                            onTap: () => _categoryInKeyboard(context),
                            // 커스텀 키보드 표시
                            decoration: InputDecoration(
                              hintText: '분류를 선택하세요',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "분류",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _categoryOut,
                            readOnly: true,
                            // 기본 키보드 비활성화
                            onTap: () => _categoryOutKeyboard(context),
                            // 커스텀 키보드 표시
                            decoration: InputDecoration(
                              hintText: '분류를 선택하세요',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "자산",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _assets,
                          readOnly: true, // 기본 키보드 비활성화
                          onTap: () => _assetsKeyboard(context), // 커스텀 키보드 표시
                          decoration: InputDecoration(
                            hintText: '자산을 입력하세요',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "내용",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _description,
                          decoration: InputDecoration(
                            hintText: '내용을 입력하세요',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: SizedBox(
                    width: double.infinity,
                    // Set the button width to full width of the container
                    child: ElevatedButton(
                      onPressed: () {
                        if (transactionType.isIncomeSelected) {
                          TransactionSaveDTO requestDTO = TransactionSaveDTO(
                              amount: _amount.text.trim(),
                              assets: _assets.text.trim(),
                              categoryIn: _categoryIn.text.trim(),
                              description: _description.text.trim(),
                              yearMonthDate: _selectedDate,
                              time: _selectedTime,
                              transactionType : "수입"
                          );
                        }else{
                          TransactionSaveDTO requestDTO = TransactionSaveDTO(
                              amount: _amount,
                              assets: _assets,
                              categoryOut: _categoryOut,
                              description: _description,
                              yearMonthDate: _selectedDate,
                              time: _selectedTime,
                              transactionType : "지출"
                          );

                        }
                      },
                      child: Text(
                        '저장하기',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFC7C9A),
                        foregroundColor: Color(0xFFFC7C9A),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFC7C9A),
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("기록",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(Icons.settings, color: Colors.white),
        )
      ],
    );
  }
}
