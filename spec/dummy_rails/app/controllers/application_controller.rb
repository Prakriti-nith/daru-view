class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

 	def nyaplot
 	Daru::View.plotting_library = :nyaplot

    dv = Daru::Vector.new [:a, :a, :a, :b, :b, :c], type: :category
    # default adapter is nyaplot only
    @bar_graph = Daru::View::Plot.new(dv, type: :bar, adapter: :nyaplot)

    df = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
      c: [11,22,33,44,55]},
      order: [:a, :b, :c],
      index: [:one, :two, :three, :four, :five])
    @scatter_graph = Daru::View::Plot.new df, type: :scatter, x: :a, y: :b, adapter: :nyaplot

    df = Daru::DataFrame.new({
      a: [1, 3, 5, 7, 5, 0],
      b: [1, 5, 2, 5, 1, 0],
      c: [1, 6, 7, 2, 6, 0]
    }, index: 'a'..'f')
    @df_line = Daru::View::Plot.new df, type: :line, x: :a, y: :b, adapter: :nyaplot

    render "nyaplot" , layout: "application"
  end

  def datatables
    # need to give name, otherwise generated thead html code will not work.
    # Because no name means no thead  in vector.
    # dv = Daru::Vector.new [1, 2, 3, 4, 5, 6], name: 'series1'
    # options = {
    #   adapter: :datatables,
    #   html_options: {
    #     table_options: {
    #       table_thead: "<thead>
    #                   <tr>
    #                     <th></th>
    #                     <th>Demo Column Name</th>
    #                   </tr>
    #                 </thead>",
    #       width: '90%'
    #     }
    #   }
    # }
    # # default adapter is nyaplot only
    # @dt_dv = Daru::View::Table.new(dv, options)


    netflix_df = Daru::DataFrame.from_csv("#{Rails.root}/lib/netflix_titles_nov_2019.csv")
    netflix_options = {
      adapter: :datatables,
      html_options: {
        table_options: {
          cellspacing: '0',
          width: "100%"
        }
      }
    }
    @netflix_dt = Daru::View::Table.new(netflix_df, netflix_options)

    # df1 = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
    #   c: [11,22,33,44,55]},
    #   order: [:a, :b, :c],
    #   index: [:one, :two, :three, :four, :five])
    # options2 = {
    #   adapter: :datatables,
    #   html_options: {
    #     table_options: {
    #       cellspacing: '0',
    #       width: "100%"
    #     }
    #   }
    # }
    # @dt_df1 = Daru::View::Table.new(df1, options2)

    # df2 = Daru::DataFrame.new({
    #   a: [1, 3, 5, 7, 5, 0],
    #   b: [1, 5, 2, 5, 1, 0],
    #   c: [1, 6, 7, 2, 6, 0]
    #   }, index: 'a'..'f')
    # @dt_df2 = Daru::View::Table.new(df2, pageLength: 3, adapter: :datatables)

    # dv_arr = [1, 2, 3, 4, 5, 6]
    # @dt_dv_arr = Daru::View::Table.new(dv_arr, pageLength: 3, adapter: :datatables)

    # df1_arr = [
    #   [11,12,13,14,15],
    #   [1,2,3,4,5],
    #   [11,22,33,44,55]
    # ]
    # @dt_df1_arr = Daru::View::Table.new(df1_arr, pageLength: 3, adapter: :datatables)

    # df2_arr = [
    #   [1, 3, 5, 7, 5, 0],
    #   [1, 5, 2, 5, 1, 0],
    #   [1, 6, 7, 2, 6, 0]
    # ]
    # @dt_df2_arr = Daru::View::Table.new(df2_arr, pageLength: 3, adapter: :datatables)

    # data = []
    # for i in 0..100000
    #   data << i
    # end
    # options = {
    #   searching: false,
    #   pageLength: 7,
    #   adapter: :datatables
    # }
    # @table_array_large = Daru::View::Table.new(data, options)

    render "datatables" , layout: "datatables_layout"
  end
end
