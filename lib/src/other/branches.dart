import 'package:brac_mobile/src/theme/app_theme.dart';
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

  final List<String> _southWesternOffShoreItems = ['Mubende','Kisekende','Kasambya',
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

  Widget _buildRegionButton(String region) {
    bool isSelected = region == _selectedRegion;

    return isSelected
        ? ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedRegion = region;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: primaryColor, // Primary color for selected button
        onPrimary: Colors.white, // Text color for selected button
      ),
      child: Text(
        region,
        style: TextStyle(
          fontFamily: "Mulish",
          fontSize: 14,
        ),
      ),
    )
        : OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedRegion = region;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor), // Outline color for unselected button
      ),
      child: Text(
        region,
        style: TextStyle(
          fontFamily: "Mulish",
          color: primaryColor,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bk4.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      ' Our Branches',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: primaryColor,
                        fontFamily: "Mulish",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.close,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 1.0, // Line height
                color: Colors.grey[300], // Line color
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Image.asset('assets/images/brac.png', height: 100, width: 100),
                      // const SizedBox(height: 16),
                      Container(
                        width: screenWidth,
                        child: Card(
                            elevation: 5,
                            // surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(20.0),
                              //   image: const DecorationImage(
                              //       image: AssetImage('assets/images/bk4.png'),
                              //       fit: BoxFit.cover,
                              //       alignment: Alignment.topCenter),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Please select your region",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Mulish",
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Wrap(
                                        spacing: 10,
                                        children: <Widget>[
                                          for (String region in ['Central A', 'Central B', 'Northern', 'Western', 'Southwestern', 'Eastern'])
                                            _buildRegionButton(region),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBranchList("Main Branches", _getItemsForSelectedRegion()),
                      const SizedBox(height: 16),
                      _buildBranchList("Off-site Branches", _getOffshoreBranchItemsForSelectedRegion()),
                    ],
                  ),
                ),
              )
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _buildBranchList(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Mulish",
        ),),
        SizedBox(height: 15,),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  items[index],
                  style: const TextStyle(fontSize: 14, fontFamily: "Mulish", color: CupertinoColors.systemGrey),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}