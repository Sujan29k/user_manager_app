import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController _nameController;
  late TextEditingController _jobController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _jobController = TextEditingController(text: widget.user?.job ?? '');
  }

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Automatically generate dummy avatar
    final avatarUrl =
        "https://robohash.org/${_nameController.text.replaceAll(' ', '_')}.png";

    final newUser = User(
      id: widget.user?.id,
      name: _nameController.text,
      job: _jobController.text,
      avatar: avatarUrl,
    );

    try {
      if (widget.user == null) {
        await apiService.createUser(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully!')),
        );
      } else {
        await apiService.updateUser(widget.user!.id!, newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully!')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Add User" : "Edit User"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a name" : null,
              ),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: "Job Title"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a job title" : null,
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _saveUser,
                      icon: const Icon(Icons.save),
                      label: Text(widget.user == null ? "Save" : "Update"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
