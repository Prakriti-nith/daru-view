class FrontPageController < ApplicationController
  def front_page
    Daru::View.plotting_library = :googlecharts

    @links = Daru::DataFrame.new({
      Examples:  [
        'Nyaplot',
        'Datatables'
      ],
      Links: [
        view_context.link_to('http://localhost:3000/nyaplot', {action: 'nyaplot', controller: 'application'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/datatables', {action: 'datatables', controller: 'application'}, target: '_blank')
      ]
    })
    @table_links = Daru::View::Table.new(@links, {allowHtml: true})
    render "front_page" , layout: "googlecharts_layout"
  end
end
