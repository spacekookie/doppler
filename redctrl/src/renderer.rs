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


pub struct Renderer {}

impl Renderer {
    pub fn new() -> Renderer {
        return Renderer {};
    }
}