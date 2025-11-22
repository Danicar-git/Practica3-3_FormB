import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulario B',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const FormBPage(),
    );
  }
}

class FormBPage extends StatefulWidget {
  const FormBPage({super.key});

  @override
  State<FormBPage> createState() => _FormBPageState();
}

class _FormBPageState extends State<FormBPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  final String studentName = "Daniel Carballido 25/26"; 

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 1) {
        if (_formKey.currentState?.saveAndValidate() ?? false) {
          setState(() => _currentStep++);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, rellena los campos correctamente')),
          );
        }
      } else {
        setState(() => _currentStep++);
      }
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitForm() {
    _formKey.currentState?.save();
    
    final formValues = _formKey.currentState?.value.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.check_circle, size: 45, color: Color(0xFF3B5975)),
              SizedBox(height: 10),
              Text(
                "Envío\nCompletado", 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: Text(
            formValues,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studentName),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          _buildTopStepper(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: _formKey,
                child: IndexedStack(
                  index: _currentStep,
                  children: [
                    _buildPersonalStep(),
                    _buildContactStep(),
                    _buildUploadStep(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5975),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _nextStep,
                  child: const Text("Continuar"),
                ),
                const SizedBox(width: 15),
                TextButton(
                  onPressed: _prevStep,
                  child: Text(
                    "Cancelar", 
                    style: TextStyle(color: Colors.blue.shade900)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTopStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStepItem(0, "Persona", Icons.looks_one),
          _buildStepItem(1, "Contacto", Icons.edit),
          _buildStepItem(2, "Subir", Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepItem(int index, String label, IconData icon) {
    bool isActiveOrCompleted = _currentStep >= index;
    Color color = isActiveOrCompleted ? const Color(0xFF3B5975) : Colors.grey;

    return Row(
      children: [
        if (index == 0)
           CircleAvatar(
            radius: 12,
            backgroundColor: color,
            child: const Text("1", style: TextStyle(fontSize: 12, color: Colors.white)),
           )
        else
          Icon(icon, color: color, size: 24),
        
        const SizedBox(width: 8),
        
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: _currentStep == index ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 40),
          Text(
            "Personal",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Pulse Contacto o pulse Continuar.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep() {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'Email',
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          name: 'Direccion',
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.home, color: Colors.blueAccent),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          name: 'Telefono',
          decoration: const InputDecoration(
            labelText: 'Numero de Teléfono movil',
            prefixIcon: Icon(Icons.phone, color: Colors.blueAccent),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildUploadStep() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 40),
          Text(
            "Subir",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Pulsa Continuar para finalizar.",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Icon(Icons.cloud_upload, size: 100, color: Colors.blueGrey),
        ],
      ),
    );
  }
}