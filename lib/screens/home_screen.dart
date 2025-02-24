import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../ui/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);
    List<Pokemon> pokemons = pokemonService.pokemons;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('logOrReg');
            },
          ),
        ],
      ),
      body: pokemons.isEmpty
          ? Loading()
          : ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      leading: Image.network(pokemons[index].photo),
                      title: Text(pokemons[index].name),
                      subtitle: Text(pokemons[index].tipus),
                    ),
                    onTap: () {
                      pokemonService.tempPokemon = pokemons[index].copy();
                      Navigator.of(context).pushNamed('detail');
                    },
                  ),
                  onDismissed: (direction) {
                    if (pokemons.length < 2) {
                      pokemonService.fetchPokemons();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No es pot esborrar tots els elements!')));
                    } else {
                      pokemonService.deletePokemon(pokemons[index]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${pokemons[index].name} esborrat')));
                    }
                  },
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pokemonService.tempPokemon = Pokemon(
            id: '2',
            name: 'Pikachu',
            tipus: 'Electric',
            descripcio: 'A yellow electric Pokémon',
            photo: 'https://picsum.photos/250?image=9',
          );
          Navigator.of(context).pushNamed('detail');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}