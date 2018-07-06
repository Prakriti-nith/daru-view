# Dependent JS constants for web frameworks and IRuby notebook
HIGHSTOCK = 'highstock.js'.freeze
HIGHSTOCK_CSS = 'js/highstock.js'.freeze
MAP = 'map.js'.freeze
MAP_CSS = 'js/map.js'.freeze
EXPORTING = 'modules/exporting.js'.freeze
HIGHCHARTS_3D = 'highcharts-3d.js'.freeze
DATA = 'modules/data.js'.freeze

# HighCharts IRuby notebook dependencies
HIGHCHARTS_DEPENDENCIES_IRUBY = [HIGHSTOCK, MAP, EXPORTING, HIGHCHARTS_3D,
                                 DATA].freeze

# HighCharts Web Frameworks dependencies
HIGHCHARTS_DEPENDENCIES_WEB = [HIGHSTOCK_CSS, MAP_CSS, EXPORTING,
                               HIGHCHARTS_3D, DATA].freeze

# HighCharts CSS dependencies
HIGHCHARTS_DEPENDENCIES_CSS = ['highcharts.css'].freeze

# Regex pattern to match a valid URL
PATTERN_URL = Regexp.new(
  '^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$'
).freeze
