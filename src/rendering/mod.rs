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
use gdk::RGBA;

mod waves;
use self::waves::Wave;

mod curve;
pub use self::curve::*;


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

static mut CHOSEN_COLOR: RGBA = RGBA { red: 1f64, green: 0f64, blue: 0f64, alpha: 1f64 };
static mut WAVE_THETA: f64 = 0.0;

pub fn set_time_displacement(theta: f64) {
    unsafe {
        WAVE_THETA = theta;
    }
}

pub fn set_draw_color(red: f64, green: f64, blue: f64, alpha: f64) {
    unsafe {
        CHOSEN_COLOR = RGBA { red: red, green: green, blue: blue, alpha: alpha };
    }
}

pub fn draw_wave(ctx: &Context, area: &Area, offset: &Point, period: f64, amp: f64) {
    let mut w = Wave::new(period, amp);
    unsafe {
        w.time_step(WAVE_THETA);
        ctx.set_source_rgba(CHOSEN_COLOR.red, CHOSEN_COLOR.green, CHOSEN_COLOR.blue, CHOSEN_COLOR.alpha);
    }
    
    w.update(area.width);
    w.draw(|points: &Vec<Point>| for cp in points {
        ctx.line_to(cp.x + offset.x, cp.y + offset.y);
    });

    ctx.stroke();
}