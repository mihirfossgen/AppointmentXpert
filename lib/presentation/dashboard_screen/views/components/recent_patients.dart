part of dashboard;

class _RecentPatients extends StatelessWidget {
  const _RecentPatients({
    required this.data,
    required this.onPressed,
    // required this.onPressedAssign,
    // required this.onPressedMember,
    Key? key,
  }) : super(key: key);

  final List<Content> data;
  final Function(int index, Content data) onPressed;
  // final Function(int index, ListRecentPatientData data) onPressedAssign;
  // final Function(int index, ListRecentPatientData data) onPressedMember;

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) ? loadList() : loadDataTable();
  }

  Widget loadDataTable() {
    final DateFormat formatter = DateFormat.yMMMMd('en_US');

    return SizedBox(
        //width: 400,
        height: 250,
        child: Card(
          child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 10,
              minWidth: 600,
              showBottomBorder: true,
              //dataRowHeight: 70,
              empty: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No recent patient\'s found.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              columns: [
                // DataColumn2(
                //   label: Text(
                //     'Profile',
                //     style: AppStyle.txtInterSemiBold14,
                //   ),
                //   //size: ColumnSize.L,
                // ),
                DataColumn2(
                  label: Text(
                    'Name',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                    label: Text(
                      'Age',
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterSemiBold14,
                    ),
                    size: ColumnSize.S,
                    numeric: false),
                DataColumn(
                  label: Text(
                    'Date of birth',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Blood Group',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text(
                    'Actions',
                    style: AppStyle.txtInterSemiBold14,
                  ),
                  numeric: true,
                ),
              ],
              rows: List<DataRow>.generate(
                  data.length,
                  (index) => DataRow(cells: [
                        DataCell(
                            Row(
                              children: [
                                data[index].profilePicture != null
                                    ? CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: Uri.encodeFull(
                                          Endpoints.baseURL +
                                              Endpoints.downLoadPatientPhoto +
                                              data[index].id.toString(),
                                        ),
                                        httpHeaders: {
                                          "Authorization":
                                              "Bearer ${SharedPrefUtils.readPrefStr("auth_token")}"
                                        },
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) {
                                          print(error);
                                          return CustomImageView(
                                            imagePath: !Responsive.isDesktop(
                                                    Get.context!)
                                                ? 'assets' +
                                                    '/images/default_profile.png'
                                                : '/images/default_profile.png',
                                          );
                                        },
                                      )
                                    : CustomImageView(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        imagePath: !Responsive.isDesktop(
                                                Get.context!)
                                            ? 'assets' +
                                                '/images/default_profile.png'
                                            : '/images/default_profile.png',
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    '${data[index].firstName} ' +
                                        '${data[index].lastName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            onTap: () {}),
                        DataCell(Text('${data[index].age}'), onTap: () {}),
                        DataCell(
                            Text(formatter
                                .format(DateTime.parse('${data[index].dob}'))),
                            onTap: () {}),
                        DataCell(Text('${data[index].email}'), onTap: () {}),
                        DataCell(Text('${data[index].bloodType}'),
                            onTap: () {}),
                        //DataCell(Text(
                        //    formatter.format(DateTime.parse('${data[index].date}')))),
                        DataCell(Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.remove_red_eye),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Icon(Icons.close)
                          ],
                        )),
                      ]))),
        ));
  }

  Widget loadList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: data
            .asMap()
            .entries
            .map(
              (e) => ListRecentPatients(
                data: e.value,
                onPressed: () => onPressed(e.key, e.value),
                // onPressedAssign: () => onPressedAssign(e.key, e.value),
                // onPressedMember: () => onPressedMember(e.key, e.value),
              ),
            )
            .toList(),
      ),
    );
  }
}
