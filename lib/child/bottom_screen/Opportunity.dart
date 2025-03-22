import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Opportunities",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF43061E),
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: Color(0xFF9F80A7),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF43061E), // Active tab text color
          unselectedLabelColor: Color(0xFFECE1EE), // Inactive tab text color
          //indicatorColor: Colors.white, // Underline color for active tab
          labelStyle: TextStyle(
            fontSize: 16, // Increase size slightly
            fontWeight: FontWeight.bold, // Make it bold
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14, // Keep unselected tabs slightly smaller
            fontWeight: FontWeight.w600, // Semi-bold for unselected tabs
          ),
          tabs: [
            Tab(text: "Jobs"),
            Tab(text: "Scholarships"),
            Tab(text: "Internships"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OpportunitiesList(category: "Jobs"),
          OpportunitiesList(category: "Scholarships"),
          OpportunitiesList(category: "Internships"),
        ],
      ),
    );
  }
}

class OpportunitiesList extends StatelessWidget {
  final String category;
  OpportunitiesList({super.key, required this.category});

  // Define official links for each opportunity
  final Map<String, List<Map<String, String>>> opportunities = {
    "Jobs": [
      {
        "title": "Government Jobs",
        "url": "https://www.ncs.gov.in/jobs-for-women",
      },
      {"title": "Google Careers", "url": "https://careers.google.com"},
      {"title": "Amazon Jobs", "url": "https://www.amazon.jobs"},
      {"title": "Microsoft Careers", "url": "https://careers.microsoft.com"},
      {"title": "LinkedIn Jobs", "url": "https://www.linkedin.com/jobs"},
      {"title": "Indeed", "url": "https://www.indeed.com"},
      {"title": "Glassdoor Jobs", "url": "https://www.glassdoor.com/Job"},
      {"title": "Monster Jobs", "url": "https://www.monster.com"},
      {"title": "AngelList Startups", "url": "https://angel.co/jobs"},
      {"title": "Stack Overflow Jobs", "url": "https://stackoverflow.com/jobs"},
    ],
    "Scholarships": [
      {
        "title": "Women in STEM Scholarship",
        "url": "https://www.womeninstem.org",
      },
      {
        "title": "Harvard Scholarships",
        "url": "https://college.harvard.edu/financial-aid",
      },
      {"title": "MIT Research Grants", "url": "https://research.mit.edu"},
      {"title": "Scholarships.com", "url": "https://www.scholarships.com"},
      {"title": "Fastweb Scholarships", "url": "https://www.fastweb.com"},
      {
        "title": "Chevening Scholarships",
        "url": "https://www.chevening.org/scholarships",
      },
      {
        "title": "DAAD Scholarships",
        "url":
            "https://www.daad.de/en/study-and-research-in-germany/scholarships",
      },
      {
        "title": "Commonwealth Scholarships",
        "url": "https://cscuk.fcdo.gov.uk/apply",
      },
    ],
    "Internships": [
      {
        "title": "Apple Internships",
        "url": "https://www.apple.com/careers/us/internships.html",
      },
      {
        "title": "Tesla Internships",
        "url": "https://www.tesla.com/careers/internships",
      },
      {
        "title": "Adobe Internships",
        "url": "https://www.adobe.com/careers/students.html",
      },
      {"title": "Internshala", "url": "https://internshala.com"},
      {
        "title": "LinkedIn Internships",
        "url": "https://www.linkedin.com/jobs/internships",
      },
      {
        "title": "Google Internships",
        "url": "https://careers.google.com/students",
      },
      {
        "title": "Microsoft Internships",
        "url": "https://careers.microsoft.com/students",
      },
      {
        "title": "Amazon Internships",
        "url":
            "https://www.amazon.jobs/en/job_categories/university-recruiting",
      },
    ],
  };

  // Function to open URL in browser
  Future<void> _launchURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not launch $url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: opportunities[category]?.length ?? 0,
      itemBuilder: (context, index) {
        var opportunity = opportunities[category]![index];
        return ListTile(
          title: Text(opportunity["title"]!),
          trailing: Icon(Icons.open_in_new),
          onTap:
              () => _launchURL(
                context,
                opportunity["url"]!,
              ), // Pass context correctly
        );
      },
    );
  }
}
