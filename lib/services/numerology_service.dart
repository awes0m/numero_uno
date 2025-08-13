// ---------------------------- numerology_service.dart ----------------------------

import '../models/numerology_result.dart';

/// NumerologyService - computes numerology core numbers and compatibility.
class NumerologyService {
  static const String pYTHAGOREAN = 'p';
  static const String cHALDEAN = 'c';

  static final Map<String, Map<String, int>> _mappings = {
    pYTHAGOREAN: {
      'A': 1,
      'B': 2,
      'C': 3,
      'D': 4,
      'E': 5,
      'F': 6,
      'G': 7,
      'H': 8,
      'I': 9,
      'J': 1,
      'K': 2,
      'L': 3,
      'M': 4,
      'N': 5,
      'O': 6,
      'P': 7,
      'Q': 8,
      'R': 9,
      'S': 1,
      'T': 2,
      'U': 3,
      'V': 4,
      'W': 5,
      'X': 6,
      'Y': 7,
      'Z': 8,
    },
    cHALDEAN: {
      'A': 1,
      'B': 2,
      'C': 3,
      'D': 4,
      'E': 5,
      'F': 8,
      'G': 3,
      'H': 5,
      'I': 1,
      'J': 1,
      'K': 2,
      'L': 3,
      'M': 4,
      'N': 5,
      'O': 7,
      'P': 8,
      'Q': 1,
      'R': 2,
      'S': 3,
      'T': 4,
      'U': 6,
      'V': 6,
      'W': 6,
      'X': 5,
      'Y': 1,
      'Z': 7,
    },
  };

  static const Set<String> _vowels = {'A', 'E', 'I', 'O', 'U', 'Y'};

  static int reduceNumber(int value) {
    if (value == 11 || value == 22 || value == 33) return value;
    var v = value.abs();
    while (v > 9) {
      int sum = 0;
      while (v > 0) {
        sum += v % 10;
        v ~/= 10;
      }
      v = sum;
      if (v == 11 || v == 22 || v == 33) return v;
    }
    return v;
  }

  static bool _isLetter(String ch) => RegExp(r'^[A-Z]$').hasMatch(ch);

  static Map<String, List<int>> mapLetters(
    String name, {
    String system = pYTHAGOREAN,
  }) {
    final mapping = _mappings[system] ?? _mappings[pYTHAGOREAN]!;
    final all = <int>[];
    final vowels = <int>[];
    final consonants = <int>[];
    final normalized = name.toUpperCase();
    for (var i = 0; i < normalized.length; i++) {
      final ch = normalized[i];
      if (_isLetter(ch)) {
        final val = mapping[ch] ?? 0;
        all.add(val);
        if (_vowels.contains(ch)) {
          vowels.add(val);
        } else {
          consonants.add(val);
        }
      }
    }
    return {'all': all, 'vowels': vowels, 'consonants': consonants};
  }

  static Map<int, int> buildLoshuGrid(DateTime dob) {
    final s =
        dob.day.toString().padLeft(2, '0') +
        dob.month.toString().padLeft(2, '0') +
        dob.year.toString();
    final counts = {for (var e in List.generate(9, (i) => i + 1)) e: 0};
    for (var i = 0; i < s.length; i++) {
      final ch = int.tryParse(s[i]);
      if (ch != null && ch >= 1 && ch <= 9) {
        counts[ch] = counts[ch]! + 1;
      }
    }
    return counts;
  }

  static int computeHiddenPassion(List<int> values) {
    if (values.isEmpty) return 0;
    final freq = <int, int>{};
    for (var v in values) {
      freq[v] = (freq[v] ?? 0) + 1;
    }
    int bestDigit = values.first;
    int bestCount = 0;
    freq.forEach((digit, count) {
      if (count > bestCount || (count == bestCount && digit > bestDigit)) {
        bestCount = count;
        bestDigit = digit;
      }
    });
    return bestDigit;
  }

  static List<int> computeKarmicLessons(List<int> values) {
    final present = Set<int>.from(values);
    final missing = <int>[];
    for (var i = 1; i <= 9; i++) {
      if (!present.contains(i)) missing.add(i);
    }
    return missing;
  }

  static List<int> detectKarmicDebts(Map<String, int> rawTotals) {
    final debts = <int>[];
    const candidates = {13, 14, 16, 19};
    rawTotals.forEach((k, v) {
      if (candidates.contains(v)) debts.add(v);
    });
    return debts.toSet().toList();
  }

  static int _sumList(List<int> l) => l.fold(0, (p, e) => p + e);

  /// Number meanings 1..9 and masters + karmic debt meanings.
  static final Map<int, String> numberMeanings = {
    1: 'Leadership, initiative, individuality, pioneering spirit.',
    2: 'Cooperation, diplomacy, partnership, sensitivity.',
    3: 'Communication, creativity, social expression.',
    4: 'Practicality, discipline, building foundations.',
    5: 'Freedom, change, adventure, adaptability.',
    6: 'Responsibility, family, nurturing, service.',
    7: 'Introspection, analysis, spiritual seeking.',
    8: 'Power, material success, authority, business acumen.',
    9: 'Compassion, completion, global consciousness, artistry.',
    11: 'Master teacher, intuition, inspiration, higher ideals.',
    22: 'Master builder, large-scale manifestation, leadership in service.',
    33: 'Master teacher of compassion and healing (rare).',
  };

  // Essence meanings (1..9 and master numbers)
  static final Map<int, String> essenceMeanings = {
    1: 'Personal identity surge, initiative, asserting yourself, starting fresh.',
    2: 'Cooperation, sensitivity, patience, tending to relationships.',
    3: 'Expression, creativity, socializing, optimism and visibility.',
    4: 'Work, structure, discipline, building reliable foundations.',
    5: 'Change, flexibility, travel, freedom to explore and adapt.',
    6: 'Responsibility, service, family matters, healing and care.',
    7: 'Introspection, study, spiritual seeking, refining inner life.',
    8: 'Ambition, career progress, material results, leadership.',
    9: 'Completion, compassion, releasing the old, humanitarian focus.',
    11: 'Heightened intuition, inspiration, spiritual illumination.',
    22: 'Vision into action, building significant long-term structures.',
    33: 'Compassionate service, healing, teaching with heart-centered focus.'
  };

  static String getEssenceMeaning(int number) {
    return essenceMeanings[number] ?? 'Unique essence energy and focus.';
  }

  static final Map<int, String> karmicDebtMeanings = {
    13: 'Karmic lesson: learn responsibility and avoid shortcuts.',
    14: 'Karmic lesson: manage freedom and avoid excesses.',
    16: 'Karmic lesson: ego challenge, develop humility.',
    19: 'Karmic lesson: learn humility, not selfishness.',
  };

  /// Calculate full numerology profile
  static NumerologyResult calculate({
    required DateTime dob,
    required String fullName,
    String system = pYTHAGOREAN,
    int yearsOfPersonalData = 10,
  }) {
    final calculatedAt = DateTime.now();
    final letterMap = mapLetters(fullName, system: system);
    final allLetters = List<int>.from(letterMap['all']!);
    final vowels = List<int>.from(letterMap['vowels']!);
    final consonants = List<int>.from(letterMap['consonants']!);

    final rawTotals = <String, int>{};

    final rawLifePath = dob.day + dob.month + dob.year;
    rawTotals['lifePathRaw'] = rawLifePath;
    final lifePathNumber = reduceNumber(rawLifePath);

    final rawBirthday = dob.day;
    rawTotals['birthdayRaw'] = rawBirthday;
    final birthdayNumber = reduceNumber(rawBirthday);

    final rawExpression = _sumList(allLetters);
    rawTotals['expressionRaw'] = rawExpression;
    final expressionNumber = reduceNumber(rawExpression);

    final rawSoulUrge = _sumList(vowels);
    rawTotals['soulUrgeRaw'] = rawSoulUrge;
    final soulUrgeNumber = reduceNumber(rawSoulUrge);

    final rawPersonality = _sumList(consonants);
    rawTotals['personalityRaw'] = rawPersonality;
    final personalityNumber = reduceNumber(rawPersonality);

    final driverNumber = allLetters.isNotEmpty ? allLetters.first : 0;
    final destinyNumber = reduceNumber(rawExpression);

    final loshuGrid = buildLoshuGrid(dob);

    final missingNumbers = computeKarmicLessons(allLetters);
    final magicalNumbers = loshuGrid.entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toList();

    final firstName = fullName.trim().split(' ').first;
    final firstNameVals = mapLetters(firstName, system: system)['all'] ?? [];
    final firstNameNumber = reduceNumber(_sumList(firstNameVals));
    final fullNameNumber = reduceNumber(rawExpression);

    final hiddenPassionNumber = computeHiddenPassion(allLetters);

    final karmicLessons = computeKarmicLessons(allLetters);
    final karmicDebts = detectKarmicDebts({
      'lifePath': rawLifePath,
      'birthday': rawBirthday,
      'expression': rawExpression,
      'soulUrge': rawSoulUrge,
      'personality': rawPersonality,
    });

    final p1 = reduceNumber(dob.month + dob.day);
    final p2 = reduceNumber(dob.day + dob.year);
    final p3 = reduceNumber(p1 + p2);
    final p4 = reduceNumber(dob.month + dob.year);
    final pinnacles = {'p1': p1, 'p2': p2, 'p3': p3, 'p4': p4};

    final c1 = reduceNumber((dob.month - dob.day).abs());
    final c2 = reduceNumber((dob.day - dob.year).abs());
    final c3 = reduceNumber((c1 - c2).abs());
    final c4 = reduceNumber((dob.month - dob.year).abs());
    final challenges = {'c1': c1, 'c2': c2, 'c3': c3, 'c4': c4};

    final currentYear = DateTime.now().year;
    final personalYears = <String, int>{};
    final essences = <String, int>{};
    final nameBase = _sumList(allLetters);
    for (var y = currentYear; y <= currentYear + yearsOfPersonalData - 1; y++) {
      final py = reduceNumber(dob.day + dob.month + y);
      personalYears[y.toString()] = py;
      final yearIndex = (y - dob.year) + 1;
      final enRaw = nameBase + yearIndex;
      essences[y.toString()] = reduceNumber(enRaw);
    }

    final nameCompatibility = <String, dynamic>{
      'overallScore': 85, // Default score for single person analysis
      'rating': 'Excellent',
      'recommendation':
          'Your name carries strong positive energy and aligns well with your life path.',
      'details': <String, dynamic>{
        'lifePath': {
          'score': 90,
          'comment':
              'Your name strongly supports your life path number, indicating good alignment between your identity and purpose.',
        },
        'expression': {
          'score': 85,
          'comment':
              'Your name expression number works harmoniously with your core numbers.',
        },
        'soulUrge': {
          'score': 80,
          'comment':
              'Your name resonates well with your inner desires and motivations.',
        },
        'personality': {
          'score': 85,
          'comment':
              'Your name projects a personality that aligns with your true nature.',
        },
      },
      'recommendations': [
        'Your name carries positive numerological energy',
        'Consider using your full name in important documents',
        'The vibration of your name supports your life goals',
      ],
    };

    final detailedAnalysis = <String, dynamic>{
      'summary':
          'This comprehensive numerology profile reveals your unique spiritual blueprint. Your numbers indicate a person with strong leadership qualities, creative expression, and a deep spiritual connection. The analysis shows a balanced energy distribution with some areas for growth and development.',
      'meanings': {
        'lifePath':
            numberMeanings[lifePathNumber] ??
            'Your life path number represents your journey and purpose in this lifetime.',
        'birthday':
            numberMeanings[birthdayNumber] ??
            'Your birthday number reveals your natural talents and innate abilities.',
        'expression':
            numberMeanings[expressionNumber] ??
            'Your expression number shows how you communicate and express yourself to the world.',
        'soulUrge':
            numberMeanings[soulUrgeNumber] ??
            'Your soul urge number reveals your deepest desires and what truly motivates you.',
        'personality':
            numberMeanings[personalityNumber] ??
            'Your personality number shows how others perceive you and your social persona.',
        'driver':
            'Your driver number represents your basic nature and the energy that drives you forward in life.',
        'destiny':
            'Your destiny number reveals your ultimate life purpose and the path you are meant to follow.',
        'firstName':
            'Your first name number represents your social persona and how you present yourself to others.',
        'fullName':
            'Your full name number represents your complete identity and life mission.',
      },
      'karmicDebts': karmicDebts
          .map(
            (d) => {
              'number': d,
              'meaning':
                  karmicDebtMeanings[d] ??
                  'This karmic debt number indicates a spiritual lesson to be learned in this lifetime.',
            },
          )
          .toList(),
      'pinnacles': pinnacles,
      'challenges': challenges,
      'loshu': loshuGrid,
      'lifePathAnalysis':
          'Your life path number $lifePathNumber indicates a person who ${_getLifePathDescription(lifePathNumber)}. This number guides your major life decisions and reveals your core purpose.',
      'expressionAnalysis':
          'Your expression number $expressionNumber shows that you ${_getExpressionDescription(expressionNumber)}. This influences how you communicate and express your ideas.',
      'soulUrgeAnalysis':
          'Your soul urge number $soulUrgeNumber reveals that you ${_getSoulUrgeDescription(soulUrgeNumber)}. Understanding this helps align your actions with your true desires.',
      'personalityAnalysis':
          'Your personality number $personalityNumber indicates that others see you as someone who ${_getPersonalityDescription(personalityNumber)}. This affects your social interactions.',
      'karmicLessonsAnalysis': karmicLessons.isNotEmpty
          ? 'Your missing numbers ${karmicLessons.join(", ")} represent areas where you need to develop and grow spiritually. These are your karmic lessons for this lifetime.'
          : 'You have a balanced distribution of numbers, indicating good spiritual foundation and fewer major karmic lessons to learn.',
      'loshuAnalysis':
          'Your Loshu grid shows a ${_getLoshuDistributionDescription(loshuGrid)} distribution of numbers, indicating ${_getLoshuMeaning(loshuGrid)}.',
      'pinnaclesAnalysis':
          'Your life pinnacles occur at ages ${_getPinnacleAges(pinnacles)}. These are periods of great opportunity and growth.',
      'challengesAnalysis':
          'Your life challenges occur at ages ${_getChallengeAges(challenges)}. These periods require extra effort and resilience.',
    };

    return NumerologyResult(
      lifePathNumber: lifePathNumber,
      birthdayNumber: birthdayNumber,
      expressionNumber: expressionNumber,
      soulUrgeNumber: soulUrgeNumber,
      personalityNumber: personalityNumber,
      fullName: fullName,
      dateOfBirth: dob,
      calculatedAt: calculatedAt,
      driverNumber: driverNumber,
      destinyNumber: destinyNumber,
      loshuGrid: loshuGrid,
      missingNumbers: missingNumbers,
      magicalNumbers: magicalNumbers,
      firstNameNumber: firstNameNumber,
      fullNameNumber: fullNameNumber,
      pinnacles: pinnacles,
      challenges: challenges,
      personalYears: personalYears,
      essences: essences,
      hiddenPassionNumber: hiddenPassionNumber,
      karmicLessons: karmicLessons,
      karmicDebts: karmicDebts,
      nameCompatibility: nameCompatibility,
      detailedAnalysis: detailedAnalysis,
      systemUsed: (system == cHALDEAN ? 'Chaldean' : 'Pythagorean'),
    );
  }

  // ---------------- Compatibility utilities (two-person) ----------------

  /// Basic compatibility score between two core numbers (0..100)
  /// Uses simple rules: same number -> high compatibility, complementary numbers -> good, neutral -> mid, conflicting -> low.
  static int _scorePair(int a, int b) {
    if (a == 0 || b == 0) return 50; // unknown
    if (a == b) return 90;
    final diff = (a - b).abs();
    // small differences are fine
    if (diff == 1 || diff == 2) return 75;
    if (diff == 3) return 60;
    if (diff == 4) return 50;
    if (diff >= 5) return 35;
    return 50;
  }

  /// Compute compatibility between two NumerologyResult objects
  /// Returns a map with section scores and textual comments.
  static Map<String, dynamic> computeCompatibility(
    NumerologyResult a,
    NumerologyResult b,
  ) {
    final lifePathScore = _scorePair(a.lifePathNumber, b.lifePathNumber);
    final expressionScore = _scorePair(a.expressionNumber, b.expressionNumber);
    final soulUrgeScore = _scorePair(a.soulUrgeNumber, b.soulUrgeNumber);
    final personalityScore = _scorePair(
      a.personalityNumber,
      b.personalityNumber,
    );

    final overall =
        ((lifePathScore + expressionScore + soulUrgeScore + personalityScore) /
                4)
            .round();

    String rating;
    if (overall >= 80) {
      rating = 'Excellent';
    } else if (overall >= 65) {
      rating = 'Good';
    } else if (overall >= 50) {
      rating = 'Average';
    } else {
      rating = 'Challenging';
    }

    final details = {
      'lifePath': {
        'score': lifePathScore,
        'comment': _compatComment('Life Path', lifePathScore),
      },
      'expression': {
        'score': expressionScore,
        'comment': _compatComment('Expression', expressionScore),
      },
      'soulUrge': {
        'score': soulUrgeScore,
        'comment': _compatComment('Hearts Desire', soulUrgeScore),
      },
      'personality': {
        'score': personalityScore,
        'comment': _compatComment('Personality', personalityScore),
      },
    };

    return {
      'overallScore': overall,
      'rating': rating,
      'details': details,
      'recommendations': _compatRecommendations(overall, details),
    };
  }

  static String _compatComment(String label, int score) {
    if (score >= 85) {
      return '$label: Strong natural resonance and mutual understanding.';
    }
    if (score >= 70) {
      return '$label: Good compatibility with minor adjustments needed.';
    }
    if (score >= 55) {
      return '$label: Average - requires effort and communication.';
    }
    return '$label: Low compatibility in this area; be aware of potential friction.';
  }

  static List<String> _compatRecommendations(
    int overall,
    Map<String, dynamic> details,
  ) {
    final recs = <String>[];
    if (overall >= 80) {
      recs.add('Lean into shared strengths and plan joint long-term projects.');
    } else if (overall >= 65) {
      recs.add(
        'Discuss expectations openly and allocate roles according to strengths.',
      );
    } else if (overall >= 50) {
      recs.add(
        'Focus on active communication and compromise for recurring issues.',
      );
    } else {
      recs.add(
        'Consider whether the relationship needs structural changes or targeted personal growth.',
      );
    }

    // Add specific suggestions based on weaker scores
    details.forEach((k, v) {
      final score = v['score'] as int;
      if (score < 55) {
        recs.add(
          'Pay special attention to $k — work on understanding each other\'s motivations in this area.',
        );
      }
    });
    return recs;
  }

  // Helper methods for detailed analysis
  static String _getLifePathDescription(int number) {
    switch (number) {
      case 1:
        return 'are a natural leader with strong individuality and pioneering spirit';
      case 2:
        return 'are diplomatic and cooperative, working well with others';
      case 3:
        return 'are creative and communicative, expressing yourself through art and words';
      case 4:
        return 'are practical and disciplined, building solid foundations';
      case 5:
        return 'are adventurous and adaptable, seeking freedom and change';
      case 6:
        return 'are nurturing and responsible, caring for family and community';
      case 7:
        return 'are introspective and analytical, seeking spiritual truth';
      case 8:
        return 'are ambitious and material-minded, achieving success through hard work';
      case 9:
        return 'are compassionate and artistic, serving humanity with wisdom';
      case 11:
        return 'are an intuitive master teacher, inspiring others with higher ideals';
      case 22:
        return 'are a master builder, capable of large-scale manifestation';
      case 33:
        return 'are a master teacher of compassion and healing';
      default:
        return 'have unique qualities that define your life purpose';
    }
  }

  static String _getExpressionDescription(int number) {
    switch (number) {
      case 1:
        return 'express yourself with confidence and authority';
      case 2:
        return 'communicate with sensitivity and diplomacy';
      case 3:
        return 'express yourself creatively and enthusiastically';
      case 4:
        return 'communicate with precision and practicality';
      case 5:
        return 'express yourself with versatility and excitement';
      case 6:
        return 'communicate with warmth and responsibility';
      case 7:
        return 'express yourself with depth and wisdom';
      case 8:
        return 'communicate with authority and business acumen';
      case 9:
        return 'express yourself with compassion and artistic flair';
      case 11:
        return 'communicate with spiritual insight and inspiration';
      case 22:
        return 'express yourself with visionary leadership';
      case 33:
        return 'communicate with divine wisdom and healing energy';
      default:
        return 'have a unique way of expressing yourself to the world';
    }
  }

  static String _getSoulUrgeDescription(int number) {
    switch (number) {
      case 1:
        return 'desire independence and leadership opportunities';
      case 2:
        return 'seek harmony and meaningful partnerships';
      case 3:
        return 'crave creative expression and social interaction';
      case 4:
        return 'desire stability and practical achievement';
      case 5:
        return 'seek adventure and personal freedom';
      case 6:
        return 'desire to care for others and create harmony';
      case 7:
        return 'seek spiritual understanding and inner peace';
      case 8:
        return 'desire material success and recognition';
      case 9:
        return 'seek to serve humanity and express compassion';
      case 11:
        return 'desire to inspire others spiritually';
      case 22:
        return 'seek to build something significant for humanity';
      case 33:
        return 'desire to heal and teach with divine love';
      default:
        return 'have unique inner desires that motivate your actions';
    }
  }

  static String _getPersonalityDescription(int number) {
    switch (number) {
      case 1:
        return 'appear confident, independent, and ambitious';
      case 2:
        return 'seem diplomatic, cooperative, and sensitive';
      case 3:
        return 'appear creative, sociable, and enthusiastic';
      case 4:
        return 'seem practical, reliable, and disciplined';
      case 5:
        return 'appear adventurous, versatile, and exciting';
      case 6:
        return 'seem caring, responsible, and nurturing';
      case 7:
        return 'appear intellectual, spiritual, and reserved';
      case 8:
        return 'seem powerful, authoritative, and business-like';
      case 9:
        return 'appear compassionate, artistic, and wise';
      case 11:
        return 'seem spiritually enlightened and inspiring';
      case 22:
        return 'appear visionary and capable of great achievements';
      case 33:
        return 'seem divinely guided and healing';
      default:
        return 'project a unique personality that others recognize';
    }
  }

  static String _getLoshuDistributionDescription(Map<int, int> loshuGrid) {
    final totalNumbers = loshuGrid.values.fold(0, (sum, count) => sum + count);
    final presentNumbers = loshuGrid.values.where((count) => count > 0).length;

    if (presentNumbers >= 7) return 'comprehensive';
    if (presentNumbers >= 5) return 'balanced';
    if (presentNumbers >= 3) return 'moderate';
    return 'focused';
  }

  static String _getLoshuMeaning(Map<int, int> loshuGrid) {
    final totalNumbers = loshuGrid.values.fold(0, (sum, count) => sum + count);
    final presentNumbers = loshuGrid.values.where((count) => count > 0).length;

    if (presentNumbers >= 7) {
      return 'you have a well-rounded energy distribution with many life experiences';
    } else if (presentNumbers >= 5) {
      return 'you have a balanced approach to life with focused energy';
    } else if (presentNumbers >= 3) {
      return 'you have concentrated energy in specific areas of life';
    } else {
      return 'you have very focused energy, indicating specialization in particular life areas';
    }
  }

  static String _getPinnacleAges(Map<String, int> pinnacles) {
    final ages = <String>[];
    if (pinnacles.containsKey('p1')) ages.add('0-9');
    if (pinnacles.containsKey('p2')) ages.add('10-19');
    if (pinnacles.containsKey('p3')) ages.add('20-29');
    if (pinnacles.containsKey('p4')) ages.add('30+');
    return ages.join(', ');
  }

  static String _getChallengeAges(Map<String, int> challenges) {
    final ages = <String>[];
    if (challenges.containsKey('c1')) ages.add('0-9');
    if (challenges.containsKey('c2')) ages.add('10-19');
    if (challenges.containsKey('c3')) ages.add('20-29');
    if (challenges.containsKey('c4')) ages.add('30+');
    return ages.join(', ');
  }
}
