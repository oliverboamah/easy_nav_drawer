// flutter package imports
import 'package:easy_nav_drawer/src/gel_menu_item.dart';
import 'package:flutter/material.dart';

// third party package imports
import 'package:shared_preferences/shared_preferences.dart';

// my package imports

class GelNavDrawer extends StatefulWidget {
  final String appName;
  final Color appNameColor;
  final String appSlogan;
  final Color appSloganColor;
  final String appLogoAsset;
  final List<GelMenuItem> menuItems;
  final Color menuItemColor;
  final Color selectedMenuItemColor;
  //final bool showSettingsIcon;
  //final Color settingsIconColor;
  final bool showCloseIcon;
  final Color closeIconColor;
  final Color drawerHeaderBackgroundColor;
  final Color drawerBodyBackgroundColor;
  final Color dividerColor;

  final Function onMenuItemClicked;
  final Function onSettingsIconClicked;

  // key to store and retrieve selectedMenuItem in shared prefs
  final selectedMenuItemKey = '@key:selectedMenuItem';

  GelNavDrawer(
      {this.appName = '',
      this.appNameColor = Colors.white,
      this.appSlogan = '',
      this.appSloganColor = Colors.white70,
      @required this.appLogoAsset,
      @required this.menuItems,
      this.menuItemColor = Colors.black54,
      this.selectedMenuItemColor = Colors.red,
      // this.showSettingsIcon = true,
      //this.settingsIconColor = Colors.white,
      this.showCloseIcon = true,
      this.closeIconColor = Colors.white,
      this.drawerHeaderBackgroundColor = Colors.red,
      this.drawerBodyBackgroundColor = Colors.white,
      this.dividerColor = Colors.grey,
      @required this.onMenuItemClicked,
      this.onSettingsIconClicked});

  @override
  State<StatefulWidget> createState() => _GelNavDrawerState();
}

class _GelNavDrawerState extends State<GelNavDrawer> {
  String selectedMenuItem = '';

  @override
  void initState() {
    super.initState();
    this._loadState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Drawer(
        child: Container(
          color: this.widget.drawerBodyBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: this.widget.drawerHeaderBackgroundColor,
                ),
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(this.widget.appLogoAsset),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                          child: Text(
                            this.widget.appName,
                            style: TextStyle(
                                color: this.widget.appNameColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        Text(
                          this.widget.appSlogan,
                          style: TextStyle(
                              fontSize: 13, color: this.widget.appSloganColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              this._getListTiles(beforeDivider: true),
              Divider(
                color: this.widget.dividerColor,
              ),
              this._getListTiles(beforeDivider: false)
            ],
          ),
        ),
      ),
    );
  }

  // Use menuItems to construct list tiles
  Widget _getListTiles({bool beforeDivider}) {
    // filter menu items: based on whether they appear before divider or not
    List<GelMenuItem> filteredMenuItems = this
        .widget
        .menuItems
        .where((menuItem) => menuItem.showBeforeDivider == beforeDivider)
        .toList();

    // construct a listTile for every menu item
    List<ListTile> listTiles = filteredMenuItems.map((menuItem) {
      Color currentMenuItemColor = this.selectedMenuItem == menuItem.title
          ? this.widget.selectedMenuItemColor
          : this.widget.menuItemColor;

      return ListTile(
        title:
            Text(menuItem.title, style: TextStyle(color: currentMenuItemColor)),
        leading: IconButton(
          icon: Icon(menuItem.iconData, color: currentMenuItemColor),
          onPressed: () => {},
        ),
        onTap: () {
          this.setState(() => this.selectedMenuItem = menuItem.title);
          this._saveState(menuItem.title);
          this.widget.onMenuItemClicked(menuItem.title);
          Navigator.of(context).pop();
        },
      );
    }).toList();

    return Column(children: listTiles);
  }

  // save selectedMenuItemTitle state
  void _saveState(String selectedMenuItem) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(this.widget.selectedMenuItemKey, selectedMenuItem);
    }).catchError((onError) {
      print(onError);
    });
  }

  // load selectedMenuItemTitle state
  void _loadState() {
    SharedPreferences.getInstance().then((prefs) {
      final value = prefs.getString(this.widget.selectedMenuItemKey);
      if (value != null) {
        this.setState(() => this.selectedMenuItem = value);
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
