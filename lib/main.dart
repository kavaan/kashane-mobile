import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'پیش‌بینی قیمت خانه',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HouseForm(),
    );
  }
}

class HouseForm extends StatefulWidget {
  const HouseForm({Key? key}) : super(key: key);

  @override
  _HouseFormState createState() => _HouseFormState();
}

class _HouseFormState extends State<HouseForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  String? _predictedPrice;

  Future<void> _predictPrice() async {
    const String apiUrl = 'https://kashane.onrender.com/api/HousePrediction';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _predictedPrice = json.decode(response.body)['predictedPrice'].toString();
        });
      } else {
        setState(() {
          _predictedPrice = 'خطا: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _predictedPrice = 'خطا: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پیش‌بینی قیمت خانه')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'محله'),
                items: [
                  'امیرکبیر', 'حمزه‌کلا', 'کمربندی غربی', 'میدان کشوری', 'شریعتی',
                  'قارن', 'درب دلاکان', 'چهارراه نواب', 'کمربندی شرقی', 'کوی شهید بهشتی'
                ].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['neighborhood'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'متراژ (متر مربع)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['area'] = int.tryParse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'تعداد اتاق'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['rooms'] = int.tryParse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'سال ساخت'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['yearBuilt'] = int.tryParse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'تعداد طبقات'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['floors'] = int.tryParse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'طبقه'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['floorNumber'] = int.tryParse(value!),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'آسانسور'),
                items: ['دارد', 'ندارد'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['elevator'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'پارکینگ'),
                items: ['دارد', 'ندارد'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['parking'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع ملک'),
                items: ['آپارتمان', 'ویلا'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['propertyType'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع سند'),
                items: ['تک‌برگ', 'قولنامه‌ای', 'شش‌دانگ'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['documentType'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نزدیکی به مراکز مهم'),
                items: ['مدرسه', 'مرکز خرید', 'بیمارستان', 'ایستگاه اتوبوس', 'پارک', 'بازار', 'خیابان اصلی']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['nearCenters'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'وضعیت بازسازی'),
                items: ['نوساز', 'قدیمی', 'بازسازی شده']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['renovationStatus'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع کف‌پوش'),
                items: ['سرامیک', 'پارکت', 'سنگ', 'موکت'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['flooringType'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع نما'),
                items: ['آجر', 'سنگ', 'سیمان'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['facadeType'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'امکانات اضافی'),
                items: ['هیچ', 'استخر', 'جکوزی', 'سونا'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                onChanged: (value) {},
                onSaved: (value) => _formData['extraAmenities'] = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _predictPrice();
                  }
                },
                child: const Text('پیش‌بینی قیمت'),
              ),
              if (_predictedPrice != null) ...[
                const SizedBox(height: 20),
                Text(
                  'قیمت پیش‌بینی‌شده: $_predictedPrice تومان',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
