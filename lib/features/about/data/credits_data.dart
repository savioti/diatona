class Credit {
  final String name;
  final String role;
  final String? url;
  const Credit({required this.name, required this.role, this.url});
}

const credits = <Credit>[
  Credit(
    name: 'University of Iowa Electronic Music Studios',
    role: 'Piano sounds',
    url: 'https://theremin.music.uiowa.edu/MIS.html',
  ),
];
