part of dashboard;

class _HeaderRecentPatients extends StatelessWidget {
  const _HeaderRecentPatients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        HeaderText("Recent Patients"),
        Spacer(),
        //_buildArchive(),
        SizedBox(width: 10),
        //_buildAddNewButton(),
      ],
    );
  }

  Widget _buildAddNewButton() {
    return ElevatedButton.icon(
      icon: const Icon(
        EvaIcons.plus,
        size: 16,
      ),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      label: const Text("Add New"),
    );
  }

  Widget _buildArchive() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[850], backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: const Text("Archive"),
    );
  }
}
