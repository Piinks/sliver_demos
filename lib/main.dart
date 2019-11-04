/// To be used in conjunction with the changes proposed on the Piinks-sliverFlex
/// branch.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/0': (BuildContext context) => SimpleExpand(),
        '/1': (BuildContext context) => MultiExpand(),
        '/2': (BuildContext context) => SliverFallback(),
        '/3': (BuildContext context) => SliverEdge1(),
        '/4': (BuildContext context) => SimpleSpacer(),
        '/5': (BuildContext context) => NoSliverSpacer(),
        '/6': (BuildContext context) => MultiGroup(),
        '/7': (BuildContext context) => SliverEdge2(),
        '/8': (BuildContext context) => PushHeaders(),
        '/9': (BuildContext context) => NestedGroups(),
      },
    );
  }
}

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight, maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('SliverFlex Study'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'SliverExpanded',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('Simple SliverExpanded'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('A simple use case with one SliverExpanded inside of a SliverGroup.'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/0'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('Multiple SliverExpanded'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Demonstration of flex distribution among two SliverExpanded widgets'
                      ' within a SliverGroup.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/1'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverExpanded Fallback'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'When the original extent of a SliverGroup exceeds the length of the viewport,'
                      ' SliverExpanded falls back on its child\'s size.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/2'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverExpanded Edge Case 1'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('initialScrollOffset > unflexed extent'),
                        Text('Utilizes the sample example from Simple SliverExpanded with modified scrolloffset.'),
                        Text('Expansion will be calculated accurately, and scroll offset corrected, as it does not have any further extent.')
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/3'),
                  ),
                ),
              ),
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'SliverSpacer',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('Simple SliverSpacer'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('A simple use case with one SliverSpacer inside of a SliverGroup.'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 40,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/4'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverSpacer Fallback'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('SliverSpacer will not fill space if unflexed extent is greater than the viewport\'s extent.'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 40,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/5'),
                  ),
                ),
              ),
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Multiple SliverGroups',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverGroups with Expanding Slivers'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'A SliverGroup that is not the first of multiple SliverGroups'
                      ' will not expand flex elements.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/6'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverGroups with extent overrides'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'A SliverGroup that is not the first of multiple SliverGroups'
                      ' will not expand flex elements, unless a manual max extent is set.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.access_time),
                    iconSize: 45,
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverExpanded Edge Case 2'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('initialScrollOffset > unflexed extent + additonal scroll extent after the SliverGroup.'),
                        Text('This case accounts for an expanded group, will further scroll extent and an initial scroll offset.'),
                        Text('Initial scroll offset & expansion will be set correctly.')
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/7'),
                  ),
                ),
              ),
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'SliverGroup Extras',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverGroups Pushing Pinned Headers'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'By default, a SliverGroup will push pinned SliverPersistentHeaders'
                      ' when the end of the group is reached.',
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/8'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('SliverGroups pushing collapsing pinned headers'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'By default, a SliverGroup will push collapsing pinned SliverPersistentHeaders'
                      ' when the end of the group is reached.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.access_time),
                    iconSize: 45,
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('Nested SliverGroups'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Nested SliverGroup example with pushed headers on different levels.'
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 45,
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/9'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleExpand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Simple SliverExpanded'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class MultiExpand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Multiple SliverExpanded Widgets'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverExpanded(
                flex: 2,
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[300],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100\nflex: 2',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100\nflex: 1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class SliverFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('SliverExpanded Fallback'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(_buildList(3))),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[300],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverList(delegate: SliverChildListDelegate(_buildList(3))),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[300],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class SliverEdge1 extends StatelessWidget {
  final ScrollController controller = ScrollController(initialScrollOffset: 400);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Sliver Edge 1'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class SimpleSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Simple SliverSpacer'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(_buildList(2))),
              SliverSpacer(),
              SliverList(delegate: SliverChildListDelegate(_buildList(2))),
            ],
          )
        ],
      )
    );
  }
}

class NoSliverSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Simple SliverSpacer'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(_buildList(4))),
              SliverSpacer(),
              SliverList(delegate: SliverChildListDelegate(_buildList(4))),
            ],
          )
        ],
      )
    );
  }
}

class MultiGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Simple SliverExpanded'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.red[100],
                  height: 60,
                  child: Center(
                    child: Text(
                      'SliverGroup 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.red[100],
                  height: 60,
                  child: Center(
                    child: Text(
                      'SliverGroup 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          )
        ],
      )
    );
  }
}

class SliverEdge2 extends StatelessWidget {
  final ScrollController controller = ScrollController(initialScrollOffset: 400);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Sliver Edge 2'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
              SliverExpanded(
                child: SliverToBoxAdapter(
                  child: Container(
                    color: Colors.amber[200],
                    height: 100,
                    child: Center(
                      child: Text(
                        'SliverExpanded\ndefault height: 100',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                    )
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blueGrey[200],
                  height: 100,
                  child: Center(
                    child: Text(
                      'SliverToBoxAdapter\nheight: 100',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  )
                )
              ),
            ],
          ),
          SliverList(delegate: SliverChildListDelegate(_buildList(10)),),
        ],
      )
    );
  }
}

class PushHeaders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Pushed Headers'),
            centerTitle: true,
            pinned: true,
          ),
          _getGroup('A'),
          _getGroup('B'),
          _getGroup('C'),
        ],
      )
    );
  }
}

class NestedGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Nested SliverGroups'),
            centerTitle: true,
            pinned: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Group 1',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  )
                ),
              ),
              _getGroup('A'),
              _getGroup('B'),
              _getGroup('C'),
            ]
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Group 2',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  )
                ),
              ),
              _getGroup('A'),
              _getGroup('B'),
              _getGroup('C'),
            ]
          ),
          SliverGroup(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Group 3',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  )
                ),
              ),
              _getGroup('A'),
              _getGroup('B'),
              _getGroup('C'),
            ]
          ),
        ],
      )
    );
  }
}

List _buildList(int count) {
  List<Widget> listItems = List();
  for(int i = 0; i < count; i++){
    listItems.add(
      Container(
        height: 100,
        color: i % 2 == 0 ? Colors.blue[100] : Colors.red[100],
        child: Center(
          child: Text(
            'SliverList Item $i\nheight: 100',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
        )
      )
    );
  }
  return listItems;
}

Widget _getGroup(String header) {
  return SliverGroup(
    slivers: <Widget>[
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
          minHeight: 50,
          maxHeight: 50,
          child: Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Group $header',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
            )
          )
        )
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(foods[header][index]),
            );
          },
          childCount: 15,
        ),
      )
    ],
  );
}

Map<String, List<String>> foods = {
  'A': [
    'Apple',
    'Apple Pie',
    'Mott\'s Apple Sauce',
    'Apple Butter',
    'Apple Juice',
    'Apple Cider Vinegar',
    'Appletini',
    'Whiskey and Apple Jelly',
    'Apple Jacks',
    'Asparagus',
    'Almonds',
    'Abalone',
    'Anchovies',
    'Star Anise',
    'Allspice',
  ],
  'B': [
    'Banana',
    'Banana Bread',
    'Boston Cream Pie',
    'Banana Cream Pie',
    'Banana Split',
    'Brownies',
    'Baked Beans With Veggies',
    'Biscuit',
    'Baked Alaska',
    'Bread',
    'Biscuits and Gravy',
    'Butter',
    'Broccoli',
    'Blueberries',
    'Blackberries',
  ],
  'C': [
    'Coffee',
    'Cappuccino',
    'Cooked Carrots',
    'Carrot Cake',
    'Carrot',
    'Cauliflower',
    'Chicken',
    'Chicken Pot Pie',
    'Chocolate',
    'Caramel Apple',
    'Crunch',
    'Crackers',
    'Chocolate Cake',
    'Cheese',
    'Cheesecake',
  ],
};
