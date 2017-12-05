//! Utility functions to create and render waves
//!
//! For the time-being only sin-based waves are supported. Other formats
//! should be included at some point too. All waves are rendered with
//! Cairo.
//!
//! All waves are rendered by line interpolation. The minimum stepping distance
//! can be configured (default is 4px). Generally the compute and plot algorithms
//! are in time complexity O(n). Imperformant functions are marked as such.

use rendering::{Point, Drawable};
use std::f64;

/// Metadata that describes a wave
pub struct Wave {
    x_inter: f64,
    amp: f64,
    dx: f64,
    theta: f64,
    points: Vec<Point>,
}

impl Drawable for Wave {
    fn draw<F>(&self, renderer: F)
    where
        F: Fn(&Vec<Point>),
    {
        renderer(&self.points);
    }
}

impl Wave {
    /// Create a new (sin) Wave for a given period and amplitude
    pub fn new(period: f64, amp: f64) -> Wave {
        let spacing: f64 = 4.0; // Default spacing
        let dx: f64 = (f64::consts::PI * 2.0 / period) * spacing;

        return Wave {
            x_inter: spacing,
            amp: amp,
            dx: dx,
            theta: 0.0,
            points: Vec::new(),
        };
    }

    /// Update the point collection for a given size
    pub fn update(&mut self, size: f64) {
        let mut points: Vec<Point> = Vec::new();
        let mut ox = 0.0;
        let mut xy = self.theta;

        loop {
            let y = f64::sin(xy) * self.amp;
            let x = ox + self.x_inter;

            /* Add to list */
            points.push(Point { x: x, y: y });

            /* Increment values */
            xy += self.dx;
            ox = x;

            /* Loop termination */
            if x >= size {
                break;
            }
        }

        self.points = points;
    }

    pub fn time_step(&mut self, time: f64) {
        self.theta = time;
    }
}