import 'package:flutter/material.dart';

enum SortBy { increasing, decreasing }

class SortFilter {
  //Variables

  SortBy sortBy;
  Color selectedOptionTextColor;
  int _selectedIndex;
  final Map _displayedStringZHTW = {
    'sort by': '排序依據',
    'increasing': '標題: A 到 Z',
    'decreasing': '標題: Z 到 A'
  };

  final List<String> sortByOptions = ['標題: A 到 Z', '標題: Z 到 A'];

  //Constructor
  SortFilter({this.sortBy});

  //Dialog
  tagFilterDialog(BuildContext context) async {
    selectedOptionTextColor = Theme.of(context).primaryColor;
    if (sortBy == SortBy.increasing) {
      _selectedIndex = 0;
    } else if (sortBy == SortBy.decreasing) {
      _selectedIndex = 1;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                width: 50,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 13, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _displayedStringZHTW['sort by'] ?? '',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                        height: 300,
                        child: ListView.builder(
                            itemCount: sortByOptions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      sortByOptions[index],
                                      style: TextStyle(
                                        color: index == _selectedIndex
                                            ? selectedOptionTextColor
                                            : Colors.black,
                                      ),
                                    ),
                                  ));
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
