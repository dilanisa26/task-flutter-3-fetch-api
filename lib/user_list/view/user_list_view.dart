part of "user_list_page.dart";

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: BlocBuilder<UserListCubit, UserListState>(
        builder: (context, state) {
          if (state is UserListSuccess) {
            // Success
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  var user = state.users[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          user.title.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        user.body.length > 50
                            ? user.body.substring(0, 50) + '...'
                            : user.body,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailPage(user: user),
                          ),
                        );
                      },
                      onLongPress: () {
                        // Menampilkan dialog konfirmasi saat long press
                        _showRemoveDialog(context, user);
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is UserListError) {
            // Error
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 236, 233, 232)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.view_agenda),
                    label: const Text("Lihat Data"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 198, 173, 241), // Warna latar belakang
                      foregroundColor: Colors.white,      // Warna teks dan ikon
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Menambahkan sudut melengkung
                      ),
                    ),
                    onPressed: () =>
                        context.read<UserListCubit>().fetchUser(),
                  ),
                ],
              ),
            );
          } else if (state is UserListLoading) {
            // Loading
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else {
            // Initial / First time
            return Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.table_view),
                label: const Text("Lihat Data"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 152, 138, 177), // Ganti dari `primary` ke `backgroundColor`
                ),
                onPressed: () =>
                    context.read<UserListCubit>().fetchUser(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserListCubit>().fetchUser(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi sebelum menghapus data
  void _showRemoveDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal'),
          content: Text('Are you sure you want to remove "${user.title}" from the list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog tanpa tindakan
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<UserListCubit>().removeData(user); // Menghapus data
                Navigator.of(context).pop(); // Menutup dialog setelah penghapusan
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
