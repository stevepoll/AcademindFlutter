import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const String routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Map<String, bool> _switches = {
    'gluten-free': false,
    'lactose-free': false,
    'vegetarian': false,
    'vegan': false,
  };

  @override
  initState() {
    super.initState();
    _switches['gluten-free'] = widget.currentFilters['gluten'];
    _switches['lactose-free'] = widget.currentFilters['lactose'];
    _switches['vegetarian'] = widget.currentFilters['vegetarian'];
    _switches['vegan'] = widget.currentFilters['vegan'];
  }

  List<Widget> buildSwitchList() {
    List<SwitchListTile> tiles = [];

    for (var key in _switches.keys) {
      var title = key[0].toUpperCase() + key.substring(1);

      tiles.add(SwitchListTile(
        title: Text(title),
        value: _switches[key],
        subtitle: Text('Only include $key meals'),
        onChanged: (newValue) {
          _switches[key] = newValue;
        },
      ));
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final selectedFilters = {
                'gluten': _switches['gluten-free'],
                'lactose': _switches['lactose-free'],
                'vegan': _switches['vegan'],
                'vegetarian': _switches['vegetarian'],
              };
              widget.saveFilters(selectedFilters);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: ListView(
              children: buildSwitchList(),
            ),
          ),
        ],
      ),
    );
  }
}
