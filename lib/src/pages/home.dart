import 'package:band_names/src/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List <Band> bands=[
    Band(id:'1', name: 'Metalica',votes: 5),
    Band(id:'2', name: 'Queen',votes: 1),
    Band(id:'3', name: 'Heroes del silencio',votes: 2),
    Band(id:'4', name: 'Bon jovi',votes: 5)
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BandNames',style: TextStyle(color: Colors.black87),)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index])
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          child: Icon(Icons.add),
          onPressed: addNewBand
          ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      onDismissed: (direction){

      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band',style: TextStyle(color: Colors.white),)
          ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
            onTap: (){

            },

          ),
    );
  }
  addNewBand(){
    final textController= new TextEditingController();
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('New band name'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: ()=>addBandToList(textController.text)
              )
          ],
        );

      }
      );

  }
  void addBandToList(String name){
    if(name.length>1){
      this.bands.add(new Band(id: DateTime.now().toString(),name: name,votes: 0));
      setState(() {
        
      });

    }

    Navigator.pop(context);
  }
}