import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/sliver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
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

  Widget _getHeader(String title) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Pushed Headers',
                style: TextStyle(color: Colors.black87)
              ),
            ),
            expandedHeight: 100,
            pinned: true,
            centerTitle: true,
          ),
          SliverGroup(
            slivers: <Widget>[
              _getHeader('A'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('A - $index'),
                    );
                  },
                  childCount: 15,
                ),
              )
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              _getHeader('B'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('B - $index'),
                    );
                  },
                  childCount: 15,
                ),
              )
            ],
          ),
          SliverGroup(
            slivers: <Widget>[
              _getHeader('C'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('C - $index'),
                    );
                  },
                  childCount: 15,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// final ScrollController _controller = ScrollController(initialScrollOffset: 300);

// SliverAppBar(
//             title: Text('SliverAppBar\n pinned:true'),
//             expandedHeight: 100,
//             // floating: true,
//             pinned: true,
//           ),
//                 // SliverPersistentHeader(
//                 //       floating: true,
//                 //       pinned: false,
//                 //       delegate: SliverHeaderDelegate(
//                 //         minHeight: 50,
//                 //         maxHeight: 100,
//                 //         child: Container(
//                 //           color: Colors.blue[700],
//                 //           child: Center(
//                 //             child: Text(
//                 //               'Outside',
//                 //               textAlign: TextAlign.center,
//                 //               style: TextStyle(
//                 //                 color: Colors.white,
//                 //                 fontSize: 20,
//                 //                 fontWeight: FontWeight.bold,
//                 //               )
//                 //             ),
//                 //           ),
//                 //         )
//                 //       )
//                 //     ),
//           // SliverGroup(slivers: [
//           //   SliverExpanded(child:
//           //     SliverToBoxAdapter(child: Container(color: Colors.red, height: 100))
//           //   ),
//           //   SliverSpacer(),
//           //   SliverToBoxAdapter(child: Container(color: Colors.blue, height: 100))
//           // ]),
//           // SliverToBoxAdapter(child: Container(color: Colors.red, height: 100)),
//           SliverGroup(
//             key: Key('Group 1'),
//             pushPinnedHeaders: true,
//             slivers: <Widget>[
//               SliverPersistentHeader(
//                 // TODO(Piinks): Check all PersistentHeaders & various configurations
//                 pinned: true,
//                 delegate: SliverHeaderDelegate(
//                   minHeight: 50,
//                   maxHeight: 50, //100,
//                   child: Container(
//                     color: Colors.blue[700],
//                     child: Center(
//                       child: Text(
//                         'SliverGroup 1',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )
//                       ),
//                     ),
//                   )
//                 )
//               ),
//               SliverExpanded(
//                 child: SliverToBoxAdapter(
//                   child: Container(
//                     height: 100.0,
//                     color: Colors.amberAccent[400],
//                     child: Center(
//                       child: Text(
//                         'SliverExpanded\ndefault height: 150, flex: 1',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverExpanded(
//                 flex: 2,
//                 child: SliverToBoxAdapter(
//                   child: Container(
//                     height: 100.0,
//                     color: Colors.orange[400],
//                     child: Center(
//                       child: Text(
//                         'SliverExpanded\ndefault height: 150, flex: 2',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Container(
//                   height: 200,
//                   color: Colors.blueGrey[300],
//                   child: Center(
//                     child: Text(
//                       'SliverToBoxAdapter\n Container height: 200',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       )
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SliverGroup(
//             key: Key('Group 2'),
//             slivers: <Widget>[
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: SliverHeaderDelegate(
//                   minHeight: 50,
//                   maxHeight: 50,
//                   child: Container(
//                     color: Colors.blue[900],
//                     child: Center(
//                       child: Text(
//                         'SliverGroup 2',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )
//                       ),
//                     ),
//                   )
//                 )
//               ),
//               SliverExpanded(
//                 child: SliverToBoxAdapter(
//                   child: Container(
//                     height: 100.0,
//                     color: Colors.amberAccent[400],
//                     child: Center(
//                       child: Text(
//                         'SliverExpanded\ndefault height: 150',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverSpacer(),
//               SliverToBoxAdapter(
//                 child: Container(
//                   height: 1000,
//                   color: Colors.blueGrey[400],
//                   child: Center(
//                     child: Text(
//                       'SliverToBoxAdapter\n Container height: 1000',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       )
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
