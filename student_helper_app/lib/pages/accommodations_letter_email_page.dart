//brings up the professors for the student's courses, or displays all professors contact and allows user to search

class TobeAdded extends StatefulWidget {
  @override
  TobeAddedState createState() => TobeAddedState();
}
class TobeAddedState extends State<TobeAdded>{
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Popup Message"),
          content: Text("This will contain a link to renew accommodations."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renew Accommodations"),
      ),
      body: Column(
        
        children: [
          
          const Text(
            'It is important to renew your accommodations before every semester. Below is where you can renew your accomodations. Insert Instructions here.'
        ),

          ElevatedButton(
          onPressed: () {
            _showAlertDialog(context);
          },
          child: Text("Go to university site"),
        ),


      ]),
    );
  }
}
