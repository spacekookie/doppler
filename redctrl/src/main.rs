extern crate gio;
extern crate gtk;
extern crate gdk;

mod example {
    use gio;
    use gtk;
    use gdk;

    use gio::prelude::*;
    use gtk::prelude::*;

    use gtk::{ApplicationWindow, Builder, Switch, Revealer, DrawingArea};
    use std::env::args;

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
        let switch: Switch = builder.get_object("redctrl_simple_switch").unwrap();
        let simple_settings: Revealer = builder.get_object("redctrl_simple_setting").unwrap();
        let normal_settings: Revealer = builder.get_object("redctrl_normal_setting").unwrap();

        let draw: DrawingArea = builder.get_object("redctrl_curve_settings").unwrap();

        draw.connect_draw(move |_self, ctx| {
            let style_ctx = _self.get_style_context().unwrap();        
            let width: f64 = _self.get_allocated_width() as f64;
            let height: f64 = _self.get_allocated_height() as f64;
            
            ctx.rectangle(0.0, 0.0, width, height);
            ctx.set_source_rgba(255.0, 0.0, 0.0, 255.0);
            ctx.fill();

            ctx.move_to(0.0, height / 2.0);
            ctx.set_source_rgba (0.25, 0.25, 0.25, 0.75);
            ctx.rel_curve_to (0.0, 0.0, 75.0, -50.0, 150.0, -height);
            ctx.stroke ();

            return Inhibit(false);
        });

        switch.connect_changed_active(move |switch| {
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