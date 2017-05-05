

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

    -- Store at what time we want to be turned on/ off *rawr*
    @time_start = '18:00'
    @time_stop = '06:00'

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