import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/yantra.dart';

// Data Model for a Yantra

// Main Page Widget
class VedicYantrasPage extends StatelessWidget {
  const VedicYantrasPage({super.key});

  // List of Yantra data
  static final List<Yantra> _yantras = [
    Yantra(
      title: 'सूर्य यंत्र - Surya Yantra',
      purpose: 'For Leadership and Confidence',
      description:
          'Traditional design with 12-petaled lotus, square boundary, and central solar symbol. Enhances vitality, authority, and self-confidence.',
      primaryColor: const Color(0xffFF6B35),
      secondaryColor: const Color(0xffFFD700),
      svgAsset: _suryaYantraSvg,
    ),
    Yantra(
      title: 'चंद्र यंत्र - Chandra Yantra',
      purpose: 'For Emotional Balance and Intuition',
      description:
          'Features crescent moon symbols within circular mandala. Promotes emotional healing, intuitive wisdom, and mental peace.',
      primaryColor: const Color(0xffC0C0C0),
      secondaryColor: const Color(0xffE6E6FA),
      svgAsset: _chandraYantraSvg,
    ),
    Yantra(
      title: 'गुरु यंत्र - Guru Yantra',
      purpose: 'For Wisdom and Creativity',
      description:
          'Sacred geometry with triangular patterns representing divine wisdom. Enhances knowledge, teaching abilities, and spiritual growth.',
      primaryColor: const Color(0xffFFD700),
      secondaryColor: const Color(0xffFF8C00),
      svgAsset: _guruYantraSvg,
    ),
    Yantra(
      title: 'राहु यंत्र - Rahu Yantra',
      purpose: 'For Discipline and Organization',
      description:
          'Mystical design with serpentine patterns representing the shadow planet. Helps overcome obstacles and transforms challenges into opportunities.',
      primaryColor: const Color(0xff4B0082),
      secondaryColor: const Color(0xff8A2BE2),
      svgAsset: _rahuYantraSvg,
    ),
    Yantra(
      title: 'बुध यंत्र - Budh Yantra',
      purpose: 'For Communication and Balance',
      description:
          'Features Mercury\'s astrological symbol with communication rays. Enhances intellect, speech, and business acumen.',
      primaryColor: const Color(0xff32CD32),
      secondaryColor: const Color(0xff90EE90),
      svgAsset: _budhYantraSvg,
    ),
    Yantra(
      title: 'शुक्र यंत्र - Shukra Yantra',
      purpose: 'For Love and Family Harmony',
      description:
          'Eight-petaled lotus design representing love and beauty. Promotes harmony in relationships, artistic talents, and material prosperity.',
      primaryColor: const Color(0xffFF69B4),
      secondaryColor: const Color(0xffFFC0CB),
      svgAsset: _shukraYantraSvg,
    ),
    Yantra(
      title: 'केतु यंत्र - Ketu Yantra',
      purpose: 'For Spiritual Growth and Intuition',
      description:
          'Triangular patterns representing spiritual transformation. Enhances detachment, meditation, and inner wisdom.',
      primaryColor: const Color(0xff8B4513),
      secondaryColor: const Color(0xffDAA520),
      svgAsset: _ketuYantraSvg,
    ),
    Yantra(
      title: 'शनि यंत्र - Shani Yantra',
      purpose: 'For Financial Stability and Discipline',
      description:
          'Structured geometric design emphasizing discipline and order. Brings patience, perseverance, and long-term success.',
      primaryColor: const Color(0xff2F4F4F),
      secondaryColor: const Color(0xff708090),
      svgAsset: _shaniYantraSvg,
    ),
    Yantra(
      title: 'मंगल यंत्र - Mangal Yantra',
      purpose: 'For Energy and Humanitarian Service',
      description:
          'Dynamic triangular patterns representing courage and action. Enhances physical strength, determination, and protective energy.',
      primaryColor: const Color(0xffDC143C),
      secondaryColor: const Color(0xffFF6347),
      svgAsset: _mangalYantraSvg,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1a1a2e), Color(0xff16213e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'नवग्रह यंत्र - Nine Planetary Yantras',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Color(0xffffd700),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Responsive Grid for Yantras
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Adjust cross axis count based on screen width
                    int crossAxisCount = (constraints.maxWidth / 350).floor();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount < 1 ? 1 : crossAxisCount,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        childAspectRatio: 300 / 480, // Adjust aspect ratio
                      ),
                      itemCount: _yantras.length,
                      itemBuilder: (context, index) {
                        return _YantraCard(yantra: _yantras[index]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  'These yantras are based on traditional Vedic designs and sacred geometry principles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffcccccc), fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Consult a qualified astrologer or Vedic practitioner for guidance on using these yantras effectively.', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffcccccc), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Yantra Card Widget
class _YantraCard extends StatelessWidget {
  final Yantra yantra;

  const _YantraCard({required this.yantra});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                yantra.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: yantra.secondaryColor,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                yantra.purpose,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffcccccc),
                ),
              ),
              const SizedBox(height: 20),
              SvgPicture.string(yantra.svgAsset, width: 250, height: 250),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    yantra.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xffe0e0e0),
                      height: 1.4,
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
}

// --- SVG Asset Strings ---
// (SVG strings from the HTML are included here)

const String _suryaYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="suryaGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#ffd700"/>
            <stop offset="100%" style="stop-color:#ff6b35"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#ffd700" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#ff6b35" stroke-width="2"/>
    <circle cx="100" cy="100" r="60" fill="none" stroke="#ffd700" stroke-width="1"/>
    <polygon points="100,40 115,70 145,70 125,90 135,120 100,105 65,120 75,90 55,70 85,70" fill="url(#suryaGrad)" stroke="#ff6b35" stroke-width="1"/>
    <circle cx="100" cy="100" r="20" fill="#ffd700" stroke="#ff6b35" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#ff6b35" font-size="10" font-weight="bold">ॐ</text>
    <g stroke="#ffd700" stroke-width="2">
        <line x1="100" y1="20" x2="100" y2="30"/>
        <line x1="100" y1="170" x2="100" y2="180"/>
        <line x1="20" y1="100" x2="30" y2="100"/>
        <line x1="170" y1="100" x2="180" y2="100"/>
        <line x1="35.86" y1="35.86" x2="42.93" y2="42.93"/>
        <line x1="157.07" y1="157.07" x2="164.14" y2="164.14"/>
        <line x1="164.14" y1="35.86" x2="157.07" y2="42.93"/>
        <line x1="42.93" y1="157.07" x2="35.86" y2="164.14"/>
    </g>
</svg>
''';

const String _chandraYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="chandraGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#e6e6fa"/>
            <stop offset="100%" style="stop-color:#c0c0c0"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#e6e6fa" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#c0c0c0" stroke-width="2"/>
    <circle cx="100" cy="100" r="60" fill="none" stroke="#e6e6fa" stroke-width="1"/>
    <path d="M 70 100 Q 85 80, 100 100 Q 85 120, 70 100" fill="url(#chandraGrad)" stroke="#c0c0c0" stroke-width="1"/>
    <path d="M 130 100 Q 115 80, 100 100 Q 115 120, 130 100" fill="url(#chandraGrad)" stroke="#c0c0c0" stroke-width="1"/>
    <circle cx="100" cy="100" r="25" fill="none" stroke="#e6e6fa" stroke-width="1"/>
    <circle cx="100" cy="100" r="15" fill="#e6e6fa" stroke="#c0c0c0" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#4169e1" font-size="8" font-weight="bold">चं</text>
    <g fill="none" stroke="#c0c0c0" stroke-width="1">
        <ellipse cx="100" cy="60" rx="8" ry="15" transform="rotate(0 100 60)"/>
        <ellipse cx="100" cy="140" rx="8" ry="15" transform="rotate(180 100 140)"/>
        <ellipse cx="60" cy="100" rx="8" ry="15" transform="rotate(90 60 100)"/>
        <ellipse cx="140" cy="100" rx="8" ry="15" transform="rotate(270 140 100)"/>
    </g>
</svg>
''';

const String _guruYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="guruGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#ffd700"/>
            <stop offset="100%" style="stop-color:#ff8c00"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#ffd700" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#ff8c00" stroke-width="2"/>
    <polygon points="100,30 130,70 170,70 140,100 150,140 100,120 50,140 60,100 30,70 70,70" fill="none" stroke="#ffd700" stroke-width="2"/>
    <circle cx="100" cy="100" r="40" fill="none" stroke="#ffd700" stroke-width="1"/>
    <polygon points="100,70 110,85 125,85 115,95 120,110 100,102 80,110 85,95 75,85 90,85" fill="url(#guruGrad)" stroke="#ff8c00" stroke-width="1"/>
    <circle cx="100" cy="100" r="20" fill="#ffd700" stroke="#ff8c00" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#8b4513" font-size="10" font-weight="bold">गुं</text>
    <polygon points="100,50 85,75 115,75" fill="none" stroke="#ffd700" stroke-width="1"/>
    <polygon points="100,150 85,125 115,125" fill="none" stroke="#ffd700" stroke-width="1" transform="rotate(180 100 137.5)"/>
</svg>
''';

const String _rahuYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="rahuGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#8a2be2"/>
            <stop offset="100%" style="stop-color:#4b0082"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#8a2be2" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#4b0082" stroke-width="2"/>
    <path d="M 50 100 Q 75 70, 100 100 Q 125 130, 150 100" fill="none" stroke="#8a2be2" stroke-width="3"/>
    <path d="M 50 100 Q 75 130, 100 100 Q 125 70, 150 100" fill="none" stroke="#8a2be2" stroke-width="3"/>
    <circle cx="100" cy="100" r="50" fill="none" stroke="#4b0082" stroke-width="1"/>
    <circle cx="100" cy="100" r="30" fill="none" stroke="#8a2be2" stroke-width="1"/>
    <polygon points="100,80 110,90 120,85 115,95 125,100 115,105 120,115 110,110 100,120 90,110 80,115 85,105 75,100 85,95 80,85 90,90" fill="url(#rahuGrad)" stroke="#4b0082" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#dda0dd" font-size="8" font-weight="bold">राहु</text>
    <g stroke="#8a2be2" stroke-width="1" fill="none">
        <circle cx="65" cy="65" r="5"/>
        <circle cx="135" cy="65" r="5"/>
        <circle cx="65" cy="135" r="5"/>
        <circle cx="135" cy="135" r="5"/>
    </g>
</svg>
''';

const String _budhYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="budhGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#90ee90"/>
            <stop offset="100%" style="stop-color:#32cd32"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#32cd32" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#32cd32" stroke-width="2"/>
    <circle cx="100" cy="100" r="60" fill="none" stroke="#90ee90" stroke-width="1"/>
    <circle cx="100" cy="90" r="15" fill="none" stroke="#32cd32" stroke-width="2"/>
    <line x1="100" y1="105" x2="100" y2="125" stroke="#32cd32" stroke-width="2"/>
    <line x1="90" y1="115" x2="110" y2="115" stroke="#32cd32" stroke-width="2"/>
    <path d="M 90 75 Q 100 65, 110 75" fill="none" stroke="#32cd32" stroke-width="2"/>
    <polygon points="100,45 115,60 130,50 125,70 140,80 120,85 125,105 100,95 75,105 80,85 60,80 75,70 70,50 85,60" fill="none" stroke="#90ee90" stroke-width="1"/>
    <circle cx="100" cy="100" r="35" fill="none" stroke="#32cd32" stroke-width="1"/>
    <text x="100" y="150" text-anchor="middle" fill="#228b22" font-size="8" font-weight="bold">बुधं</text>
    <g stroke="#90ee90" stroke-width="1">
        <line x1="70" y1="70" x2="80" y2="80"/>
        <line x1="120" y1="80" x2="130" y2="70"/>
        <line x1="70" y1="130" x2="80" y2="120"/>
        <line x1="120" y1="120" x2="130" y2="130"/>
    </g>
</svg>
''';

const String _shukraYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="shukraGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#ffc0cb"/>
            <stop offset="100%" style="stop-color:#ff69b4"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#ff69b4" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#ff69b4" stroke-width="2"/>
    <circle cx="100" cy="85" r="20" fill="none" stroke="#ff69b4" stroke-width="2"/>
    <line x1="100" y1="105" x2="100" y2="130" stroke="#ff69b4" stroke-width="2"/>
    <line x1="85" y1="120" x2="115" y2="120" stroke="#ff69b4" stroke-width="2"/>
    <g fill="url(#shukraGrad)" stroke="#ff69b4" stroke-width="1">
        <ellipse cx="100" cy="50" rx="10" ry="20"/>
        <ellipse cx="100" cy="150" rx="10" ry="20"/>
        <ellipse cx="50" cy="100" rx="20" ry="10"/>
        <ellipse cx="150" cy="100" rx="20" ry="10"/>
        <ellipse cx="70" cy="70" rx="12" ry="18" transform="rotate(45 70 70)"/>
        <ellipse cx="130" cy="70" rx="12" ry="18" transform="rotate(-45 130 70)"/>
        <ellipse cx="70" cy="130" rx="12" ry="18" transform="rotate(-45 70 130)"/>
        <ellipse cx="130" cy="130" rx="12" ry="18" transform="rotate(45 130 130)"/>
    </g>
    <circle cx="100" cy="100" r="50" fill="none" stroke="#ffc0cb" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#dc143c" font-size="8" font-weight="bold">शुं</text>
</svg>
''';

const String _ketuYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="ketuGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#daa520"/>
            <stop offset="100%" style="stop-color:#8b4513"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#daa520" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#8b4513" stroke-width="2"/>
    <polygon points="100,40 130,90 70,90" fill="none" stroke="#daa520" stroke-width="2"/>
    <polygon points="100,160 70,110 130,110" fill="none" stroke="#daa520" stroke-width="2"/>
    <polygon points="40,100 90,70 90,130" fill="none" stroke="#8b4513" stroke-width="2"/>
    <polygon points="160,100 110,130 110,70" fill="none" stroke="#8b4513" stroke-width="2"/>
    <circle cx="100" cy="100" r="40" fill="none" stroke="#daa520" stroke-width="1"/>
    <polygon points="100,80 110,95 125,90 115,105 120,120 100,112 80,120 85,105 75,90 90,95" fill="url(#ketuGrad)" stroke="#8b4513" stroke-width="1"/>
    <circle cx="100" cy="100" r="15" fill="#daa520" stroke="#8b4513" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#2f4f4f" font-size="8" font-weight="bold">केतु</text>
    <g stroke="#daa520" stroke-width="1" fill="none">
        <circle cx="100" cy="60" r="3"/>
        <circle cx="100" cy="140" r="3"/>
        <circle cx="60" cy="100" r="3"/>
        <circle cx="140" cy="100" r="3"/>
    </g>
</svg>
''';

const String _shaniYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="shaniGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#708090"/>
            <stop offset="100%" style="stop-color:#2f4f4f"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#708090" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#2f4f4f" stroke-width="2"/>
    <line x1="100" y1="70" x2="100" y2="100" stroke="#708090" stroke-width="3"/>
    <line x1="85" y1="85" x2="115" y2="85" stroke="#708090" stroke-width="3"/>
    <path d="M 115 85 Q 125 75, 130 85 Q 125 95, 115 90" fill="none" stroke="#708090" stroke-width="2"/>
    <rect x="60" y="60" width="80" height="80" fill="none" stroke="#2f4f4f" stroke-width="2"/>
    <rect x="75" y="75" width="50" height="50" fill="none" stroke="#708090" stroke-width="1"/>
    <circle cx="100" cy="100" r="20" fill="url(#shaniGrad)" stroke="#2f4f4f" stroke-width="1"/>
    <text x="100" y="105" text-anchor="middle" fill="#f5f5dc" font-size="8" font-weight="bold">शं</text>
    <g stroke="#708090" stroke-width="1" fill="none">
        <line x1="40" y1="40" x2="50" y2="50"/>
        <line x1="150" y1="50" x2="160" y2="40"/>
        <line x1="40" y1="160" x2="50" y2="150"/>
        <line x1="150" y1="150" x2="160" y2="160"/>
    </g>
</svg>
''';

const String _mangalYantraSvg = '''
<svg viewBox="0 0 200 200">
    <defs>
        <radialGradient id="mangalGrad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#ff6347"/>
            <stop offset="100%" style="stop-color:#dc143c"/>
        </radialGradient>
    </defs>
    <rect x="10" y="10" width="180" height="180" fill="none" stroke="#dc143c" stroke-width="2"/>
    <circle cx="100" cy="100" r="80" fill="none" stroke="#dc143c" stroke-width="2"/>
    <circle cx="90" cy="110" r="18" fill="none" stroke="#dc143c" stroke-width="2"/>
    <line x1="105" y1="95" x2="125" y2="75" stroke="#dc143c" stroke-width="3"/>
    <polygon points="120,70 125,75 120,80" fill="#dc143c" stroke="#dc143c" stroke-width="1"/>
    <polygon points="115,75 125,75 120,85" fill="#dc143c" stroke="#dc143c" stroke-width="1"/>
    <polygon points="100,50 120,80 80,80" fill="none" stroke="#ff6347" stroke-width="2"/>
    <polygon points="100,150 80,120 120,120" fill="none" stroke="#ff6347" stroke-width="2"/>
    <polygon points="50,100 80,80 80,120" fill="none" stroke="#ff6347" stroke-width="2"/>
    <polygon points="150,100 120,120 120,80" fill="none" stroke="#ff6347" stroke-width="2"/>
    <circle cx="100" cy="100" r="45" fill="none" stroke="#ff6347" stroke-width="1"/>
    <polygon points="100,85 105,95 115,95 107,103 110,113 100,108 90,113 93,103 85,95 95,95" fill="url(#mangalGrad)" stroke="#dc143c" stroke-width="1"/>
    <text x="100" y="140" text-anchor="middle" fill="#8b0000" font-size="8" font-weight="bold">मंगल</text>
</svg>
''';
