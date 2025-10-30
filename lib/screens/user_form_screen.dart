import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text =
          "${widget.user!.firstName} ${widget.user!.lastName}";
      _jobController.text = widget.user!.job ?? '';
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.user == null) {
        await ApiService.createUser(_nameController.text, _jobController.text);
      } else {
        await ApiService.updateUser(
          widget.user!.id,
          _nameController.text,
          _jobController.text,
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Add User" : "Edit User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Name cannot be empty" : null,
              ),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: "Job"),
                validator: (value) =>
                    value!.isEmpty ? "Job cannot be empty" : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveUser,
                      child: const Text("Save"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
