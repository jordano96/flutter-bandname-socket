import 'package:band_names/services/socket_services.dart';
import 'package:band_names/src/models/band.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List <Band> bands=[
    /*Band(id:'1', name: 'Metalica',votes: 5),
    Band(id:'2', name: 'Queen',votes: 1),
    Band(id:'3', name: 'Heroes del silencio',votes: 2),
    Band(id:'4', name: 'Bon jovi',votes: 5)*/
  ];
  @override
  void initState() {
     final socketService=Provider.of<SocketService>(context,listen: false);
     socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }
  _handleActiveBands(dynamic payload){
    //print(payload);

       this.bands=(payload as List).map((banda) => Band.fromMap(banda)).toList();

       setState(() {
         
       });

  }
  @override
  void dispose() {
    final socketService=Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final socketService=Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child:socketService.serverStatus==ServerStatus.Offline?Icon(Icons.offline_bolt,color: Colors.red):Icon(Icons.check_circle, color: Colors.green,)
            
          )
        ],
        title: Center(child: Text('BandNames',style: TextStyle(color: Colors.black87),)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          SizedBox(height: 20,),
        Expanded(
        child: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index)=>_bandTile(bands[index])
        ),
        )
        ],
      ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          child: Icon(Icons.add),
          onPressed: addNewBand
          ),
   );
  }
  Widget _showGraph(){
    Map<String, double> dataMap = new Map();
    
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
     });
     
  return Container(
    padding: EdgeInsets.only(top: 10),
    width: double.infinity,
    height: 150,
    child: PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      initialAngleInDegree: 0,
      ringStrokeWidth: 32,
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
      ),
    )
    );
  }

  Widget _bandTile(Band band) {
    final socketService=Provider.of<SocketService>(context,listen: false);
    return Dismissible(
      onDismissed: (_)=>
        socketService.socket.emit('delete-band',{'id':band.id}),
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
            onTap: ()=>
              socketService.socket.emit('vote-band',{
                'id':band.id
              }),
          ),
    );
  }
  addNewBand(){
    final textController= new TextEditingController();
    showDialog(
      context: context,
      builder: (_)=> AlertDialog(
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
        )
      );

  }
  void addBandToList(String name){
    if(name.length>1){
     
      final socketService=Provider.of<SocketService>(context,listen: false);
      socketService.socket.emit('add-band',{
        'name':name
      });
    }

    Navigator.pop(context);
  }
}