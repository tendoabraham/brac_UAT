import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_widget.dart';


class Branches extends StatefulWidget {
  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<Branches> {
  String _selectedRegion = 'Central A';
  final List<String> _centralAItems = ['Entebbe Kitoro','Kireka ','Kabuusu',
    'Kampala','Mukono','Kyengera'];
  final List<String> _centralBItems = ['Gayaza','Kawempe','Luwero','Iganga',
    'Nansana','Jinja'];
  final List<String> _northernItems = ['Masindi','Gulu','Arua','Koboko','Nebbi'];
  final List<String> _westernItems = ['Masaka','Ibanda','Mbarara','Kabale'];
  final List<String> _southWesternItems = ['Mubende','Mityana','Fort Portal',
    'Kasese','Kyenjojo','Hoima'];
  final List<String> _easternItems = ['Bugiri','Mbale','Soroti','Tororo','Lira'];

  final List<String> _centralAOffShoreItems = ['Zzana','Abayita Ababiri','Kajjansi',
    'Entebbe Kitoro','Kireka','Seeta','Kisaasi','Kira','Makindye','Kabuusu',
    'Natete','Kampala Road Corporate','Kitintale','Kibuli','Ggaba','Mukono'
      'Lugazi','Mukono Central','Nkokonjeru','Njeru','Kayunga','Kangulumira',
    'Buikwe','Kyengera','Mpigi','Nsangi','Gombe'];

  final List<String> _centralBOffShoreItems = ['Kasangati','Zirobwe','Nakifuma',
    'Kasawo','Kalerwe','Maganjo','Matugga','Kawempe','Wobulenzi','Luwero',
    'Bombo','Semuto','Iganga','Pallisa','Kaliro','Namutumba','Luuka','Nansana',
    'Kasubi','Wakiso','Busunjju','Jinja','Musita','Mayuge','Bukizibu','Kamuli',
    'Buwenge','Namwendwa','Buyala'];

  final List<String> _northernOffShoreItems = ['Kijura','Masindi','Bweyale','Kigumba',
    'Gulu','Layibi','Kamdini','Kalongo','Kitgum','Lacor','Adjumani','Anaka',
    'Pabbor','Palemo-Deri','Arua','Arua Hill','Arua Manibe','Odia','Arivu',
    'Koboko','Yumbe','Maracha','Moyo','Paidha','Nebbi','Pakwach','Parombo'];

  final List<String> _westernOffShoreItems = ['Kyotera','Kalisizo','Masaka','Lukaya',
    'Nyendo','Buwama','Sembabule','Ibanda','Kamwenge','Ishongororo','Ishaka',
    'Kabwohe','Rubindi','Rubirizi','Mbarara','Lyantonde','Kinoni','Isingiro',
    'Kabale','Muhanga','Kisoro','Rubanda','Ntungamo','Rukungiri','Buyanja','Kihihi'];

  List<String> _southWesternOffShoreItems = ['Mubende','Kisekende','Kasambya',
    'Kiganda','Kakumiro','Bulenga','Mityana','Kiyinda','Bukuya','Kasusu',
    'Fort Portal','Bundibugyo','Kibiito','Nyahuka','Kasese','Rwiimi','Rukoki',
    'Bwera','Kisinga','Kyenjojo','Kyegegwa','Kagadi','Kibaale','Hoima','Kinubi','Kiboga','Biiso'];

  final List<String> _easternOffShoreItems = ['Bugiri','Busia','Iganga Nkono','Idudi',
    'Namayingo','Mbale','Sironko','Kapchorwa','Nakaloke','Soroti','Kumi','Ngora'
    ,'Serere','Dokolo','Katakwi','Amuria','Amolatar','Bugema','Tororo','Budaka',
    'Bududa','Magale','Lira','Ojwina','Apac','Aduku','Iceme'];

  void _onDropdownChanged(String? value) {
    setState(() {
      _selectedRegion = value!;
    });
  }


  List<String> _getOffshoreBranchItemsForSelectedRegion() {
    switch (_selectedRegion) {
      case 'Central A':
        return _centralAOffShoreItems;
      case 'Central B':
        return _centralBOffShoreItems;
      case 'Northern':
        return _northernOffShoreItems;
      case 'Western':
        return _westernOffShoreItems;
      case 'southWestern':
        return _southWesternOffShoreItems;
      case 'Eastern':
        return _easternOffShoreItems;
      default:
        return [];
    }
  }

  List<String> _getItemsForSelectedRegion() {
    switch (_selectedRegion) {
      case 'Central A':
        return _centralAItems;
      case 'Central B':
        return _centralBItems;
      case 'Northern':
        return _northernItems;
      case 'Western':
        return _westernItems;
      case 'southWestern':
        return _southWesternItems;
      case 'Eastern':
        return _easternItems;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Branches"),
        titleTextStyle: const TextStyle(fontFamily: "Mulish",
            fontWeight: FontWeight.bold,
            fontSize: 18),),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/images/brac.png',
              height: 100,
              width: 100,),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child: Label(
              text: "Please select your region",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
              value: _selectedRegion,
              onChanged: _onDropdownChanged,
              items: <String>['Central A','Central B', 'Northern', 'Western','southWestern', 'Eastern']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(value,
                    style: const TextStyle(
                      fontFamily: "Mulish",
                      fontSize: 14,
                    ),),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child:                           Label(
              text: "Main Branches",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: (_getItemsForSelectedRegion().length * 20.0) + 5.0,
            child: ListView.builder(
              itemCount: _getItemsForSelectedRegion().length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(_getItemsForSelectedRegion()[index],
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),),
                );
              },
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child:                           Label(
              text: "Off-site Branches",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getOffshoreBranchItemsForSelectedRegion().length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(_getOffshoreBranchItemsForSelectedRegion()[index],
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Mulish",
                    color:
                    CupertinoColors.systemGrey,
                  ),),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}