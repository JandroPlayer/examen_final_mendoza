import 'package:examen_final_mendoza/services/services.dart';
import 'package:examen_final_mendoza/widgets/pokemon_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: _PokemonForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pokemonService.isValidForm()) {
            pokemonService.saveOrCreatePokemon();
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _PokemonForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);
    var tempPokemon = pokemonService.tempPokemon;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: pokemonService.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              PokemonPhoto(photoUrl: tempPokemon?.photo ?? '', radius: 60), // Display photo if it's valid
              SizedBox(height: 20), // Espacio entre la foto y el primer campo
              TextFormField(
                initialValue: tempPokemon?.name ?? '',
                onChanged: (value) {
                  pokemonService.updateTempPokemon(tempPokemon!.copyWith(name: value));
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
                initialValue: tempPokemon?.tipus ?? '',
                onChanged: (value) {
                  pokemonService.updateTempPokemon(tempPokemon!.copyWith(tipus: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El tipo es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Tipo', labelText: 'Tipo:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempPokemon?.descripcio ?? '',
                onChanged: (value) {
                  pokemonService.updateTempPokemon(tempPokemon!.copyWith(descripcio: value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Descripción', labelText: 'Descripción:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempPokemon?.photo ?? '',
                onChanged: (value) {
                  pokemonService.updateTempPokemon(tempPokemon!.copyWith(photo: value));
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
