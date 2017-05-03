

-- A class that handles the runtime persistent state
--    of redctrl and libredshift (via ffi)
class Redstate

  -- Define these as values we can use
  @@MODE_LOCATION = 'location'
  @@MODE_TIMING = 'times'
  @@MODE_UNDEFINED = 'wayne'

  new: =>
    print "Creating new state handler..."

    @transitions = true
    @current_state = @@MODE_UNDEFINED

    -- FIXME: Store time as string or number?
    @time_start = 1800
    @time_stop = 600

    -- By default you're somewhere in the ocean :)
    @latitude = 0
    @longitude = 0

    -- Set default redshift color values
    @color_night = 3500
    @color_day = 5500

    -- TODO: Initialise native shit here

  set_times: (start, stop) =>
  set_location: (lat, long) =>
  set_colors: (day, night) =>