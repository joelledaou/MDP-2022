import 'package:flutter/material.dart';
import 'dashboard.dart';

class Drop extends StatefulWidget {
  const Drop({Key? key}) : super(key: key);

  @override
  State<Drop> createState() => _DropState();
}

class _DropState extends State<Drop> {
  List<String> cities = [
    'Amioun',
    'Baalbek',
    'Batroun',
    'Bcharre',
    'Beirut',
    'Bhamdoun',
    'Byblos',
    'El Hermel',
    'El Ksar',
    'Halba',
    'Hasbaiya',
    'Jezzine',
    'Joubb Jannine',
    'Jounieh',
    'Marjayoun',
    'Nabatiye et Tahta',
    'Rachaiya el Ouadi',
    'Ramlet el Bayda',
    'Sidon',
    'Tripoli',
    'Tyre',
    'Zahle',
    'Zgharta'
  ];
  String selectedCity = 'Beirut';

  String holder = '';

  void getDropDownItem() {
    setState(() {
      holder = selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: const [
              Text('Select your nearest location then save it',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                  width: 250,
                  child: Theme(
                      data:
                          Theme.of(context).copyWith(canvasColor: Colors.white),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.blue))),
                          isExpanded: true,
                          value: selectedCity,
                          items: cities
                              .map((city) => DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black))))
                              .toList(),
                          onChanged: (city) =>
                              setState(() => selectedCity = city as String)))),
              const SizedBox(width: 10),
              RaisedButton(
                child: const Text('Save'),
                onPressed: getDropDownItem,
                color: Colors.blue,
                textColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text('City selected : ' + holder,
                  style: const TextStyle(fontSize: 22, color: Colors.black))),
          RaisedButton(
            child: const Text('Sign up'),
            //onPressed: getDropDownItem,
            color: Colors.blue,
            textColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            onPressed: () {
              //getDropDownItem;
              if (holder == '') {
                print("user didn't save his location");
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Dashboard(
                          updateData: () {},
                          valueC: holder,
                        )
                    // HomePage(
                    //   valueC: holder,
                    // )
                    ));
              }
            },
          ),
        ],
      ),
    ));
  }
}
