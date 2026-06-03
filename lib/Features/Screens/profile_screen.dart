import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Predefined game-style avatars
  final List<Map<String, String>> _avatars = [
    {'name': 'Zen Master', 'emoji': '🧘‍♂️', 'perk': 'Mental clarity & Calmness'},
    {'name': 'Code Warrior', 'emoji': '💻', 'perk': 'Hyperfocus & Screen endurance'},
    {'name': 'Sprint Champion', 'emoji': '🏃‍♂️', 'perk': 'Physical Stamina & Steps boost'},
    {'name': 'Finance Shark', 'emoji': '🦈', 'perk': 'Wealth multiplication & Budget control'},
    {'name': 'Wellness Guru', 'emoji': '🥑', 'perk': 'Hydration & Nutrition shielding'},
    {'name': 'Night Owl', 'emoji': '🦉', 'perk': 'Sleep optimization & Midnight study'},
  ];

  late Map<String, String> _selectedAvatar;
  int _currentXp = 3450;
  final int _xpForNextLevel = 5000;
  final int _level = 14;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = _avatars[1]; // Default to Code Warrior
  }

  void _showAvatarSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Hero Class',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Every class unlocks different visual perks in the Productivity Hub.',
                style: TextStyle(color: Color(0xFF6E7DA7), fontSize: 13),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) {
                  final avatar = _avatars[index];
                  final isSelected = avatar['name'] == _selectedAvatar['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                        _currentXp += 250; // XP reward for changing avatar!
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF7C77F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          content: Row(
                            children: [
                              Text(avatar['emoji']!, style: const TextStyle(fontSize: 22)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Class updated to ${avatar['name']}! +250 XP earned.',
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C77F2).withValues(alpha: (0.12))
                            : const Color(0xFFF7F8FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF7C77F2) : const Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            avatar['emoji']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            avatar['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? const Color(0xFF7C77F2) : const Color(0xFF5F6E8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showPasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Recalibrate Credentials',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Update your master security parameters to safeguard your achievements.',
                    style: TextStyle(color: Color(0xFF6E7DA7), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Secret Key',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Secret Key',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 6) {
                        return 'Must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Secret Key',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Keys do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abort', style: TextStyle(color: Color(0xFF6E7DA7), fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _currentXp += 150; // Award XP for security update!
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF00BFA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      content: const Text(
                        'Security recalibration complete! Password updated. +150 XP earned.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C77F2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Apply Update', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double xpPercentage = _currentXp / _xpForNextLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Level'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key_rounded),
            onPressed: _showPasswordDialog,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Status card
            _buildHeroStatusCard(xpPercentage),

            const SizedBox(height: 20),

            // Achievement grid header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Chaotic Life Rewards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Gamified multipliers unlocked from daily habit actions.',
                style: TextStyle(color: Color(0xFF6E7DA7), fontSize: 13),
              ),
            ),
            const SizedBox(height: 14),

            // Rewards Grid
            _buildRewardsGrid(),

            const SizedBox(height: 24),

            // Community Meet & Greet header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Productivity Hub Community',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Connect and greet other productivity heroes near your level.',
                style: TextStyle(color: Color(0xFF6E7DA7), fontSize: 13),
              ),
            ),
            const SizedBox(height: 14),

            // Community list
            _buildCommunityHub(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStatusCard(double xpPercentage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E38), Color(0xFF2C2C54)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E38).withValues(alpha: (0.4)),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar selector trigger
              GestureDetector(
                onTap: _showAvatarSelector,
                child: Stack(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C77F2).withValues(alpha: (0.15)),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF7C77F2), width: 3),
                      ),
                      child: Center(
                        child: Text(
                          _selectedAvatar['emoji']!,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF7C77F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Samira Rashid',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C77F2).withValues(alpha: (0.24)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Class: ${_selectedAvatar['name']}',
                        style: const TextStyle(
                          color: Color(0xFFB5B3FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Perk: ${_selectedAvatar['perk']}',
                      style: const TextStyle(color: Color(0xFF9AA5CA), fontSize: 11),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP Bar and Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LEVEL $_level',
                style: const TextStyle(
                  color: Color(0xFF7C77F2),
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '$_currentXp / $_xpForNextLevel XP',
                style: const TextStyle(
                  color: Color(0xFF9AA5CA),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: xpPercentage,
              minHeight: 12,
              color: const Color(0xFF7C77F2),
              backgroundColor: const Color(0xFF2D3748),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRewardsGrid() {
    final List<Map<String, dynamic>> rewards = [
      {
        'title': 'Flame Lord',
        'sub': '5 Daily Streak',
        'desc': 'Unlocked +10% focus stamina',
        'color': const Color(0xFFFF5252),
        'bg': const Color(0xFFFFF1F1),
        'icon': Icons.local_fire_department_rounded,
        'level': 'Lv.3',
      },
      {
        'title': 'Habit Crusher',
        'sub': '86% Habits Completed',
        'desc': 'Unlocked +15% productivity multiplier',
        'color': const Color(0xFF7C77F2),
        'bg': const Color(0xFFF1F0FF),
        'icon': Icons.checklist_rtl_rounded,
        'level': 'Lv.5',
      },
      {
        'title': 'Goal Annihilator',
        'sub': '10 Goals Crushed',
        'desc': 'Unlocked Gold Crown cosmetic badge',
        'color': const Color(0xFF00BFA5),
        'bg': const Color(0xFFE9FCF8),
        'icon': Icons.emoji_events_rounded,
        'level': 'Lv.2',
      },
      {
        'title': 'Dreamwalker',
        'sub': '60% Vision Active',
        'desc': 'Unlocked reality Manifest speed (+12%)',
        'color': const Color(0xFFFFB74D),
        'bg': const Color(0xFFFFF8EE),
        'icon': Icons.explore_rounded,
        'level': 'Lv.4',
      },
      {
        'title': 'Zen Screen Shield',
        'sub': '-2.4 Hours Screen Time',
        'desc': 'Unlocked +25% Attention span shield',
        'color': const Color(0xFF26C6DA),
        'bg': const Color(0xFFECFCFF),
        'icon': Icons.phonelink_erase_rounded,
        'level': 'Lv.2',
      },
      {
        'title': 'Wallet Builder',
        'sub': 'Savings rate 45%',
        'desc': 'Unlocked compound interest multiplier',
        'color': const Color(0xFFEC407A),
        'bg': const Color(0xFFFFF0F5),
        'icon': Icons.account_balance_wallet_rounded,
        'level': 'Lv.3',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final color = reward['color'] as Color;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: (0.02)),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: color.withValues(alpha: (0.15)),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: reward['bg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(reward['icon'] as IconData, color: color, size: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: (0.08)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        reward['level']!,
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  reward['title']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reward['sub']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5F6E8A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward['desc']!,
                  style: TextStyle(
                    fontSize: 8.5,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommunityHub() {
    final List<Map<String, dynamic>> users = [
      {
        'name': 'Aria Chen',
        'level': 'Lv.22',
        'emoji': '🧘‍♀️',
        'streak': '12 Days',
        'goal': 'Finish Flutter codebase layout',
      },
      {
        'name': 'David Miller',
        'level': 'Lv.18',
        'emoji': '🏃‍♂️',
        'streak': '8 Days',
        'goal': '15k steps strength training',
      },
      {
        'name': 'Sophia Lopez',
        'level': 'Lv.31',
        'emoji': '🦉',
        'streak': '25 Days',
        'goal': 'Meditate 20 mins every morning',
      },
      {
        'name': 'Marcus Aurelius',
        'level': 'Lv.99',
        'emoji': '🦉',
        'streak': '1,000 Days',
        'goal': 'Stoic Calmness in work focus',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: (0.02)),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        user['emoji']!,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user['level']!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF6E7DA7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Active Streak: ${user['streak']}',
                          style: const TextStyle(
                            color: Color(0xFF7C77F2),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🎯 Goal: ${user['goal']}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF5F6E8A),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildCommunityAction(
                    'Greet 👋',
                    const Color(0xFF7C77F2),
                    () {
                      setState(() {
                        _currentXp += 50; // Reward for social greeting!
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF7C77F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          content: Text(
                            'You greeted ${user['name']}! Let\'s build positive routines together. +50 XP',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildCommunityAction(
                    'Nudge ⚡',
                    const Color(0xFFFFB74D),
                    () {
                      setState(() {
                        _currentXp += 30; // Reward for nudging!
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFFFFB74D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          content: Text(
                            'Nudged ${user['name']}! Reminding them to complete today\'s actions. +30 XP',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildCommunityAction(
                    'Challenge ⚔️',
                    const Color(0xFF00BFA5),
                    () {
                      setState(() {
                        _currentXp += 80;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF00BFA5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          content: Text(
                            'Challenged ${user['name']} to a 7-day habit duel! +80 XP',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommunityAction(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: (0.1)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: (0.3)), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
