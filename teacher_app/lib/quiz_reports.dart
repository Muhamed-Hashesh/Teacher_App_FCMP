import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizReportsPage extends StatefulWidget {
  const QuizReportsPage({Key? key}) : super(key: key);

  @override
  State<QuizReportsPage> createState() => _QuizReportsPageState();
}

class _QuizReportsPageState extends State<QuizReportsPage> {
  String? _selectedClass;
  final List<String> _classes = [
    'Grade 6 A',
    'Grade 6 B',
    'Grade 5 A',
    'Grade 4 B'
  ];
  bool _isByQuizSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Quiz Reports',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting class
              const Text(
                "Choose a class",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: _selectedClass,
                  hint: const Text(
                    "--",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  underline: const SizedBox(),
                  items: _classes.map((String className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(
                        className,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClass = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 1,
                width: double.infinity,
                color: const Color.fromARGB(255, 203, 202, 202),
              ),
              const SizedBox(height: 16),

              // Separate buttons for switching between By Quiz and By Student
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isByQuizSelected = true;
                      });
                    },
                    icon: Icon(
                      Icons.quiz,
                      color: _isByQuizSelected ? Colors.white : Colors.black,
                    ),
                    label: Text(
                      " By Quiz",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _isByQuizSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isByQuizSelected
                          ? const Color.fromARGB(255, 1, 151, 168)
                          : Colors.white,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 208, 208, 208)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between the buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isByQuizSelected = false;
                      });
                    },
                    icon: Icon(
                      size: 20,
                      FontAwesomeIcons.graduationCap,
                      color: !_isByQuizSelected ? Colors.white : Colors.black,
                    ),
                    label: Text(
                      " By Student",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: !_isByQuizSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isByQuizSelected
                          ? const Color.fromARGB(255, 1, 151, 168)
                          : Colors.white,
                      side: BorderSide(
                        color: const Color.fromARGB(255, 208, 208, 208),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Display report section based on the selected toggle
              _isByQuizSelected
                  ? _buildByQuizSection()
                  : _buildByStudentSection(),
               SizedBox(height: 15,),
              // Revision Reports Button at the Bottom
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle navigation to Revision Reports or related action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                    minimumSize: const Size.fromHeight(50), // Set height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Revision Reports",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // By Quiz Section
  Widget _buildByQuizSection() {
    return _buildTableSection("By Quiz");
  }

  // By Student Section
  Widget _buildByStudentSection() {
    return _buildTableSection("By Student");
  }

  // Build Table Section for both Quiz and Student view
  Widget _buildTableSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Add Table Headers
        _buildTableHeader(),
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // Adjust these values as needed
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          children: [
            _buildTableRow("Ahmed Omar", "65%", "65%"),
            _buildTableRow("Omar Ahmed", "87%", "87%"),
            _buildTableRow("Mohamed Ahmed", "90%", "90%"),
            _buildTableRow("Said Kamal", "69%", "69%"),
            _buildTableRow("Mohamed Ramy", "89%", "89%"),
            _buildTableRow("Ahmed Mohamed", "78%", "78%"),
            _buildTableRow("Ramy Omar", "90%", "90%"),
          ],
        ),
      ],
    );
  }

  // Build Table Header
  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(flex: 2, child: Text("NAME", style: _headerTextStyle)),
          Expanded(flex: 1, child: Text("30 DAYS", style: _headerTextStyle)),
          Expanded(flex: 1, child: Text("LAST", style: _headerTextStyle)),
        ],
      ),
    );
  }

  // Table Header Text Style
  static const _headerTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Build Table Row
  TableRow _buildTableRow(String name, String last30Days, String last) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(name, style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text(last30Days, style: const TextStyle(fontSize: 16))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text(last, style: const TextStyle(fontSize: 16))),
        ),
      ],
    );
  }
}
