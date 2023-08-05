import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class User {
  String userName;
  String address;
  String gender;
  DateTime dateOfBirth;
  double weight;
  double height;

  User({
    required this.userName,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: UserForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'Male';
  DateTime _selectedDate = DateTime.now();
  String _result = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String address = _addressController.text;
      String gender = _gender;
      DateTime dateOfBirth = _selectedDate;
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);

      User user = User(
        userName: name,
        address: address,
        gender: gender,
        dateOfBirth: dateOfBirth,
        weight: weight,
        height: height,
      );

      // Calculate age
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - user.dateOfBirth.year;
      if (currentDate.month < user.dateOfBirth.month ||
          (currentDate.month == user.dateOfBirth.month &&
              currentDate.day < user.dateOfBirth.day)) {
        age--;
      }

      // Calculate BMI
      double bmi = user.weight / ((user.height / 100) * (user.height / 100));

      // Determine weight and height comment
      String comment = '';
      if (bmi < 18.5) {
        comment = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 25) {
        comment = 'Normal weight';
      } else if (bmi >= 25 && bmi < 30) {
        comment = 'Overweight';
      } else {
        comment = 'Obese';
      }

      // Update the result text
      setState(() {
        _result =
            'Name: ${user.userName}\nAddress: ${user.address}\nGender: ${user.gender}\nDate of Birth: ${DateFormat('yyyy-MM-dd').format(user.dateOfBirth)}\nAge: $age\nWeight: ${user.weight} kg\nHeight: ${user.height} cm\nBMI: ${bmi.toStringAsFixed(2)}\nComment: $comment';
      });
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _addressController.clear();
      _weightController.clear();
      _heightController.clear();
      _gender = 'Male';
      _selectedDate = DateTime.now();
      _result = '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.account_circle, size: 25),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    Icon(Icons.location_on, size: 25),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text('Gender'),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'Male',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value.toString();
                            });
                          },
                        ),
                        Icon(Icons.male, size: 25),
                        Text('Male'),
                        Radio(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value.toString();
                            });
                          },
                        ),
                        Icon(Icons.female, size: 25),
                        Text('Female'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Icon(Icons.calendar_today, size: 25),
                    Text('Date of Birth'),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Weight (kg)'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your weight';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Height (cm)'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your height';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Result:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _result,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
