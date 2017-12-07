//! Curve rendering module
//!
//! A curve represents three segments to control the hue of Redshift. The three
//! segments are `daytime`, `dusk` and `night`.
//!
//! Each segment can be controlled individually, then the transitions are drawn
//! between them.
//!
//! It's also possible to control the length of each segment.
//!
//! **Note:** This module only contains the rendering part of the control curves

use gdk::RGBA;
use colortemp::{rgb_to_temp, temp_to_rgb};
use rendering::{Area, Point};
use std::collections::HashMap;
use cairo::Context;

/// Segment types for each time of day
#[derive(Hash, PartialEq, Eq)]
pub enum SegmentType {
    DAY,
    DUSK,
    NIGHT,
}

/// Represents a self-container rendering segment for the control curve
pub struct Segment {
    pub length: f64,
    pub level: f64,
    pub color: RGBA,
}

const ALPHA: f64 = 125.0; // TODO: Make the alpha configurable

impl Segment {

    /// Create a new Segment to control
    pub fn new(ctx: &Area, length: f64, kelvin: i64) -> Segment {
        let rgb = temp_to_rgb(kelvin);

        return Segment {
            length: length,
            level: Segment::temperature_to_level(kelvin, ctx.height),
            color: RGBA {
                red: rgb.r,
                green: rgb.g,
                blue: rgb.b,
                alpha: ALPHA,
            },
        };
    }

    pub fn adjust_level(&mut self, kelvin: i64, height: f64) {
        let rgb = temp_to_rgb(kelvin);
        self.color = RGBA {
            red: rgb.r,
            green: rgb.g,
            blue: rgb.b,
            alpha: ALPHA,
        };

        self.level = Segment::temperature_to_level(kelvin, height);
    }

    fn temperature_to_level(kelvin: i64, height: f64) -> f64 {
        return kelvin as f64;
    }
}

pub struct Curve {
    segments: HashMap<SegmentType, Segment>,
    area: Area,
}

impl Curve {
    pub fn new() -> Curve {

        return Curve {
            segments: HashMap::new(),
            area: Area {
                width: 0.,
                height: 0.,
            },
        };
    }

    pub fn set_size(&mut self, width: f64, height: f64) {
        self.area.width = width;
        self.area.height = height;
    }

    pub fn add_segment(&mut self, t: SegmentType, length: f64, kelvin: i64) {
        let s = Segment::new(&self.area, length, kelvin);
        self.segments.insert(t, s);
    }

    pub fn draw(&self, frame: &Area, ctx: &Context) {
        let day = self.segments.get(&SegmentType::DAY).unwrap();
        let dusk = self.segments.get(&SegmentType::DUSK).unwrap();
        let night = self.segments.get(&SegmentType::NIGHT).unwrap();

        // ctx.set_source_rgba(CHOSEN_COLOR.red, CHOSEN_COLOR.green, CHOSEN_COLOR.blue, CHOSEN_COLOR.alpha)

        ctx.set_line_width(4.5);
        ctx.set_source_rgba(0.75, 0.75, 0.75, 0.85);
        ctx.move_to(0., day.level);
        ctx.line_to(day.length, day.level);
        ctx.stroke();
        ctx.set_line_width(2.5);

        ctx.set_source_rgba(1., 0.4, 0.0, 0.85);
        ctx.move_to(day.length, dusk.level);
        ctx.line_to(day.length + dusk.length, dusk.level);
        ctx.stroke();

        ctx.set_source_rgba(1.0, 0.0, 0.0, 0.85);
        ctx.move_to(day.length + dusk.length, night.level);
        ctx.line_to(day.length + dusk.length + night.length, night.level);
        ctx.stroke();
    }
}