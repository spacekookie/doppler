extern crate gio;
extern crate gtk;
extern crate gdk;

mod example {
    use gio;
    use gtk;
    use gdk;

    use gio::prelude::*;
    use gtk::prelude::*;

    use gtk::{ApplicationWindow, Builder, Switch, Revealer, DrawingArea, SpinButton};
    use std::env::args;
    use std::f64;

    // make moving clones into closures more convenient
    macro_rules! clone {
        (@param _) => ( _ );
        (@param $x:ident) => ( $x );
        ($($n:ident),+ => move || $body:expr) => (
            {
                $( let $n = $n.clone(); )+
                move || $body
            }
        );
        ($($n:ident),+ => move |$($p:tt),+| $body:expr) => (
            {
                $( let $n = $n.clone(); )+
                move |$(clone!(@param $p),)+| $body
            }
        );
    }

    pub fn build_ui(application: &gtk::Application) {
        let ui_src = include_str!("settings.ui");
        let builder = Builder::new_from_string(ui_src);

        let window: ApplicationWindow = builder.get_object("window").expect("Couldn't get Window");
        let enable_simple_mode: Switch = builder.get_object("redctrl_simple_switch").unwrap();

        /* Have redshift enabled I guess */
        let global_state: Switch = builder.get_object("redctrl_enable_switch").unwrap();
        global_state.set_active(true);

        let simple_settings: Revealer = builder.get_object("redctrl_simple_setting").unwrap();
        let normal_settings: Revealer = builder.get_object("redctrl_normal_setting").unwrap();

        let draw: DrawingArea = builder.get_object("redctrl_curve_settings").unwrap();

        /* Spinner Buttons */
        let start_hour: SpinButton = builder.get_object("start_h").unwrap();
        let start_minute: SpinButton = builder.get_object("start_m").unwrap();

        let end_hour: SpinButton = builder.get_object("end_h").unwrap();
        let end_minute: SpinButton = builder.get_object("end_m").unwrap();


        draw.connect_draw(move |_self, ctx| {
            let style_ctx = _self.get_style_context().unwrap();        
            let width: f64 = _self.get_allocated_width() as f64;
            let height: f64 = _self.get_allocated_height() as f64;
            
            let xspacing: f64 = 2.0;
            let w: i64 = (width as i64) + 16;

            let theta: f64 = 0.0;
            let amplitude: f64 = 75.5;
            let period: f64 = 75.0;

            let dx: f64 = (f64::consts::PI * 2.0 / period) * xspacing;
            let mut yvalues: Vec<f64> = vec![0.0; 1024]; // FIXME: This is a horrible hack 😟

            let mut x = theta;
            for i in 0..yvalues.len() {
                yvalues[i] = f64::sin(x) * amplitude;
                x += dx;
            }

            ctx.rectangle(0.0, 0.0, width, height);
            ctx.set_source_rgba (255.0, 196.0, 119.0, 0.85);
            ctx.fill();

            ctx.move_to(0.0, height / 2.0);
            ctx.set_source_rgba(255.0, 0.0, 0.0, 255.0);

            let mut old_point: [f64; 2] = [0.0, 0.0];
            for i in 1..yvalues.len() {
                let new_point: [f64; 2] = [old_point[0] + xspacing, yvalues[i] + (height / 2.0)];
                ctx.line_to(new_point[0], new_point[1]);
                old_point = new_point;
            }
            ctx.stroke ();

            // ctx.rel_curve_to (0.0, 0.0, 75.0, -50.0, 150.0, -height);

            return Inhibit(false);
        });

        enable_simple_mode.connect_changed_active(move |switch| {
            let state = switch.get_active();
            normal_settings.set_reveal_child(!state);
            simple_settings.set_reveal_child(state);
        });

        window.set_application(application);
        window.connect_delete_event(clone!(window => move |_, _| {
            window.destroy();
            Inhibit(false)
        }));

        window.show_all();
    }

    pub fn main() {
        let application =
            gtk::Application::new("de.spacekookie.redctrl", gio::ApplicationFlags::empty())
                .expect("Initialization failed...");

        application.connect_startup(move |app| { build_ui(app); });
        application.connect_activate(|_| {});

        /* Run our app */
        application.run(&args().collect::<Vec<_>>());
    }
}

#[cfg(feature = "gtk_3_10")]
fn main() {
    example::main()
}

#[cfg(not(feature = "gtk_3_10"))]
fn main() {
    println!("This example requires GTK 3.10 or later");
    println!("Did you forget to build with `--features gtk_3_10`?");
}