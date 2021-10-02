import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> populares;
  final String? titulo;
  final Function onNextPage;

  const MovieSlider({Key? key,
    required this.populares, 
    this.titulo, 
    required this.onNextPage
  }) : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    scrollController.addListener(() { 
      if( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500 ){
        widget.onNextPage();
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(this.widget.titulo != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text( '${this.widget.titulo}' , style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ),
          
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.populares.length,
              itemBuilder: ( _ , int index) => _MoviePoster(popular: widget.populares[index], heroId: '${widget.titulo}-$index-${widget.populares[index].id}'),
            )
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie popular;
  final String heroId;

  const _MoviePoster({
    Key? key, 
    required this.popular,
    required this.heroId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    popular.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: popular),
            child: Hero(
              tag: popular.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(popular.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Text( popular.title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}