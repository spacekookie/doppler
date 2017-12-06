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
use rendering::Drawable;

/// Segment types for each time of day
pub enum SegmentType {
    DAY,
    DUSK,
    NIGHT,
}

/// Represents a self-container rendering segment for the control curve
pub struct Segment {
    _type: SegmentType,
    length: f64,
    level: f64,
    color: RGBA,
}


impl Segment {
    pub fn new(t: SegmentType, length: f64, level: f64) {
            
    }
}