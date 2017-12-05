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
    pub width: f64,
    pub height: f64,
}

/// Represents a single point on a drawing area
pub struct Point {
    pub x: f64,
    pub y: f64,
}

trait Drawable {
    fn draw<F>(&self, renderer: F)
    where
        F: Fn(&Vec<Point>);
}


pub fn draw_wave(ctx: &Context, area: &Area, offset: &Point, time: f64) {
    let mut w = Wave::new(75.0, 75.0);
    w.time_step(time);
    w.update(area.width);
    w.draw(|points: &Vec<Point>| for cp in points {
        ctx.line_to(cp.x + offset.x, cp.y + offset.y);
    });

    ctx.stroke();
}