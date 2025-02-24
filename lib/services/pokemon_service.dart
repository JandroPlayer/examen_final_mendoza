import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pokemon.dart';

class PokemonService {
  List<Pokemon> pokemons = [];
  Pokemon? tempPokemon;

  Future<void> fetchPokemons() async {
    final response = await http.get(Uri.parse('https://caa2836403a3cec187a5.free.beeceptor.com/api/pokemon'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      pokemons = data.map((json) => Pokemon.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load Pokemons');
    }
  }

  void deletePokemon(Pokemon pokemon) {
    pokemons.remove(pokemon);
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
      }
    } else {
      throw Exception('Failed to update Pokemon');
    }
  }
}