// ---------------------------- ai_share_service.dart ----------------------------
import 'package:intl/intl.dart';
import '../models/numerology_result.dart';
import '../models/dual_numerology_result.dart';

/// Service for generating AI-friendly numerology data for sharing with LLM engines
class AiShareService {
  /// Generate comprehensive AI-friendly text for numerology analysis
  static String generateAiPrompt(
    NumerologyResult result,
    DualNumerologyResult? dualResult,
  ) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;
    final currentMonth = currentDate.month;
    final currentDay = currentDate.day;

    final buffer = StringBuffer();

    // AI Prompt Header
    buffer.writeln('=== NUMEROLOGY ANALYSIS REQUEST ===');
    buffer.writeln();
    buffer.writeln(
      'Please analyze the following comprehensive numerology data and provide:',
    );
    buffer.writeln('1. Current day/month/year fortune and energy forecast');
    buffer.writeln('2. Detailed personality insights based on the numbers');
    buffer.writeln('3. Life path guidance and recommendations');
    buffer.writeln('4. Compatibility insights for relationships and career');
    buffer.writeln('5. Predictions and opportunities for the coming months');
    buffer.writeln('6. Karmic lessons and spiritual growth areas');
    buffer.writeln('7. Lucky numbers, colors, and favorable dates');
    buffer.writeln('8. Challenges to be aware of and how to overcome them');
    buffer.writeln();
    buffer.writeln('=== PERSONAL INFORMATION ===');
    buffer.writeln('Full Name: ${result.fullName}');
    buffer.writeln('Date of Birth: ${dateFormat.format(result.dateOfBirth)}');
    buffer.writeln('Analysis Date: ${dateFormat.format(result.calculatedAt)}');
    buffer.writeln('Current Date: ${dateFormat.format(currentDate)}');
    buffer.writeln('Numerology System: ${result.systemUsed}');
    buffer.writeln();

    // Core Numbers Section
    buffer.writeln('=== CORE NUMEROLOGY NUMBERS ===');
    buffer.writeln('Life Path Number: ${result.lifePathNumber}');
    buffer.writeln(
      '  (The most important number - your life\'s purpose and journey)',
    );
    buffer.writeln();
    buffer.writeln('Birthday Number: ${result.birthdayNumber}');
    buffer.writeln('  (Special talents and abilities you were born with)');
    buffer.writeln();
    buffer.writeln('Expression Number: ${result.expressionNumber}');
    buffer.writeln(
      '  (Your natural talents and what you\'re meant to accomplish)',
    );
    buffer.writeln();
    buffer.writeln('Soul Urge Number: ${result.soulUrgeNumber}');
    buffer.writeln('  (Your heart\'s desire and inner motivation)');
    buffer.writeln();
    buffer.writeln('Personality Number: ${result.personalityNumber}');
    buffer.writeln('  (How others perceive you and your outer personality)');
    buffer.writeln();

    // Additional Core Numbers
    buffer.writeln('=== ADDITIONAL CORE NUMBERS ===');
    buffer.writeln('Driver Number: ${result.driverNumber}');
    buffer.writeln('  (Your driving force and motivation)');
    buffer.writeln();
    buffer.writeln('Destiny Number: ${result.destinyNumber}');
    buffer.writeln('  (Your ultimate life goal and destiny)');
    buffer.writeln();
    buffer.writeln('Hidden Passion Number: ${result.hiddenPassionNumber}');
    buffer.writeln('  (Your secret desire and hidden talent)');
    buffer.writeln();
    buffer.writeln('First Name Number: ${result.firstNameNumber}');
    buffer.writeln('Full Name Number: ${result.fullNameNumber}');
    buffer.writeln();

    // Loshu Grid Analysis
    buffer.writeln('=== LOSHU GRID ANALYSIS ===');
    buffer.writeln('Birth Date Number Distribution:');
    final sortedGridEntries = result.loshuGrid.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in sortedGridEntries) {
      buffer.writeln('Number ${entry.key}: appears ${entry.value} time(s)');
    }
    buffer.writeln();

    if (result.magicalNumbers.isNotEmpty) {
      buffer.writeln(
        'Magical Numbers (appearing 3+ times): ${result.magicalNumbers.join(", ")}',
      );
      buffer.writeln(
        '  (These numbers have special power and significance in your life)',
      );
      buffer.writeln();
    }

    if (result.missingNumbers.isNotEmpty) {
      buffer.writeln('Missing Numbers: ${result.missingNumbers.join(", ")}');
      buffer.writeln(
        '  (Areas of challenge or lessons to learn in this lifetime)',
      );
      buffer.writeln();
    }

    // Karmic Information
    buffer.writeln('=== KARMIC ANALYSIS ===');
    if (result.karmicDebts.isNotEmpty) {
      buffer.writeln('Karmic Debt Numbers: ${result.karmicDebts.join(", ")}');
      buffer.writeln('  (Past life lessons that need to be resolved)');
      buffer.writeln();
    }

    if (result.karmicLessons.isNotEmpty) {
      buffer.writeln(
        'Karmic Lesson Numbers: ${result.karmicLessons.join(", ")}',
      );
      buffer.writeln('  (Skills and qualities to develop in this lifetime)');
      buffer.writeln();
    }

    // Life Cycles - Pinnacles and Challenges
    buffer.writeln('=== LIFE CYCLES ===');
    if (result.pinnacles.isNotEmpty) {
      buffer.writeln('Pinnacle Numbers (Life Achievements):');
      final sortedPinnacles = result.pinnacles.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final pinnacle in sortedPinnacles) {
        buffer.writeln('  ${pinnacle.key}: ${pinnacle.value}');
      }
      buffer.writeln();
    }

    if (result.challenges.isNotEmpty) {
      buffer.writeln('Challenge Numbers (Life Lessons):');
      final sortedChallenges = result.challenges.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final challenge in sortedChallenges) {
        buffer.writeln('  ${challenge.key}: ${challenge.value}');
      }
      buffer.writeln();
    }

    // Current Year Analysis
    buffer.writeln('=== CURRENT TIMING ANALYSIS ===');
    final currentYearStr = currentYear.toString();
    if (result.personalYears.containsKey(currentYearStr)) {
      buffer.writeln(
        'Current Personal Year ($currentYear): ${result.personalYears[currentYearStr]}',
      );
      buffer.writeln('  (The energy and theme for this entire year)');
      buffer.writeln();
    }

    if (result.essences.containsKey(currentYearStr)) {
      buffer.writeln(
        'Current Essence Number ($currentYear): ${result.essences[currentYearStr]}',
      );
      buffer.writeln('  (The underlying spiritual influence for this year)');
      buffer.writeln();
    }

    // Multi-year forecast if available
    if (result.personalYears.isNotEmpty) {
      buffer.writeln('Personal Year Forecast:');
      final sortedYears = result.personalYears.entries.toList()
        ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));

      for (final year in sortedYears) {
        final yearInt = int.parse(year.key);
        if (yearInt >= currentYear - 1 && yearInt <= currentYear + 3) {
          final status = yearInt == currentYear
              ? ' (CURRENT)'
              : yearInt < currentYear
              ? ' (Past)'
              : ' (Future)';
          buffer.writeln('  ${year.key}: Personal Year ${year.value}$status');
        }
      }
      buffer.writeln();
    }

    // Name Compatibility Analysis
    if (result.nameCompatibility.isNotEmpty) {
      buffer.writeln('=== NAME COMPATIBILITY ANALYSIS ===');
      result.nameCompatibility.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
      buffer.writeln();
    }

    // Detailed Analysis
    if (result.detailedAnalysis.isNotEmpty) {
      buffer.writeln('=== DETAILED INSIGHTS ===');
      result.detailedAnalysis.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
      buffer.writeln();
    }

    // System Comparison (if dual results available)
    if (dualResult != null && dualResult.hasBothResults) {
      buffer.writeln('=== SYSTEM COMPARISON ===');
      buffer.writeln(
        'This analysis includes both Pythagorean and Chaldean systems:',
      );
      buffer.writeln();

      final pythagorean = dualResult.pythagoreanResult!;
      final chaldean = dualResult.chaldeanResult!;

      buffer.writeln('PYTHAGOREAN vs CHALDEAN COMPARISON:');
      buffer.writeln(
        'Life Path: ${pythagorean.lifePathNumber} vs ${chaldean.lifePathNumber}',
      );
      buffer.writeln(
        'Expression: ${pythagorean.expressionNumber} vs ${chaldean.expressionNumber}',
      );
      buffer.writeln(
        'Soul Urge: ${pythagorean.soulUrgeNumber} vs ${chaldean.soulUrgeNumber}',
      );
      buffer.writeln(
        'Personality: ${pythagorean.personalityNumber} vs ${chaldean.personalityNumber}',
      );
      buffer.writeln();
      buffer.writeln(
        'Please analyze the differences and provide insights on which system resonates more strongly.',
      );
      buffer.writeln();
    }

    // Current Date Specific Analysis Request
    buffer.writeln('=== SPECIFIC ANALYSIS REQUEST FOR TODAY ===');
    buffer.writeln('Today\'s Date: $currentDay/$currentMonth/$currentYear');
    buffer.writeln();
    buffer.writeln('Please provide specific insights for:');
    buffer.writeln('1. Today\'s energy and opportunities');
    buffer.writeln('2. This month\'s focus and themes');
    buffer.writeln('3. This year\'s major lessons and growth areas');
    buffer.writeln('4. Favorable dates and periods in the coming months');
    buffer.writeln('5. Relationships and compatibility insights');
    buffer.writeln('6. Career and financial guidance');
    buffer.writeln('7. Health and wellness recommendations');
    buffer.writeln('8. Spiritual development suggestions');
    buffer.writeln();

    // Footer
    buffer.writeln('=== END OF NUMEROLOGY DATA ===');
    buffer.writeln();
    buffer.writeln(
      'Please provide a comprehensive, insightful analysis that combines traditional numerology wisdom with practical guidance for modern life. Focus on actionable advice and specific predictions that can help guide important decisions and personal growth.',
    );

    return buffer.toString();
  }

  /// Generate a shorter, focused AI prompt for quick insights
  static String generateQuickAiPrompt(NumerologyResult result) {
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return '''
=== QUICK NUMEROLOGY ANALYSIS REQUEST ===

Name: ${result.fullName}
Birth Date: ${dateFormat.format(result.dateOfBirth)}
Today: ${dateFormat.format(currentDate)}

Core Numbers:
• Life Path: ${result.lifePathNumber}
• Expression: ${result.expressionNumber}
• Soul Urge: ${result.soulUrgeNumber}
• Personality: ${result.personalityNumber}
• Birthday: ${result.birthdayNumber}

Please provide:
1. Today's energy forecast
2. This month's opportunities
3. Key personality insights
4. Current life phase guidance
5. Lucky numbers and favorable dates

Keep the analysis concise but insightful, focusing on practical guidance for the current time period.
''';
  }

  /// Generate AI prompt specifically for relationship compatibility
  static String generateCompatibilityPrompt(
    NumerologyResult result,
    String partnerName,
    DateTime? partnerBirthDate,
  ) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final buffer = StringBuffer();

    buffer.writeln('=== RELATIONSHIP COMPATIBILITY ANALYSIS REQUEST ===');
    buffer.writeln();
    buffer.writeln('Please analyze the numerological compatibility between:');
    buffer.writeln();
    buffer.writeln('Person 1: ${result.fullName}');
    buffer.writeln('Birth Date: ${dateFormat.format(result.dateOfBirth)}');
    buffer.writeln('Life Path: ${result.lifePathNumber}');
    buffer.writeln('Expression: ${result.expressionNumber}');
    buffer.writeln('Soul Urge: ${result.soulUrgeNumber}');
    buffer.writeln('Personality: ${result.personalityNumber}');
    buffer.writeln();
    buffer.writeln('Person 2: $partnerName');
    if (partnerBirthDate != null) {
      buffer.writeln('Birth Date: ${dateFormat.format(partnerBirthDate)}');
    }
    buffer.writeln();
    buffer.writeln('Please provide insights on:');
    buffer.writeln('1. Overall compatibility percentage and rating');
    buffer.writeln('2. Strengths of this relationship');
    buffer.writeln('3. Potential challenges and how to overcome them');
    buffer.writeln('4. Communication styles and tips');
    buffer.writeln('5. Long-term relationship potential');
    buffer.writeln('6. Best ways to support each other');
    buffer.writeln('7. Favorable dates for important relationship milestones');

    return buffer.toString();
  }

  /// Generate AI prompt for career and business guidance
  static String generateCareerPrompt(NumerologyResult result) {
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return '''
=== CAREER & BUSINESS NUMEROLOGY ANALYSIS REQUEST ===

Name: ${result.fullName}
Birth Date: ${dateFormat.format(result.dateOfBirth)}
Today's Date: ${dateFormat.format(currentDate)}

Key Numbers for Career Analysis:
• Life Path: ${result.lifePathNumber} (Life purpose and career direction)
• Expression: ${result.expressionNumber} (Natural talents and abilities)
• Destiny: ${result.destinyNumber} (Ultimate career goal)
• Hidden Passion: ${result.hiddenPassionNumber} (Secret talents)
• Driver: ${result.driverNumber} (Motivation and drive)

Please provide detailed guidance on:
1. Ideal career paths and industries
2. Natural talents and skills to leverage
3. Leadership style and work preferences
4. Best business partnerships and collaborations
5. Favorable timing for career changes or launches
6. Financial opportunities and wealth-building strategies
7. Professional challenges and how to overcome them
8. Networking and relationship-building advice
9. Optimal work environment and company culture fit
10. Long-term career trajectory and milestones

Focus on practical, actionable career advice based on numerological insights.
''';
  }
}
