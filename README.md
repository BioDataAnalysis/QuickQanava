[Overview](#QuickQanava) |
[Roadmap](#Roadmap) |
[Dependencies](#Dependencies) |
[Building](#building) |
[License](#license)

[![Documentation](https://img.shields.io/badge/docs-doxygen-blue.svg)](http://www.destrat.io/quickqanava/doc)

**2017/03/21:** Warning: dev version has just been merged on master: please report any compilation problem by mail or support request.

QuickQanava 
============================

![](https://github.com/cneben/QuickQanava/blob/dev/doc/web/docs/images/home.png)

`QuickQanava` is a C++14 library designed to display graphs in a QtQuick application. QuickQanava provide components and classes to visualize medium-sized directed graph in a QML application. QuickQanava does not provide advanced layout algorithms, but rather focus on displaying relational content into an advanced dynamic user interface (with DnD support, resizable content, visual connection of content).

`QuickQanava` is released under LGPL v3, and is shipped with *[GTpo](https://github.com/cneben/GTpo)* library (MIT licence) and  *[QuickContainers](https://github.com/cneben/QuickQanava/tree/master/QuickContainers)* (LGPL) and *[QuickGeoGL](https://github.com/cneben/QuickQanava/tree/master/QuickGeoGL)*.


QuickQanava main repository is hosted on GitHub: https://github.com/cneben/quickqanava

QuickQanava is primarily developed with Qt >= 5.8 with MSVC2015U2 and g++5.4 (minimal required Qt version is 5.7, some sample requires Qt5.8)

+ Project homepage: http://www.destrat.io/quickqanava (_outdated 20170321)
+ Reference documentation: http://www.destrat.io/quickqanava/doc/index.html (_outdated_ 20170321)

For any questions, please contact: benoit@destrat.io

QuickQanava focus on writting content delegates in QML (even if they could be defined 100% in C++, a QML engine is necessary), if you are looking for a pure C++/QGraphicsView solution, have a look to: [NodeEditor](https://github.com/paceholder/nodeeditor)

## Roadmap:

  - **v0.8.0: Complex topologies**
    - GTpo (Configurable topology library):
      - [X] Redesign and optimize GTpo generic containers accessors.
      - [X] Add complex topologies support: full restricted hyper edge, group -> node and group -> group topologies.
	  - [X] Remove any virtual overhead from GTpo.
	  - [ ] Push test coverage to 100% (ie increase coverage for subgroups).- [80%] Redesign qan::Graph interface for creating content.
	  - [X] Remove protocolbuffer and properties management support (it has nothing to do in the visualization package).
    - [X] Redesign qan::Graph interface for creating content.
      - [ ] Add a 100% C++ interface (currently QML delegate components definition still are necessary).
        - [ ] Publish the 4k sample (40k is probably too much for QML without dedicated culling and LOD code).
    - [50%] Add _efficient_ support for non visual nodes and edges, non visual edges should have a very small footprint (ie non QQuickItem...).
    - [ ] Update samples for full QQC2 controls support.
    - [X] Redesign visual connection of nodes (add support for custom visual component, invisible edge creation, etc.).
    - [ ] Add full support for groups inside group (ie subgraphs).
  - **v0.9.0: QuickContainers** (Qt/QML observable adapter for STL or Qt containers):	 
    - [ ] Redesign QuickContainers: qcm::ContainerModel<> memory footprint is too high (inheritance from QAbstractItemModel comes with a strong virtual and signals/slots overhead)
	- [ ] Add support for standard library containers.
	- [ ] Increase test coverage.
  - **v1.0.0: Advanced edge visualization**	 
    - [ ] Add full support for Bezier curve edge.
    - [ ] Fix current qan::PointGrid bugs and add "snap to grid" support.
    - [ ] Use Qt 5.9 PathItem for lines, curves and poly rendering instead of QuickGeoGL (QuickGeoGl is probably faster for simple AA lines with its vertex shader, but QuickGeoGL is too complex to maintain).
    - [ ] Add support for multiple "docks" per node (ie. to connect in edges on multiple node side, not only at node center).
    - Qt 5.10 is targeted for the 1.0 release with full PathItem support.

## Dependencies:

| Dependency                | Mandatory         |   Included in source tree       |   Licence       |
| ---                       | :---:             | :---:                           | :---:           |
| GTpo                      | **Yes**           |       **Yes** (GIT submodule)   |   ![](https://img.shields.io/badge/license-MIT-blue.svg) MIT|
| Google Test/Mock          | No                |       No                        |    Permissive   |

- **Google Test** is a *GTpo* dependency, it is optional for QuickQanava until you intent to use a graph with custom non-STL/non-Qt containers: ![Google Test GitHub](https://github.com/google/googletest)

## Building:

```sh
git clone https://github.com/cneben/QuickQanava
cd QuickQanava
```
2. Open quickqanava.pro in QtCreator
  4. Building 'tests': Tests will not compile without a working Protocol Buffer v3 installation: for Windows, modify `quickqanava-common.pri` `win32-msvc*:PROTOCOL_BUFFER3_DIR`, win32-msvc*:GMOCK_DIR and win32-msvc*:GTEST_DIR with path containing a valid build directory for Protocol Buffer, Google Test and Google Mock. On Linux, no configuration is required, just install the '-dev' package for theses libraries.

3. Select a kit, build and launch samples.

Compilation errors with messages refering to 'google::' types are usually related to the Protocol Buffer of your local platform being incompatible with the code generated for protocol buffer shipped with QuickQanava, run `run_protoc.sh` script to update `quickqanava.pb.h` and `quickqanava.pb.cc` files.


## QuickQanava Samples:

| Nodes       |   |
| :---:                       | ---             |
| ![Custom content](https://github.com/cneben/QuickQanava/blob/dev/doc/web/docs/images/sample-nodes.gif) |            |

License
=======

[LGPLv3](https://github.com/cneben/QuickQanava/blob/master/licence.txt)

GTpo (depency) MIT ![](https://img.shields.io/badge/license-MIT-blue.svg)

Copyright (c) 2017 Delia Stratégie



