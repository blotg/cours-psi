#import "@local/prepa:0.1.0": *

#show: exercice.with(
    titre: "Computing effective values",
    difficulté: 0,
    numérique: true,
)

With the help of Python, calculate the effective (RMS) values of the following periodic signals.

The function #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.quad.html#scipy.integrate.quad", `quad`) from the `scipy.integrate` module may be useful for performing the necessary integrations. It takes as arguments a function, a lower bound, and an upper bound, and returns the value of the integral over that interval.

#question(
    coups-de-pouce: (
        "What is the period of the signal?",
        "Set up the integral for the effective value calculation.",
        "Use the `quad` function to compute the integral.",
    ),
)[
    $s_1(t) = 10 cos(20 pi t + pi/2)$. Compare your result with the known formula for a sinusoidal signal.
][
    The period is $T = (2 pi) / omega = (2 pi) / (20 pi) = qty("0.1", "s")$.
    ```python
    from scipy.integrate import quad
    import numpy as np
    def s1_squared(t):
        return ( 10*np.cos(20*np.pi*t + np.pi/2) )**2
    T = 0.1  # period
    integral, _ = quad(s1_squared, 0, T) # quad returns a tuple (value, error)
    rms_value = np.sqrt(integral / T)
    print("RMS value of s1:", rms_value)
    ```
]

#question(
    coups-de-pouce: (),
)[
    $s_2(t) = cos^2( pi t)$. Compare your result with the known formula for a sinusoidal signal.
][
    The period is $T = qty("2", "s")$.
    ```python
    from scipy.integrate import quad
    import numpy as np
    def s2_squared(t):
        return np.cos(np.pi * t)**4
    T = 2  # period
    integral, _ = quad(s2_squared, 0, T) # quad returns a tuple (value, error)
    rms_value = np.sqrt(integral / T)
    print("RMS value of s2:", rms_value)
    ```
]

#question(
    coups-de-pouce: (),
)[
    A triangular wave centered around zero with a peak value of 5 V and a period of #qty("2", "ms").
][
    The half-period is #qty("1", "ms").

    Between #qty("0", "ms") and #qty("1", "ms"), the signal rises linearly from #qty("-5", "V") to #qty("5", "V"), with a slope of $qty("10", "V/ms") = qty("10000", "V/s")$ and a y-intercept#footnote["Ordonnée à l'origine" in french] of #qty("-5", "V").

    Between #qty("1", "ms") and #qty("2", "ms"), the signal falls linearly back to #qty("-5", "V") with a slope of $qty("-10", "V/ms") = qty("-10000", "V/s")$ and a y-intercept of #qty("15", "V").
    ```python
    from scipy.integrate import quad
    import numpy as np
    T = 2e-3
    def s3_squared(t):
        t = t % T # wrap around the period
        if 0 <= t < 0.001:
            return (10000 * t - 5)**2  # rising edge
        else:
            return (-10000 * t + 15)**2  # falling edge
    integral, _ = quad(s3_squared, 0, T) # quad returns a tuple (value, error)
    rms_value = np.sqrt(integral / T)
    print("RMS value of s3:", rms_value)
    ```
]
