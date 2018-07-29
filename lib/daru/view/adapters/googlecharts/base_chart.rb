require 'securerandom'
require 'google_visualr'

module GoogleVisualr
  class BaseChart
    # Holds a value only when generate_body or show_in_iruby method
    #   is invoked in googlecharts.rb
    # @return [Array, Daru::DataFrame, Daru::Vector, Daru::View::Table, String]
    #   Data of GoogleVisualr Chart
    attr_accessor :data
    # @return [Hash] Various options created to facilitate more features.
    #   These will be provided by the user
    attr_accessor :user_options

    # @see #GooleVisualr::DataTable.extract_option_view
    def extract_option_view
      return js_parameters(@options.delete('view')) unless @options['view'].nil?
      '\'\''
    end

    # Generates JavaScript function for rendering the chart when data is URL of
    #   the google spreadsheet
    #
    # @param (see #to_js_spreadsheet)
    # @return [String] JS function to render the google chart when data is URL
    #   of the google spreadsheet
    def draw_js_spreadsheet(data, element_id=SecureRandom.uuid)
      js = ''
      js << "\n function #{chart_function_name(element_id)}() {"
      js << "\n 	var query = new google.visualization.Query('#{data}');"
      js << "\n 	query.send(#{query_response_function_name(element_id)});"
      js << "\n }"
      js << "\n function #{query_response_function_name(element_id)}(response) {"
      js << "\n 	var data_table = response.getDataTable();"
      js << "\n 	var chart = new google.#{chart_class}.#{chart_name}"\
            "(document.getElementById('#{element_id}'));"
      js << add_listeners_js('chart')
      js << "\n 	chart.draw(data_table, #{js_parameters(@options)});"
      js << "\n };"
      js
    end

    # Taken from `draw_js` in googlevisualr. While adding the listener,
    #   the callback code (provided by the user) should be within the function.
    #
    # @param element_id [String] The ID of the DIV element that the Google
    #   Chart should be rendered in
    # @return [String] JavaScript function for rendering the chart
    def draw_chart_js(element_id)
      js = ''
      js << "\n  function #{chart_function_name(element_id)}() {"
      js << "\n    #{@data_table.to_js}"
      js << "\n    var chart = new google.#{chart_class}.#{chart_name}"
      js << "(document.getElementById('#{element_id}'));"
      js << add_listeners_js('chart')
      js << "\n    chart.draw(data_table, #{js_parameters(@options)});"
      js << "\n  };"
      js
    end
  end
end
