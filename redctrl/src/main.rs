extern crate gio;
extern crate gtk;

mod example {
    use gio;
    use gtk;

    use gio::prelude::*;
    use gtk::prelude::*;

    use gtk::{ApplicationWindow, Builder, Switch, Revealer};
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