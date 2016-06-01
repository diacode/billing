class Smithers.Views.BankRecords.EvolutionView extends Smithers.Views.ApplicationView
  constructor: ->
    super()
    @chart = $('#evolution_chart')
    @chart_id = @chart.attr('id')
    @chart_data = @chart.data('records')
    @regularDotRadius = 3.5
    @range = $("#range")

  render: ->
    super()
    @initChart()
    @initDateRangePicker()

  initChart: ->    
    # In first place we have to discard all those records having
    # dates repeated keeping the record with the highest ID for 
    # the repeated date.
    if @chart_data.length is 0
      $('#evolution_chart').html("
      <h1 class='blank-slate'>There is no data here</h1>")
    else
      nest = d3.nest()
        .key (d) -> d.operation_at
        .entries(@chart_data)

      data = nest.map (h) ->
        h.values[h.values.length-1]

      # Date parsing
      dateParser = d3.time.format("%Y-%m-%d").parse
      data.forEach (d) -> 
        d.date = dateParser(d.operation_at)
        d.balance = parseFloat d.balance

      margin =
        top: 20
        right: 20
        bottom: 30
        left: 20

      @width = @chart.width() - margin.left - margin.right
      @height = 500 - margin.top - margin.bottom
      parseDate = d3.time.format("%d-%b-%y").parse

      x = d3.time.scale().range([
        0
        @width
      ])
      
      y = d3.scale.linear().range([
        @height
        0
      ])

      maxValue = d3.max data, (d) -> d.balance

      # Horizontal axis
      xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom")
        .ticks(d3.time.months)
        .tickFormat(d3.time.format("%B"))
      
      yAxis = d3.svg.axis()
        .scale(y)
        .orient("right")
        .tickSize(@width)

      line = d3.svg.line().x((d) ->
        x d.date
      ).y((d) ->
        y d.balance
      ).interpolate("linear")


      svg = d3.select("##{@chart.attr('id')}").append("svg").attr("width", @width + margin.left + margin.right).attr("height", @height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

      x.domain d3.extent(data, (d) ->
        d.date
      )

      y.domain [0, maxValue+5000]

      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + @height + ")").call xAxis
      gy = svg.append("g").attr("class", "y axis").call(yAxis)
      svg.append("path").datum(data).attr("class", "line").attr "d", line

      # Tooltip div creation
      @tooltip = d3.select("body").append("div")   
        .attr("class", "d3-tooltip")               
        .style("visibility", 'hidden')

      # Adding dots
      svg.selectAll("dot")
        .data(data)
        .enter()
        .append("circle")
        .attr("class", "dot")
        .attr("r", @regularDotRadius).attr("cx", (d) ->
          x d.date
        ).attr("cy", (d) ->
          y d.balance
        ).on("mouseover", (d) =>
          # Showing tooltip
          @showTooltip(d)
          
          # Drawing lines to axes
          circle = d3.select(d3.event.toElement)
          @drawLineToAxes(circle, "x")
          @drawLineToAxes(circle, "y")

          # Increasing dot radius
          circle.transition()
            .duration(200)
            .attr("r", (circle.attr("r") * 1.4))

        ).on("mousemove", =>
          @moveTooltip(event.pageY, event.pageX)

        ).on "mouseout", =>
          @hideTooltip()
          d3.selectAll(".line-helper").remove()

          # Reverting dot radius increasing
          circle = d3.select(d3.event.fromElement)
          circle.transition()
            .duration(200)
            .attr("r", @regularDotRadius)

      # Some modifications to the y axis
      gy.selectAll("g")
        .filter((d) -> d)
        .classed("minor", true)

      gy.selectAll("text")
        .attr("x", 4)
        .attr("dy", -4)

      return

  showTooltip: (data) ->
    amount = data.balance
    formatted_date = moment(data.date).format('L')

    @tooltip.html("
      <strong>Saldo</strong><br/>
      Fecha #{formatted_date}<br/>
      Cantidad: #{amount}"
    )

    @tooltip.style "visibility", "visible"

  moveTooltip: (top, left) ->
    @tooltip.style("top", (top - 10) + "px").style "left", (left + 10) + "px"

  hideTooltip: ->
    @tooltip.style "visibility", "hidden"

  drawLineToAxes: (elem, axisToDraw) ->
    offset = parseInt(elem.attr("r")) + 1
    if axisToDraw is "x"
      xPos = parseFloat(elem.attr("cx")) - offset
      yPos = parseFloat(elem.attr("cy"))
      finalPos = 0
    else
      xPos = parseFloat(elem.attr("cx"))
      yPos = parseFloat(elem.attr("cy")) + offset
      finalPos = @height

    d3.select("##{@chart_id} g")
      .append("line")
      .attr("class", "line-helper " + axisToDraw)
      .attr("x1", xPos)
      .attr("x2", xPos)
      .attr("y1", yPos)
      .attr("y2", yPos)
      .attr("stroke-dasharray", "3,3")
      .transition()
      .duration(500)
      .attr axisToDraw + "1", finalPos
    return

  initDateRangePicker: ->
    @range.daterangepicker
      opens: 'right'
      format: 'DD/MM/YYYY'
      ranges:
        'Últimos 6 meses': [moment().subtract('months', 6), moment()],
        'Últimos 30 días': [moment().subtract('days', 29), moment()],
        'Este mes': [moment().startOf('month'), moment().endOf('month')],
        'Mes pasado': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]

    @range.on 'apply.daterangepicker', @dateRangeChanged

  dateRangeChanged: (ev, picker) =>
    a = picker.startDate.format("YYYY-MM-DD")
    b = picker.endDate.format("YYYY-MM-DD")
    location.href = "/balance/evolution?start=#{a}&end=#{b}"
