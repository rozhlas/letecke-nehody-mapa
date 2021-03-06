months = <[ledna února března dubna května června července srpna září října listopadu prosince]>

class ig.IncidentList
  (@parentElement, @airportsAssoc, @allEvents) ->
    @element = @parentElement.append \div
      ..attr \class \incident-list
    ig.utils.backbutton @element
      ..attr \class "backbutton-incident"
      ..on \click ~>
        @element.classed \active no
        @parentElement.classed \push-away-barchart no
        ig.zoomOut!
    @header = @element.append \h3
    @list = @element.append \ul

  display: (point) ->
    aptCode = point.code
    events = @allEvents.filter -> it.dep == aptCode or it.dest == aptCode
    @element.classed \active yes
    @header.html "Nehody z/na letiště #{point.name}"
    @element.node!scrollTop = 0
    @list.selectAll \li .remove!
    events = events.slice!sort (a, b) -> b.fatalities - a.fatalities
    @list.selectAll \li .data events .enter!append \li
      ..append \h4
       ..html -> "#{it.opr} #{it.type}"
      ..append \span
        ..attr \class \fatalities
        ..html ->
          suff =
            | 1 < it.fatalities < 5 => "oběti"
            | 1 == it.fatalities => "oběť"
            | otherwise => "obětí"
          "#{it.fatalities} #suff"
      ..append \span
        ..attr \class \dep-dest
          ..append \abbr
            ..attr \class \dep
            ..html -> it.dep || "???"
            ..attr \title ~> @airportsAssoc[it.dep]?name || void
            ..on \click ~> ig.onAptClick @airportsAssoc[it.dep]
            ..classed \other ~> it.dep != aptCode and @airportsAssoc[it.dep]
          ..append \span
            ..attr \class \sep
            ..html " – "
          ..append \abbr
            ..attr \class \dest
            ..html -> it.dest || "???"
            ..attr \title ~> @airportsAssoc[it.dest]?name || void
            ..on \click ~> ig.onAptClick @airportsAssoc[it.dest]
            ..classed \other ~> it.dest != aptCode and @airportsAssoc[it.dest]
      ..append \span
        ..attr \class \date
        ..html -> "#{it.date.getDate!}. #{months[it.date.getMonth!]} #{it.date.getFullYear!}"
      ..append \a
        ..attr \href -> "http://aviation-safety.net/database/record.php?id=#{it.file}"
        ..attr \target \_blank
        ..html "Podrobnosti o nehodě na aviation-safety.net"
