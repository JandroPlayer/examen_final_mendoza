import 'package:examen_final_mendoza/services/services.dart';
import 'package:examen_final_mendoza/widgets/pokemon_photo.dart';

import '../services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<UserService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: _UserForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userForm.isValidForm()) {
            userForm.saveOrCreateUser();
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<PokemonService>(context);
    var tempUser = userForm.tempUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: userForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              PokemonPhoto(photoUrl: tempUser.photo, radius: 60), // Display photo if it's valid
              SizedBox(height: 20), // Espacio entre la foto y el primer campo
              TextFormField(
                initialValue: tempUser.name,
                onChanged: (value) {
                  userForm.updateTempUser(tempUser.copyWith(name: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre', labelText: 'Nombre:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempUser.email,
                onChanged: (value) {
                  userForm.updateTempUser(tempUser.copyWith(email: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El email es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Email', labelText: 'Email:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempUser.phone,
                onChanged: (value) {
                  userForm.updateTempUser(tempUser.copyWith(phone: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El teléfono es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Teléfono', labelText: 'Teléfono:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempUser.address,
                onChanged: (value) {
                  userForm.updateTempUser(tempUser.copyWith(address: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es obligatoria';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Dirección', labelText: 'Dirección:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempUser.photo,
                onChanged: (value) {
                  userForm.updateTempUser(tempUser.copyWith(photo: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La foto es obligatoria';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'URL de la foto', labelText: 'Foto:'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5),
        ],
      );
}
