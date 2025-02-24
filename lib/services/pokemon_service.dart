import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String _baseUrl = "caa2836403a3cec187a5.free.beeceptor.com";
  List<Pokemon> pokemons = [];
  Pokemon? tempPokemon;

  PokemonService() {
    this.loadPokemons();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> loadPokemons() async {
    pokemons.clear();
    final url = Uri.https(_baseUrl, 'api/pokemon');
    final response = await http.get(url);
    final List<dynamic> pokemonsList = json.decode(response.body);

    // FormatException (FormatException: Unexpected character (at character 5) 429 - Too Many Requests. Refer: https://beeceptor.com/pricing/

    // Mapeamos la respuesta del servidor, por cada Pokémon, lo convertimos a la clase y lo añadimos a la lista
    pokemonsList.forEach((value) {
      final auxPokemon = Pokemon.fromMap(value);
      pokemons.add(auxPokemon);
    });

    notifyListeners();
  }

  Future<void> deletePokemon(Pokemon pokemon) async {
    final url = Uri.https(_baseUrl, 'api/pokemon/${pokemon.id}');
    final response = await http.delete(url);
    final decodedData = json.decode(response.body);
    print(decodedData);
    loadPokemons();
  }

  Future<void> updatePokemon() async {
    final url = Uri.https(_baseUrl, 'api/pokemon/${tempPokemon!.id}');
    final response = await http.put(url, body: json.encode(tempPokemon!.toMap()));
    final decodedData = response.body;
  }

  Future<void> createPokemon() async {
    final url = Uri.https(_baseUrl, 'api/pokemon');
    final response = await http.post(url, body: json.encode(tempPokemon!.toMap()));
    
    final decodedData = json.decode(response.body);
    final newId = decodedData['name'];  // Firebase genera una ID en el campo 'name'

    // Asignamos la ID generada a tempPokemon
    tempPokemon = tempPokemon!.copyWith(id: newId);
  }

  // Método para actualizar tempPokemon
  void updateTempPokemon(Pokemon updatedPokemon) {
    tempPokemon = updatedPokemon;
    notifyListeners();  // Notificamos a los listeners que ha habido un cambio
  }

  Future<void> saveOrCreatePokemon() async {
    if (tempPokemon?.id == null) {
      // Creamos el Pokémon y generamos la ID automáticamente
      await this.createPokemon();
    } else {
      // Actualizamos el Pokémon si ya tiene una ID
      await this.updatePokemon();
    }
    loadPokemons(); // Recargamos la lista de Pokémon después de guardar o crear
  }
}