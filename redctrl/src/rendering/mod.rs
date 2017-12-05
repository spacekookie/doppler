//! A cairo rendering module which handles drawing of the advanced settings dialog
//!
//! It is designed to be easy to use from the outside while internally holding certain
//! state and doing a lot of heavy lifting.
//!
//! According to the specification this render module needs to provide a few utilty functions
//! internally to
//!
//!  - Render waves
//!  - Render filled waves
//!  - Track the point on a wave via mouse input
//!  - Render selection handles

use cairo::Context;

mod waves;
use self::waves::Wave;

/// Represents the available drawing area at a given time
pub struct Area {
    width: f64,
    height: f64,
}

/// Represents a single point on a drawing area
pub struct Point {
    x: f64,
    y: f64,
}

pub fn draw_wave(ctx: &Context, area: &Area) {
    let w = Wave::new(75.0, 75.0);
}