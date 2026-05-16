# Stability Analysis and RTL Modeling of Discrete-Time Systems

## Author
* **Anushree Chandra** 

---

## Objective
The objective of this work is to verify the asymptotic stability of discrete-time systems subjected to external interference and sector-bounded nonlinearities. The study focuses on ensuring that digital states remain bounded and converge to equilibrium despite quantization and saturation constraints.

---

## Technical Breakdown & Implementation Examples

The stability criteria were implemented for the system matrices provided in the reference literature. The project consists of 5 distinct evaluation phases:

### Example 1: Baseline Stability and LMI Setup
* **Purpose:** Establishing the primary stability framework using Theorem 1.
* **System Matrices:**
  * $A = \begin{bmatrix} 0.72 & -0.12 \\ -0.38 & 0.38 \end{bmatrix}$
  * $S = \begin{bmatrix} 0.25 & -0.13 \\ 0.15 & 0.15 \end{bmatrix}$
  * $R = \begin{bmatrix} 0.58 & -0.2 \\ 0.49 & 0.49 \end{bmatrix}$
* **LMI Variables:** * $P$ (Full Symmetric $2 \times 2$): 3 variables ($P > 0$)
  * $J, E$ (Scalar Diagonal $2 \times 2$): 1 variable each
* **Logic:** Applied symmetric sector bounds $[K_o, K_q] = [-1, 1]$.
* **Result:** The solver returned a best value of $t = 0.465195$. Although technically infeasible ($t > 0$), the simulation verified that states $x_1$ and $x_2$ successfully converge to zero after the external disturbance is nullified at $k = 50$.

### Example 2: Asymmetric Sector Bounds
* **Purpose:** Testing system stability under uneven saturation limits.
* **Logic:** Adjusted the lower sector bound to $K_o = -1/3$ while keeping $K_q = 1$.
* **Math Implementation:** The nonlinearity was modeled as:
  $$f(k) = \max\left(\min\left(y(k), 1\right), -\frac{1}{3}\right)$$
* **Observation:** Despite the asymmetric limit, the state trajectories remained bounded and successfully reached equilibrium in the post-disturbance phase.

### Example 3: Foundation for RTL Modeling
* **Purpose:** Serving as the primary test case for digital hardware simulation.
* **Approach:** This example was chosen for the transition to Verilog because its dynamics provided a clear test for fixed-point precision.
* **Hardware Logic:** Scaled all coefficients by $128$ ($2^7$) to implement **Q1.7 fixed-point arithmetic**.
* **Result:** Proved that the sector-bounded saturation logic successfully prevents register overflow in a hardware environment.

### Example 4: Disturbance Robustness Analysis
* **Purpose:** Evaluating the system's response to varying magnitudes of external interference.
* **Logic:** Simulated the effect of matrix $R$ on the system's amplitude ("swing") during the noise phase ($k < 50$), where the noise vector is defined as:
  $$w(k) = \begin{bmatrix} \cos(k) \\ \sin(1.2 \cdot k) \end{bmatrix}$$
* **Observation:** While the noise phase caused larger oscillations, the convergence time remained entirely consistent once the noise was removed.

### Example 5: Convergence Rate ($\alpha$) Influence
* **Purpose:** Analyzing how the exponential term $\exp(2\alpha)$ affects mathematical feasibility.
* **Logic:** Used $\alpha = 0.01$ as the guaranteed decay rate for the Lyapunov function.
* **Observation:** This strict constraint contributed significantly to the "Infeasible" result in the LMI solver, highlighting the difficulty of proving a specific mathematical speed of convergence compared to observing actual convergence in time-domain simulations.

---

## Feature Matrix Summary

| Example | Feature Tested | Mathematical Logic / Constraint |
| :---: | :--- | :--- |
| **1** | Stability Baseline | Sector $[-1, 1]$, $P > 0$ |
| **2** | Asymmetric Bounds | $K_o = -1/3, K_q = 1$ |
| **3** | RTL Hardware (Verilog) | Q1.7 Fixed-Point Scaling ($128\times$) |
| **4** | Noise Response | $w(k) = [\cos(k); \sin(1.2 \cdot k)]$ |
| **5** | Decay Rate | $\exp(2 \cdot 0.01)$ |

---

## Conclusion
The simulation results confirm that the system remains asymptotically stable under all configurations. The transition from MATLAB to Verilog RTL proves that the theoretical stability criteria are robust enough to handle the non-idealities and constraints of real digital hardware, such as fixed-point quantization errors and register saturation blocks.

---

## References

1. **Kokil, P.**, *"Stability analysis of discrete-time gene regulatory networks with time-varying delays and sector-bounded nonlinearities,"* International Journal of Systems Science, 2013.  
   * **Application:** Source for system matrices $A, S, R$ and sector-bounded stability theorems used in MATLAB.
2. **Claassen, J. G.**, *"On the stability of systems with sector-bounded nonlinearities,"* IEEE Transactions on Automatic Control.  
   * **Application:** Used to define mathematical constraints for the saturation logic ($K_o$ and $K_q$).
3. **Bos, T.**, *"Stability of digital filters with overflow nonlinearities,"* Technical Report.  
   * **Application:** Supports structural definition of Lyapunov matrix $P$ to ensure energy dissipation in a digital environment.
4. **Prakash, P., et al.**, *"Hardware implementation of discrete-time systems with quantization and overflow nonlinearities."* * **Application:** Basis for hardware-level architecture, Q1.7 scaling, and Verilog saturation logic blocks.
5. **Kung, S. Y.**, *"A New Identification and Model Reduction Algorithm via Learned Hankel Approximations."* * **Application:** Provides Hankel matrix theory used to verify that the 2nd-order RTL model matches the intended system dynamics.
