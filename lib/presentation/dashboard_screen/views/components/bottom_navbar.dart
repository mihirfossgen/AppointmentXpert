part of dashboard;

class _BottomNavbar extends StatefulWidget {
  const _BottomNavbar({Key? key, required this.onSelected}) : super(key: key);

  final Function(int index) onSelected;
  @override
  State<_BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<_BottomNavbar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (SharedPrefUtils.readPrefStr("role") == 'PATIENT') {
      return menuForPatient();
    } else if (SharedPrefUtils.readPrefStr("role") == 'RECEPTIONIST') {
      return menuForReceptionist();
    } else {
      return menuForStaff();
    }
  }

  BottomNavigationBar menuForReceptionist() {
    return BottomNavigationBar(
      currentIndex: index,
      elevation: 10,
      backgroundColor: ColorConstant.blue700,
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.home),
          icon: Icon(EvaIcons.homeOutline),
          label: "Home",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.list),
          icon: Icon(EvaIcons.list),
          label: "Appointments",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.personAdd),
          icon: Icon(EvaIcons.personAdd),
          label: "Patients",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.alertCircle),
          icon: Icon(EvaIcons.alertCircleOutline),
          label: "Emergency",
        ),BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.settings),
          icon: Icon(EvaIcons.settingsOutline),
          label: "Settings",
        ),
      ],
      selectedItemColor: ColorConstant.whiteA700,
      unselectedItemColor: ColorConstant.gray400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      onTap: (value) {
        setState(() {
          index = value;
          widget.onSelected(value);
        });
      },
    );
  }

  BottomNavigationBar menuForPatient() {
    return BottomNavigationBar(
      currentIndex: index,
      elevation: 10,
      backgroundColor: ColorConstant.blue60001,
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.home),
          icon: Icon(EvaIcons.homeOutline),
          label: "Home",
        ),
        /*BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.bell),
          icon: Icon(EvaIcons.bellOutline),
          label: "Appointments",
        ),*/
        // BottomNavigationBarItem(
        //   activeIcon: Icon(EvaIcons.phoneCall),
        //   icon: Icon(EvaIcons.phoneCall),
        //   label: "Chat",
        // ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.settings),
          icon: Icon(EvaIcons.settingsOutline),
          label: "Settings",
        ),
      ],
      selectedItemColor: ColorConstant.whiteA700,
      unselectedItemColor: ColorConstant.gray400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      onTap: (value) {
        setState(() {
          index = value;
          widget.onSelected(value);
        });
      },
    );
  }

  BottomNavigationBar menuForStaff() {
    return BottomNavigationBar(
      currentIndex: index,
      backgroundColor: ColorConstant.blue60001,
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.home),
          icon: Icon(EvaIcons.homeOutline),
          label: "Home",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.bell),
          icon: Icon(EvaIcons.bellOutline),
          label: "Appointments",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.people),
          icon: Icon(EvaIcons.people),
          label: "Patients",
        ),
        // BottomNavigationBarItem(
        //   activeIcon: Icon(EvaIcons.phoneCall),
        //   icon: Icon(EvaIcons.phoneCall),
        //   label: "Chat",
        // ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.alertCircle),
          icon: Icon(EvaIcons.alertCircleOutline),
          label: "Emergency",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.settings),
          icon: Icon(EvaIcons.settingsOutline),
          label: "Settings",
        ),
      ],
      selectedItemColor: ColorConstant.whiteA700,
      unselectedItemColor: ColorConstant.gray400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      onTap: (value) {
        setState(() {
          index = value;
          widget.onSelected(index);
        });
      },
    );
  }
}
