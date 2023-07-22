import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.menu_rounded),
            Consumer<HomeProvider>(
              builder: (context, value, child) {
                if (value.hasNotification.isEmpty) {
                  return const SizedBox();
                }
                return const Positioned(
                  right: 0,
                  child: Icon(
                    Icons.circle_rounded,
                    color: Colors.red,
                    size: 10,
                  ),
                );
              },
            ),
          ],
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: AnimatedSearchBar(
        searchDecoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'Search User, Order ID, or Product',
        ),
        label: 'OPTIK SATRIA JAYA',
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w900,
            ),
        textInputAction: TextInputAction.search,
        onChanged: (value) {},
        onFieldSubmitted: (value) {},
      ),
    );
  }
}
