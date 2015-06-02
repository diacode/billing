class Smithers.Views.BankRecords.IncomeExpensesView extends Smithers.Views.ApplicationView
  constructor: ->
    super()
    @chart = $('#income_expenses_chart')
    @chart_data = @chart.data('records')
    numeral.language('es')

  render: ->
    super()
    @initChart()

  initChart: ->
    dateParser = d3.time.format("%Y-%m-%d").parse

    @chart_data.forEach (d) -> d.operation_at = dateParser(d.operation_at)

    # Data formatting. We'll format the data so that the new resultset will have 
    # one item by month with two columns: income and expenses
    formatted_data = []
    
    formatted_dates = d3.set(
      $(@chart_data).map (idx, elm) -> 
        new Date(elm.operation_at.getFullYear(), elm.operation_at.getMonth(), 1)
      .get()
    ).values()

    for date in formatted_dates
      current_date_items = @chart_data.filter (item) -> item.operation_at.getFullYear() == new Date(date).getFullYear() && item.operation_at.getMonth() == new Date(date).getMonth()
      positive_items = current_date_items.filter (item) -> item.amount > 0
      negative_items = current_date_items.filter (item) -> item.amount < 0

      formatted_data.push({
        date: new Date(date)
        income: d3.sum positive_items, (item) -> item.amount
        expenses: d3.sum negative_items, (item) -> Math.abs(item.amount)
      })
    # End of data formatting

    margin =
      top: 20
      right: 20
      bottom: 30
      left: 70

    width = @chart.width() - margin.left - margin.right
    height = 500 - margin.top - margin.bottom

    x0 = d3.scale.ordinal().rangeRoundBands([
      0
      width
    ], .1)

    x1 = d3.scale.ordinal()
    y = d3.scale.linear().range([
      height
      0
    ])

    xAxis = d3.svg.axis()
      .scale(x0)
      .orient("bottom")    
      .ticks(d3.time.months)
      .tickFormat(d3.time.format("%B'%y"))

    yAxis = d3.svg.axis().scale(y).orient("left").tickFormat(d3.format(".2s"))

    svg = d3.select("##{@chart.attr('id')}")
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    
    barTypes = ['income', 'expenses']

    formatted_data.forEach (d) ->
      d.amounts = barTypes.map((name) ->
        name: name
        value: +d[name]
      )
      return

    x0.domain formatted_data.map((d) ->
      d.date
    )
    
    x1.domain(barTypes).rangeRoundBands [
      0
      x0.rangeBand()
    ]

    y.domain [
      0
      d3.max(formatted_data, (d) ->
        d3.max d.amounts, (d) ->
          d.value
      )
    ]

    svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
    svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "EUR"
    state = svg.selectAll(".state").data(formatted_data).enter().append("g").attr("class", "g").attr("transform", (d) ->
      "translate(" + x0(d.date) + ",0)"
    )

    state.selectAll("rect").data((d) ->
      d.amounts
    ).enter().append("rect").attr("width", x1.rangeBand()).attr("x", (d) ->
      x1 d.name
    ).attr("y", (d) ->
      y d.value
    ).attr("height", (d) ->
      height - y(d.value)
    ).attr("class", (d) -> d.name)
    .on('mouseover', (d) =>
      node = d3.select(event.currentTarget)
      @showTooltip(d, event.pageX, event.pageY)
    )
    .on('mousemove', =>
      @moveTooltip(event.pageY, event.pageX)
    )
    .on('mouseout', @hideTooltip)


    legend = svg.selectAll(".legend").data(barTypes.slice().reverse()).enter().append("g").attr("class", "legend").attr("transform", (d, i) ->
      "translate(0," + i * 20 + ")"
    )
    legend.append("rect").attr("x", width - 18).attr("width", 18).attr("height", 18).attr("class", (d) -> d)
    legend.append("text").attr("x", width - 24).attr("y", 9).attr("dy", ".35em").style("text-anchor", "end").text (d) ->
      d

    # Tooltip div creation
    @tooltip = d3.select("body").append("div")   
      .attr("class", "d3-tooltip")               
      .style("visibility", 'hidden')

    return

  showTooltip: (data, x, y) ->
    recordType = if data.name is 'income' then 'Ingresos' else 'Gastos'
    amount = numeral(data.value).format('0,0[.]00 $')
    
    @tooltip.html("#{recordType}:<br/><strong>#{amount}</strong>")
    @tooltip.style("top", (y - 10) + "px").style "left", (x + 10) + "px"
    @tooltip.style "visibility", "visible"

  moveTooltip: (top, left) ->
    @tooltip.style("top", (top - 10) + "px").style "left", (left + 10) + "px"

  hideTooltip: =>
    @tooltip.style "visibility", "hidden"
