import sys
import urllib
from optparse import OptionParser
from xml.dom.minidom import parse

# Yahoo!'s limit on the number of days they will forecast
DAYS_LIMIT = 2
WEATHER_URL = 'http://xml.weather.yahoo.com/forecastrss?p=%s'
METRIC_PARAMETER = '&u=c'
WEATHER_NS = 'http://xml.weather.yahoo.com/ns/rss/1.0'

def get_weather(location_code):
    """
Fetches weather report from Yahoo!

:Parameters:
-`location_code`: A five digit US zip code.
-`days`: number of days to obtain forecasts

:Returns:
-`weather_data`: a dictionary of weather data
"""

    # Get the correct weather url.
    url = WEATHER_URL % location_code

    if True:
        url = url + METRIC_PARAMETER

    # Parse the XML feed.
    try:
        dom = parse(urllib.urlopen(url))
    except:
        return None

    # Get the units of the current feed.
    yunits = dom.getElementsByTagNameNS(WEATHER_NS, 'units')[0]

    # Get the location of the specified location code.
    ylocation = dom.getElementsByTagNameNS(WEATHER_NS, 'location')[0]

    # Get the currrent conditions.
    ycondition = dom.getElementsByTagNameNS(WEATHER_NS, 'condition')[0]

    # Hold the forecast in a hash.
    forecasts = []

    # Walk the DOM in order to find the forecast nodes.
    for i, node in enumerate(dom.getElementsByTagNameNS(WEATHER_NS,'forecast')):
        
        # Stop if the number of obtained forecasts equals the number of requested days
        if i >= DAYS_LIMIT:
            break
        else:
            # Insert the forecast into the forcast dictionary.
            forecasts.append (
                {
                    'date': node.getAttribute('date'),
                    'low': node.getAttribute('low'),
                    'high': node.getAttribute('high'),
                    'condition': node.getAttribute('text')
                }
            )

    # Return a dictionary of the weather that we just parsed.
    weather_data = {
        'current_condition': ycondition.getAttribute('text'),
        'current_temp': ycondition.getAttribute('temp'),
        'forecasts': forecasts,
        'units': yunits.getAttribute('temperature'),
        'city': ylocation.getAttribute('city'),
        'region': ylocation.getAttribute('region'),
    }
    
    return weather_data
