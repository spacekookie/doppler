package de.spacekookie.redctrl

import org.gnome.gdk.Event
import org.gnome.gtk._

/** Define our data case class up top */
case class SliderBar(slider: Scale, box: Entry, layout: HBox)


/** Main UI controller object */
object Controller {
  val DEF_UPPER: Int = 5500
  val DEF_LOWER: Int = 2000

  var nSlider: Option[SliderBar] = null
  var dSlider: Option[SliderBar] = null

  
  /** Main function that starts the application & UI logic */
  def main(args: Array[String]) {

    Gtk.init(args)

    val window = new Window()
    val save = new Button(" Save ")
    val quit = new Button(" Quit ")
    val transition = new CheckButton("Enable day-night transition")
    val layout = new VBox(false, 3)

    /** Setup the main window */
    window.setTitle("Redshift Control")
    window.add(layout)
    window.setSizeRequest(350, 250)

    /** Top label and a separator */
    layout.add(new Label(" Setup Redshift boundry values "))
    layout.add(new HSeparator)

    /** Include two sliders */
    dSlider = Option(makeSlider("Day Temperature", 4500))
    layout.add(dSlider.get.layout)
    
    nSlider = Option(makeSlider("Night Temperature", 3250))
    layout.add(nSlider.get.layout)
    
    /** Include some additional options */
    layout.add(transition)
    layout.add(new HSeparator)

    /** Save and quit buttons in an HBox */
    val bBox = new HBox(false, 2)
    bBox.add(save)
    bBox.add(quit)
    layout.add(bBox)
    
    /** Show all window elements */
    window.showAll()

    window.connect(new Window.DeleteEvent {
      def onDeleteEvent(w: Widget, e: Event) = {
        Gtk.mainQuit
        false
      }
    })

    /** Start Gtk main loop */
    Gtk.main();
  }
  
  
  /** Create slider bars with nicely initialised values */
  private def makeSlider(name: String, default: Int): SliderBar = {
    val adj = new Adjustment()
    adj.setLower(DEF_LOWER)
    adj.setUpper(DEF_UPPER)
    adj.setValue(default)
    
    /** Create the slider-scale */
    val scale = new Scale(Orientation.HORIZONTAL, adj)
    scale.setTooltipText(name)
    scale.setDrawValue(false)
    
    val box = new Entry
    val layout = new HBox(true, 2)
    
    layout.add(box)
    layout.add(scale)
    
    /** Return a new instance of sliderbar */
    return new SliderBar(scale, box, layout)
  }

}
