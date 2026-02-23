import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentProgressTable extends StatelessWidget {
  const ParentProgressTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner Progress'),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usage_logs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No learning data found.'));
          }

          return SingleChildScrollView(
            child: PaginatedDataTable(
              header: const Text("Student Progress Dashboard"),
              rowsPerPage: 10,
              columns: const [
                DataColumn(label: Text('Date completed')),
                DataColumn(label: Text('Skill ID')),
                DataColumn(label: Text('Accuracy Score')),
                DataColumn(label: Text('Time Spent (s)')),
              ],
              source: UsageDataSource(snapshot.data!.docs),
            ),
          );
        },
      ),
    );
  }
}

class UsageDataSource extends DataTableSource {
  final List<QueryDocumentSnapshot> docs;

  UsageDataSource(this.docs);

  @override
  DataRow? getRow(int index) {
    if (index >= docs.length) return null;
    final data = docs[index].data() as Map<String, dynamic>;
    
    final timestamp = data['timestamp'] as Timestamp?;
    final date = timestamp != null 
        ? "\${timestamp.toDate().toLocal()}".split(' ')[0] 
        : 'Unknown';

    final skillId = data['skillId'] ?? 'N/A';
    final accuracy = (data['accuracy'] ?? 0.0) as double;
    final duration = (data['duration'] ?? 0) / 1000;

    return DataRow(cells: [
      DataCell(Text(date)),
      DataCell(Text(skillId)),
      DataCell(Text("\${(accuracy * 100).toStringAsFixed(1)}%")),
      DataCell(Text("\${duration.toStringAsFixed(1)}s")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => docs.length;

  @override
  int get selectedRowCount => 0;
}
