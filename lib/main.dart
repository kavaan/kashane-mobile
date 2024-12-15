
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
      title: 'House Price Predictor',
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
          _predictedPrice = json.decode(response.body)['predictedPrice'];
        });
      } else {
        setState(() {
          _predictedPrice = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _predictedPrice = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('House Price Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'محله'),
                onSaved: (value) => _formData['neighborhood'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'متراژ (متر مربع)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['area'] = int.tryParse(value!),
              ),
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
                  'قیمت پیش‌بینی‌شده: $_predictedPrice',
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
