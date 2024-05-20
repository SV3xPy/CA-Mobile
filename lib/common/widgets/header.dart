import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String? photoUrl = user?.photoURL;
    final String? userName = user?.displayName;
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10.0,
        30.0,
        10.0,
        30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundImage: photoUrl != null
                ? NetworkImage(photoUrl)
                : const NetworkImage(
                    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png'),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: AutoSizeText(
              userName ?? "Nombre usuario",
              style: TextStyle(
                color: tSwitchProvider ? Colors.white : Colors.black,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              minFontSize: 12, // Establece el tamaño mínimo del texto
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
