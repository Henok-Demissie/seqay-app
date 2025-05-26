import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/subject.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.background.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Study',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Choose a subject to start learning',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                  ),
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSubjectCard(
                    context,
                    subjects[index],
                    index,
                  ),
                  childCount: subjects.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject, int index) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, subject.route);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                        child: SvgPicture.asset(
                          subject.iconPath,
                          width: 50,
                          height: 50,
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to explore',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index), duration: const Duration(milliseconds: 400))
        .slideY(begin: 0.2, delay: Duration(milliseconds: 100 * index), duration: const Duration(milliseconds: 400))
        .scale(begin: const Offset(0.95, 0.95), duration: const Duration(milliseconds: 300));
  }
}

final subjects = [
  Subject(
      name: 'Applied Math', route: '/math', iconPath: 'assets/icons/math.svg'),
  Subject(
      name: 'Physics', route: '/physics', iconPath: 'assets/icons/physics.svg'),
  Subject(
      name: 'Chemistry',
      route: '/chemistry',
      iconPath: 'assets/icons/chemistry.svg'),
  Subject(
      name: 'English', route: '/english', iconPath: 'assets/icons/english.svg'),
  Subject(
      name: 'Civics', route: '/civics', iconPath: 'assets/icons/civics.svg'),
  Subject(
      name: 'Python', route: '/Python', iconPath: 'assets/icons/civics.svg'),
];
