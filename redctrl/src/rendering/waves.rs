//! Utility functions to create and render waves
//! 
//! For the time-being only sin-based waves are supported. Other formats
//! should be included at some point too. All waves are rendered with
//! Cairo.
//! 
//! All waves are rendered by line interpolation. The minimum stepping distance
//! can be configured (default is 4px). Generally the compute and plot algorithms
//! are in time complexity O(n). Imperformant functions are marked as such.

use rendering::Point;
use std::f64;

pub struct Wave {
    x_inter: f64,
    period: f64,
    amp: f64,
    dx: f64,
    points: Vec<Point>
}

impl Wave {

    /// Create a new (sin) Wave for a given period and amplitude
    pub fn new(period: f64, amp: f64) -> Wave{
        let spacing: f64 = 4.0; // Default spacing
        let dx: f64 = (f64::consts::PI * 2.0 / period) * spacing;

        return Wave {
            x_inter: spacing,
            period: period,
            amp: amp,
            dx: dx,
            points: Vec::new()
        };
    }
}