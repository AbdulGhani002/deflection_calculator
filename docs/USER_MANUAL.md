# Aluminum Deflection Calculator - User Manual

## Introduction

The Aluminum Deflection Calculator helps engineers and technicians quickly determine the maximum deflection (bending) of aluminum profiles under various load conditions. This guide explains how to use the app effectively.

---

## Quick Start

1. **Select a Profile** - Tap the profile card to choose your aluminum profile
2. **Choose Load Type** - Select Point Load or Distributed Load
3. **Select Support Type** - Pick how your beam is supported
4. **Enter Values** - Input the force (N) and beam length (mm)
5. **Read Result** - The deflection is shown in millimeters at the bottom

---

## Understanding the Interface

### 1. Load Type Toggle

Located at the top of the screen, this toggle lets you choose between:

| Load Type | Icon | Description |
|-----------|------|-------------|
| **Point Load** | ● | A single concentrated force applied at the center of the beam |
| **Distributed Load** | ═══ | Force spread evenly along the entire length of the beam |

**When to use Point Load:**
- Weight hanging from the middle of a beam
- A single heavy object placed at center
- Concentrated machinery loads

**When to use Distributed Load:**
- Weight of stored materials along a shelf
- Snow or wind load on a horizontal beam
- Self-weight of the beam itself
- Multiple small loads spread evenly

---

### 2. Support Type Selection

Three support configurations are available:

#### Simple Beam (Pin-Roller)
```
    ↓ Load
    ▼
════════════════════
△                  ○
```
- One end is pinned (can rotate, cannot move)
- Other end is on a roller (can rotate and slide)
- **Most common** in practical applications
- Produces **moderate** deflection

#### Cantilever (Fixed-Free)
```
                ↓ Load
                ▼
█████════════════════
█████
```
- One end is completely fixed (embedded in wall)
- Other end is free to move
- Produces **maximum** deflection
- Used for balconies, diving boards, shelves

#### Fixed-Fixed (Both Ends Fixed)
```
        ↓ Load
        ▼
█████════════████████
█████            █████
```
- Both ends are rigidly fixed
- Cannot rotate or move at either end
- Produces **minimum** deflection
- Used in structural frames, bridge sections

---

### 3. Force and Length Inputs

#### Force (N)
- Enter the applied force in **Newtons**
- For distributed loads, enter the **total** force (not per meter)
- Conversion: 1 kg ≈ 9.81 N (multiply kg by 10 for quick estimate)

**Examples:**
| Weight | Force |
|--------|-------|
| 10 kg | ~100 N |
| 50 kg | ~500 N |
| 100 kg | ~1000 N |

#### Length (mm)
- Enter the beam span in **millimeters**
- This is the distance between supports
- For cantilevers, it's the length from the fixed end to the load point

**Examples:**
| Length | mm |
|--------|-----|
| 50 cm | 500 mm |
| 1 m | 1000 mm |
| 2 m | 2000 mm |

---

### 4. Profile Selector

Tap the profile card to open a list of available aluminum profiles.

Each profile shows:
- **Name**: Profile designation (e.g., "Profile 8 40x40 Light")
- **Category**: Profile series
- **Ix**: Moment of inertia about X-axis (cm⁴)
- **Iy**: Moment of inertia about Y-axis (cm⁴)

#### What is Moment of Inertia?

The moment of inertia (I) describes how resistant a cross-section is to bending:
- **Higher I** = **Less deflection** (stiffer)
- **Lower I** = **More deflection** (more flexible)

For non-square profiles, Ix and Iy differ:
- **Ix**: Resistance to bending when loaded in the vertical direction
- **Iy**: Resistance to bending when loaded in the horizontal direction

**Example**: A 80x40 profile:
- Ix = 65.8 cm⁴ (stronger when standing tall)
- Iy = 18.2 cm⁴ (weaker when lying flat)

---

### 5. Axis Selection (Ix/Iy)

Choose which axis to use for calculation:
- **X-Axis (Ix)**: Use when the load causes bending about the X-axis
- **Y-Axis (Iy)**: Use when the load causes bending about the Y-axis

**Visual Guide:**
```
Load ↓               Load →
     ▼                    ▶
┌────────┐          ┌────────┐
│        │          │        │
│  Use   │          │  Use   │
│   Ix   │          │   Iy   │
│        │          │        │
└────────┘          └────────┘
```

---

### 6. Results Display

The result shows the **maximum deflection** in millimeters.

#### Interpreting Results

| Deflection | Assessment |
|------------|------------|
| < 1 mm | Excellent - Minimal visible bending |
| 1-3 mm | Good - Acceptable for most applications |
| 3-5 mm | Moderate - Consider a stiffer profile |
| > 5 mm | High - May need reinforcement or larger profile |

#### Deflection Limits (General Guidelines)

For structural applications, deflection should typically not exceed:
- **L/200** for general construction
- **L/360** for precision applications
- **L/500** for sensitive equipment support

Where L = span length

**Example**: For a 1000 mm span:
- L/200 = 5 mm maximum
- L/360 = 2.8 mm maximum
- L/500 = 2 mm maximum

---

## Language Settings

Tap the language button (🌐) in the top right corner to switch between:
- **English (EN)**
- **German (DE)**

---

## Formulas Used

The app uses standard engineering formulas:

### Simple Beam
- Point Load: δ = F·L³ / (48·E·I)
- Distributed: δ = 5·F·L³ / (384·E·I)

### Cantilever
- Point Load: δ = F·L³ / (3·E·I)
- Distributed: δ = F·L³ / (8·E·I)

### Fixed-Fixed
- Point Load: δ = F·L³ / (192·E·I)
- Distributed: δ = F·L³ / (384·E·I)

Where:
- **δ** = Deflection (mm)
- **F** = Force (N)
- **L** = Length (mm)
- **E** = Elastic Modulus (70,000 N/mm² for aluminum)
- **I** = Moment of Inertia (mm⁴)

---

## Tips for Accurate Results

1. **Measure Carefully**: Small errors in length significantly affect results (deflection varies with L³)

2. **Account for Safety**: Apply a safety factor (typically 1.5-2x) to your loads

3. **Consider Multiple Loads**: For complex loading, calculate each separately and add the results

4. **Check Both Axes**: For non-square profiles, verify which orientation gives the best result

5. **Temperature Effects**: Aluminum expands with heat; consider thermal effects for outdoor applications

---

## Troubleshooting

### Result shows 0.0000 mm
- Ensure a profile is selected
- Check that force and length values are greater than zero
- Verify the values are entered correctly

### Unexpectedly large deflection
- Check if you're using the correct axis (Ix vs Iy)
- Verify the length is in millimeters, not centimeters
- Consider using a larger/stiffer profile

### App won't load profiles
- Check your internet connection (first load only)
- Restart the app
- Reinstall if the problem persists

---

## Safety Disclaimer

⚠️ **Important**: This calculator is for estimation purposes only. For critical structural applications, always consult a qualified engineer and verify calculations with appropriate safety factors and local building codes.

---

## Need Help?

For technical support or feature requests, please contact the development team or submit an issue on the project repository.
