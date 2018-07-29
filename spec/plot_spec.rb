describe Daru::View::Plot, 'Chart plotting with Nyaplot library' do
  let(:df) do
    Daru::DataFrame.new(
      {
        a: [1, 2, 3, 4, 5, 6],
        b: [1, 5, 2, 5, 1, 0],
        c: [1, 6, 7, 2, 6, 0]
      }, index: 'a'..'f'
    )
  end
  let(:dv) { Daru::Vector.new [1, 2, 3] }
  let(:lib) { Daru::View.plotting_library }
  let(:plot_df) { Daru::View::Plot.new(df, type: :line, x: :a, y: :c) }
  let(:plot_dv) { Daru::View::Plot.new(dv, type: :line) }
  context 'initialize' do
    # before { Daru::View.plotting_library = :nyaplot }
    context 'Default plotting_library is nyaplot' do
      it { expect(Daru::View.plotting_library).to eq(:nyaplot)}
    end

    context 'chart using DataFrame' do
      it { expect(plot_df).to be_a Daru::View::Plot }
      it { expect(plot_df.chart.class).to eq Nyaplot::Plot }
      it { expect(plot_df.data).to eq df}
      it { expect(plot_df.options).to eq type: :line, x: :a, y: :c}
    end

    context 'chart using Vector' do
      it { expect(plot_dv).to be_a Daru::View::Plot }
      it { expect(plot_dv.chart).to be_a Nyaplot::Plot }
      it { expect(plot_dv.data).to eq dv}
      it { expect(plot_dv.options).to eq type: :line}
    end

    context 'fails when other than DataFrame and Vector is as data' do
      # expect{Daru::View::Plot.new()}
      # .to raise_error(ArgumentError,
      # /Nyaplot Library, data must be in Daru::Vector or Daru::DataFrame/)
    end
  end
end

describe Daru::View::Plot, 'Chart plotting with Highcharts library' do
  before { Daru::View.plotting_library = :highcharts }
  let(:lib) { Daru::View.plotting_library }
  let(:df) do
    Daru::DataFrame.new(
      {
        a: [1, 2, 3, 4, 5, 6],
        b: [1, 5, 2, 5, 1, 0],
        c: [1, 6, 7, 2, 6, 0]
      }, index: 'a'..'f'
    )
  end
  let(:dv) { Daru::Vector.new [1, 2, 3] }
  let(:plot_df) { Daru::View::Plot.new(df, type: :line, x: :a, y: :c) }
  let(:plot_dv) { Daru::View::Plot.new(dv, type: :line) }
  let(:plot_array) { Daru::View::Plot.new([1, 2, 3], type: :line) }
  context 'initialize with HighCharts library'  do
    it 'check plotting library' do
      expect(lib).to eq(:highcharts)
    end

    it 'Highcharts chart using Array' do
      expect(plot_array).to be_a Daru::View::Plot
      expect(plot_array.chart).to be_a LazyHighCharts::HighChart
      expect(plot_array.data).to eq [1, 2, 3]
      expect(plot_array.options).to eq type: :line
    end

    it 'Highcharts chart using DataFrame' do
      expect(plot_df).to be_a Daru::View::Plot
      expect(plot_df.chart).to be_a LazyHighCharts::HighChart
      expect(plot_df.data).to eq df
      expect(plot_df.options).to eq type: :line, x: :a, y: :c
    end

    it 'Highcharts chart using Vector' do
      expect(plot_dv).to be_a Daru::View::Plot
      expect(plot_dv.chart).to be_a LazyHighCharts::HighChart
      expect(plot_dv.data).to eq dv
      expect(plot_dv.options).to eq type: :line
    end
  end # initialize context end

  context '#export' do
    it "should generate the valid script to export the chart" do
      js = plot_df.export
      expect(js).to match(/\s+new\s+Highcharts.Chart/)
      expect(js).to match(/var\s+options\s+=/)
      expect(js).to match(/window.chart_/)
      expect(js).to match(/script/)
      expect(js).to match(/image\/png/)
      expect(js).to match(/chart.exportChartLocal/)
      expect(js).to match(/filename: 'chart'/)
    end
    it "should generate the valid script to export the chart" do
      js = plot_df.export('pdf','daru')
      expect(js).to match(/\s+new\s+Highcharts.Chart/)
      expect(js).to match(/var\s+options\s+=/)
      expect(js).to match(/window.chart_/)
      expect(js).to match(/script/)
      expect(js).to match(/application\/pdf/)
      expect(js).to match(/chart.exportChartLocal/)
      expect(js).to match(/filename: 'daru'/)
    end
    it "should generate the valid script to export the chart" do
      js = plot_df.export('png','daru')
      expect(js).to match(/\s+new\s+Highcharts.Chart/)
      expect(js).to match(/var\s+options\s+=/)
      expect(js).to match(/window.chart_/)
      expect(js).to match(/script/)
      expect(js).to match(/image\/png/)
      expect(js).to match(/chart.exportChartLocal/)
      expect(js).to match(/filename: 'daru'/)
    end
    it "should generate the valid script to export the chart" do
      js = plot_df.export('jpg','daru')
      expect(js).to match(/\s+new\s+Highcharts.Chart/)
      expect(js).to match(/var\s+options\s+=/)
      expect(js).to match(/window.chart_/)
      expect(js).to match(/script/)
      expect(js).to match(/image\/jpeg/)
      expect(js).to match(/chart.exportChartLocal/)
      expect(js).to match(/filename: 'daru'/)
    end
    it "should generate the valid script to export the chart" do
      js = plot_df.export('svg','daru')
      expect(js).to match(/\s+new\s+Highcharts.Chart/)
      expect(js).to match(/var\s+options\s+=/)
      expect(js).to match(/window.chart_/)
      expect(js).to match(/script/)
      expect(js).to match(/image\/svg\+xml/)
      expect(js).to match(/chart.exportChartLocal/)
      expect(js).to match(/filename: 'daru'/)
    end
  end
end

describe Daru::View::Plot, 'Chart plotting with Googlecharts library' do
  context 'initialize with Googlecharts library' do
    context 'Googlecharts library' do
      before { Daru::View.plotting_library = :googlecharts }
      let(:lib) { Daru::View.plotting_library }
      let(:options) {{width: 800, height: 720}}
      let(:df) do
        Daru::DataFrame.new(
          {
            a: [1, 2, 3, 4, 5, 6],
            b: [1, 5, 2, 5, 1, 0],
            c: [1, 6, 7, 2, 6, 0]
          }, index: 'a'..'f'
        )
      end
      let(:dv) { Daru::Vector.new [1, 2, 3] }
      let(:plot_df) { Daru::View::Plot.new(df, options) }
      let(:plot_dv) { Daru::View::Plot.new(dv, options) }
      let(:plot_array) { Daru::View::Plot.new(
        [['col1', 'col2', 'col3'],[1, 2, 3]], options) }
      it 'check plotting library' do
        expect(lib).to eq(:googlecharts)
      end

      it 'Googlecharts chart using Array' do
        expect(plot_array).to be_a Daru::View::Plot
        expect(plot_array.chart).to be_a GoogleVisualr::Interactive::LineChart
        expect(plot_array.data).to eq [[1, 2, 3]]
        expect(plot_array.options).to eq options
      end

      it 'Googlecharts chart using DataFrame' do
        expect(plot_df).to be_a Daru::View::Plot
        expect(plot_df.chart).to be_a GoogleVisualr::Interactive::LineChart
        expect(plot_df.data).to eq df
        expect(plot_df.options).to eq options
      end

      it 'Googlecharts chart using Vector' do
        expect(plot_dv).to be_a Daru::View::Plot
        expect(plot_dv.chart).to be_a GoogleVisualr::Interactive::LineChart
        expect(plot_dv.data).to eq dv
        expect(plot_dv.options).to eq options
      end
    end
  end # initialize context end
end
