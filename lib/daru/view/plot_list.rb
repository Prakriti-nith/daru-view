require 'erb'
require 'daru/view/adapters/highcharts/display'
require 'daru/view/adapters/nyaplot/display'
require 'daru/view/adapters/googlecharts/display'

# Otherwise Daru::IRuby module was used and IRuby.html method was not working.
# Have disabled rubocop Style/Mixin for this in .rubocop.yml file
include IRuby::Utils if defined?(IRuby)

module Daru
  module View
    class PlotList
      attr_reader :data

      # @param data [Daru::View::Plot, Daru::View::Table] data to visualize
      # @return [void] initialize PlotList with data
      # @example
      #
      # df = Daru::DataFrame.new({a:['A', 'B', 'C', 'D', 'E'], b:[10,20,30,40,50]})
      # plot1 = Daru::View::Plot.new(
      #   df, type: :bar, x: :a, y: :b, adapter: :googlecharts
      # )
      # plot2 = Daru::View::Plot.new(
      #   df, chart: { type: 'line' }, adapter: :highcharts
      # )
      # plots = Daru::View::PlotList.new([plot1, plot2])
      #
      def initialize(data=[])
        unless data.is_a?(Array) && data.all? { |plot|
                 plot.is_a?(Daru::View::Plot) ||
                 plot.is_a?(Daru::View::Table)
               }
          raise ArgumentError, 'Invalid Argument Passed! Valid Arguments '\
                               'consists an Array of: Daru::View::Plot or '\
                               'Daru::View::Table (Right now, it is not '\
                               'implemented for DataTables)'
        end
        @data = data
      end

      # @return [void] display in IRuby notebook
      def show_in_iruby
        IRuby.html(div)
      end

      # @return [String] generates html code to include in body tag
      def div
        path = File.expand_path('templates/multiple_charts_div.erb', __dir__)
        template = File.read(path)
        charts_id_div_tag = []
        charts_script = extract_charts_script(charts_id_div_tag)
        ERB.new(template).result(binding)
      end

      # @return [void] writes a html file to disk
      def export_html_file(path='./plot.html')
        path = File.expand_path(path, Dir.pwd)
        str = generate_html
        File.write(path, str)
      end

      private

      def extract_charts_script(charts_id_div_tag=[])
        charts_script = ''
        @data.each do |plot|
          chart_script = extract_chart_script(plot)
          charts_id_div_tag << chart_script.partition(%r{<div(.*?)<\/div>}ixm)[1]
          chart_script.sub!(%r{<div(.*?)<\/div>}ixm, '')
          charts_script << chart_script
        end
        charts_script
      end

      def extract_chart_script(plot)
        # TODO: Implement this for datatables too
        return plot.div unless defined?(IRuby.html) &&
                               plot.is_a?(Daru::View::Plot) &&
                               plot.chart.is_a?(LazyHighCharts::HighChart)
        plot.chart.to_html_iruby
      end

      def generate_html
        path = File.expand_path(
          'templates/static_html_multiple_charts.erb', __dir__
        )
        template = File.read(path)
        charts_script = div
        set_init_script = {}
        initial_script = ''
        @data.each do |plot|
          adapter = plot.adapter
          unless set_init_script[adapter]
            set_init_script[adapter] = true
            initial_script << plot.adapter.init_script
          end
        end
        ERB.new(template).result(binding)
      end
    end
  end
end
