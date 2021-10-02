import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/models/models.dart';

import 'package:peliculas/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: (query.isEmpty) ? Icon(Icons.clear): Icon(Icons.clear, color: Colors.red,), 
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.blue[900],),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen:false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot ){
        
        if(!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;
        
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _, int index) =>_MovieItem(movie: movies[index],)
        );
      },
    );
  }


}

Widget _emptyContainer(){
  return Container(
    child: Center(
      child: Icon(Icons.movie_creation_outlined, color: Colors.blue, size: 140,),
    ),
  );
}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem({Key? key,
    required this.movie
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${ movie.id }';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage( movie.fullPosterImg ),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: (){
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}