# Satellite Propulsion System Design — Phobos Exploration Mission

> A comprehensive preliminary design, trade-off analysis, and system architecture study for a scientific spacecraft mission to Phobos (the Martian moon), developed by aerospace engineering researchers at the Technical University of Munich (TUM).

---

## Mission Profile & Requirements

* **Target Destination:** Phobos (Mars moon)
* **Launch Date & Vehicle:** December 2, 2028, via Ariane 62 launcher from Kourou ($v_\infty = 2\text{ m/s}$).
* **Mass Constraints:** Maximum launch mass limit of **2.6 tons**.
* **Mission Duration:** Minimum 2 years orbiting Phobos, concluding with a controlled de-orbit into the Martian atmosphere.
* **Total $\Delta V$ Budget:** $3,045\text{ m/s}$ distributed across 8 distinct mission maneuvers.
* **Key Constraint:** Mars Orbit Insertion (MOI) maneuver must not exceed **30 minutes**.

---

## System Engineering Methodology & Trade-Off Analyses

To arrive at an optimal design, a rigorous three-tier trade-off process was executed alongside custom MATLAB simulation scripts:

### 1. Zeroth Trade-Off: Electrical vs. Chemical Propulsion
* **Main Engine:** Evaluated high-efficiency electrical thrusters (e.g., RIT 2X, AEPS Hall thrusters), but all failed to meet the strict **30-minute MOI burn time requirement** and had insufficient operational lifetime.
* **Attitude & Orbit Control (AOC):** Assessed electric micro-thrusters (e.g., Enpulsion Micro $R^3$, RIT 10 Evo), which were discarded due to excess dry mass, added complexity (Power Processing Units, Xenon tanks), and unsuitability for short, pulsed attitude control burns.
* **Conclusion:** **Chemical propulsion** was selected for both main and AOC systems.

### 2. First Trade-Off: Green vs. Hydrazine-Based Propellants
Evaluated three bipropellant candidates across 8 weighted criteria (Mass, Volume, Material Compatibility, Hazards, Storability, Ignition/Combustion, Cost, and TRL):
1. **MMH / NTO** (Conventional Storable)
2. **Ethanol / 90% $H_2O_2$** (Green Alternative)
3. **Propylene / $N_2O$** (Green Alternative)
* **Outcome:** While green propellants offer environmental and safety benefits, their lower Technology Readiness Level (TRL), limited COTS main engine availability, and handling challenges led to the selection of **MMH/NTO** as the baseline propellant.

### 3. Second Trade-Off: Thruster & Main Engine Configurations
Compared 6 distinct COTS hardware configurations utilizing MMH/NTO to balance total mass, volume, tank similarity, heritage, and system reliability (minimizing single points of failure by prioritizing single high-thrust main engines where feasible).
* **Selected Configuration:** **High Thrust configuration utilizing 1x Aerojet Rocketdyne R-42 main engine ($890\text{ N}$) and 8x Aerojet Rocketdyne R-6D thrusters ($22\text{ N}$) for AOC and torque compensation.**

---

## Propulsion Subsystem & Modeling

### Tank and Pressurization Modeling
A custom MATLAB simulation was developed to model the thermodynamic, pressure, and temperature behavior of the pressurant and propellant tanks throughout the mission profile:
* **Propellant Tanks:** 2x Ariane Group OST 22/X tanks (capacity ~700 L each).
* **Pressurant Tank:** 1x MT Aerospace PVG Family 80-120 helium tank pressurized up to $276\text{ bar}$.
* **Performance:** Successfully maintains a minimum 50 bar pressure margin over propellant tanks at end-of-life (EOL) to prevent backflow.

### Piping and Instrumentation Diagram (P&ID)
The system architecture incorporates stringent safety and reliability provisions:
* Normally closed pyrotechnic valves and double-seated solenoid latch valves upstream of thrusters to isolate toxic propellants and prevent in-flight leakage.
* Strategic placement of high-pressure and low-pressure filters, check valves, pressure regulators, and single-failure-tolerant pressure transducers.
* Ground service fill, drain, and test ports for safe pre-launch servicing.

---

## Final Mass Budget Summary

| Mass Component | At Launch [kg] | At End of Life (EOL) [kg] |
| :--- | :--- | :--- |
| **MMH Propellant** | $529$ | $25$ |
| **NTO Oxidizer** | $870$ | $41$ |
| **Helium Pressurant** | $6$ | $6$ |
| **Dry Mass (Propulsion)** | $665$ | $665$ |
| **Total Wet Launch Mass** | **$2,070$** | **$737$** |
| **Total Mass (incl. Adapter)** | **$2,155$** | — |

*Note: The total launch mass of $2,155\text{ kg}$ provides a comfortable **$445\text{ kg}$ safety margin** below the $2.6\text{ ton}$ Ariane 62 launcher limit. The Mars Orbit Insertion (MOI) time requirement is successfully achieved in **22 minutes** (well under the 30-minute limit).*

---
* **Primary Language:** MATLAB (for numerical modeling, mass iteration loops, and pressure/temperature state propagation)
* **Design Standards:** COTS hardware integration (Aerojet Rocketdyne, Ariane Group, MT Aerospace, Moog, Vacco)

---

## Authors & Contributors
* **Ali B. Akbey** Lead (Trade-off framework, propellant evaluation, tank modeling logic, P&ID architecture)
* **Jessica Clatza** (Equipment list selection, P&ID refinement)
* **Leonardo Eitner** (Electrical propulsion feasibility study, equipment list)
* **Matteo Solesio** (Mass budget iterative calculations, tank thermodynamic modeling)

*Technical University of Munich (TUM) — M.Sc. Aerospace Engineering*
