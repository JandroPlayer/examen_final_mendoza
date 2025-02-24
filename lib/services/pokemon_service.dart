import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pokemon.dart';

class PokemonService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Pokemon> pokemons = [];
  Pokemon? tempPokemon;

  Future<void> fetchPokemons() async {
    final response = await http.get(Uri.parse('https://caa2836403a3cec187a5.free.beeceptor.com/api/pokemon'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      pokemons = data.map((json) => Pokemon.fromMap(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load Pokemons');
    }
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void deletePokemon(Pokemon pokemon) {
    pokemons.remove(pokemon);
    notifyListeners();
  }

  Future<void> updatePokemon(Pokemon updatedPokemon) async {
    final response = await http.put(
      Uri.parse('https://caa2836403a3cec187a5.free.beeceptor.com/api/pokemon/${updatedPokemon.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedPokemon.toMap()),
    );

    if (response.statusCode == 200) {
      final index = pokemons.indexWhere((pokemon) => pokemon.id == updatedPokemon.id);
      if (index != -1) {
        pokemons[index] = updatedPokemon;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update Pokemon');
    }
  }

  // Método para actualizar tempPokemon
  void updateTempPokemon(Pokemon updatedPokemon) {
    tempPokemon = updatedPokemon;
    notifyListeners();  // Notificamos a los listeners que ha habido un cambio
  }

  Future<void> saveOrCreatePokemon() async {
    if (tempPokemon?.id == null || tempPokemon!.id!.isEmpty) {
      // Creamos el Pokémon y generamos la ID automáticamente
      await this.createPokemon();
    } else {
      // Actualizamos el Pokémon si ya tiene una ID
      await this.updatePokemon(tempPokemon!);
    }
    fetchPokemons(); // Recargamos la lista de Pokémon después de guardar o crear
  }

  Future<void> createPokemon() async {
    final response = await http.post(
      Uri.parse('https://caa2836403a3cec187a5.free.beeceptor.com/api/pokemon'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tempPokemon?.toMap()),
    );

    if (response.statusCode == 201) {
      final newPokemon = Pokemon.fromMap(json.decode(response.body));
      pokemons.add(newPokemon);
      notifyListeners();
    } else {
      throw Exception('Failed to create Pokemon');
    }
  }
}