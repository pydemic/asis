defmodule AsisWeb.RoraimaLive.Renderings.JS do
  @moduledoc """
  Render the dashboard JavaScript section.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.{HTML, LiveView}
  alias AsisWeb.Router.Helpers, as: Routes

  @spec render(map()) :: LiveView.Rendered.t()
  def render(%{morbidity_data: morbidity_data} = assigns) do
    incidence_ratio_datasets =
      morbidity_data
      |> Map.get(:selected_period_data, %{})
      |> Map.get(:incidences, [])
      |> Enum.map(fn m ->
        %{label: m.name, data: m.ratios, borderColor: m.color, backgroundColor: m.color, fill: false}
      end)
      |> Jason.encode!()

    incidence_datasets =
      morbidity_data
      |> Map.get(:selected_local_data, %{})
      |> Map.get(:incidences, [])
      |> Enum.map(fn m ->
        %{label: m.name, data: [m.incidence], borderColor: m.color, backgroundColor: m.color, fill: false}
      end)
      |> Jason.encode!()

    selected_morbidity = Map.get(morbidity_data, :selected_morbidity_data, %{})

    map_data =
      selected_morbidity
      |> Map.get(:incidences, [])
      |> Jason.encode!()

    map_legend =
      selected_morbidity
      |> Map.get(:labels, [])
      |> Jason.encode!()

    ~L"""
    <script>
      window.onload = () => {
        let map = L.map('incidence_ratio_map').setView([1.7679, -62.0751], 6)

        let mapData = <%= HTML.raw map_data %>

        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYWx0am9obmRldiIsImEiOiJja2ZvMTJwYWoxazgzMnhtcTFyc2E2ODY4In0.K1nfctebJQMTTWRXJEMFFA', {
          id: 'mapbox/light-v9',
          tileSize: 512,
          zoomOffset: -1
        }).addTo(map)

        let info = L.control()

        info.onAdd = (map) => {
          this._infoDiv = L.DomUtil.create('div', 'asis-map-info asis-hide')
          return this._infoDiv
        }

        info.update = (props) => {
          if (props) {
            let data = mapData.find(data => data.id == props.id)

            if (data !== null && data !== undefined) {
              L.DomUtil.removeClass(this._infoDiv, 'asis-hide')
              this._infoDiv.innerHTML = "<h5>" + props.name + "</h5><b>Incidência</b><br/>" + data.incidence + "<br/><b>Taxa de Incidência</b><br/>" + data.ratio
            }
          } else {
            L.DomUtil.addClass(this._infoDiv, 'asis-hide')
            this._infoDiv.innerHTML = ""
          }
        }

        info.addTo(map)

        let legend = L.control({position: 'bottomright'})

        legend.onAdd = (map) => {
          this._legendDiv = L.DomUtil.create('div', 'asis-map-info asis-map-legend asis-hide')
          let mapLegend = <%= HTML.raw map_legend %>

          this._legendDiv.innerHTML += "<h5>Taxa de Incidência</h5>"

          if (mapLegend !== null) {
            for (let i = 0; i < mapLegend.length; i++) {
              this._legendDiv.innerHTML += '<i style="background:' + mapLegend[i].color + '"></i> ' + mapLegend[i].text + "<br/>"
            }
          }

          return this._legendDiv
        }

        legend.update = (props) => {
          if (props) {
            L.DomUtil.removeClass(this._legendDiv, 'asis-hide')
          } else {
            L.DomUtil.addClass(this._legendDiv, 'asis-hide')
          }
        }

        legend.addTo(map)

        fetch('<%= Routes.static_path(@socket, "/geojson/roraima.json") %>').then((roraima) => roraima.json()).then((roraima) => {
          var geoJson;

          const geoJsonStyle = (feature) => {
            let data = mapData.find(data => data.id == feature.properties.id)

            return {
              fillColor: data !== undefined && data !== null ? data.color : "#AAAAAA",
              weight: 1,
              opacity: 1,
              color: 'white',
              dashArray: '3',
              fillOpacity: 0.7
            }
          }

          const highlightFeature = (e) => {
            let layer = e.target

            layer.setStyle({
              weight: 2,
              color: 'black',
              dashArray: '',
              fillOpacity: 0.7
            })

            if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
              layer.bringToFront()
            }

            info.update(layer.feature.properties)
            legend.update(layer.feature.properties)
          }

          const resetHighlight = (e) => {
            geoJson.resetStyle(e.target)
            info.update()
            legend.update()
          }

          const zoomToFeature = (e) => {
            map.fitBounds(e.target.getBounds());
          }

          const onEachFeature = (feature, layer) => {
            layer.on({
              mouseover: highlightFeature,
              mouseout: resetHighlight,
              click: zoomToFeature
            })
          }

          geoJson = L.geoJson(roraima, {style: geoJsonStyle, onEachFeature: onEachFeature}).addTo(map)
        })

        let incidence_ratio_chart = new ChartJS(
          "incidence_ratio_chart",
          {
            type: "line",
            data: {
              labels: ["2018", "2019", "2020"],
              datasets: <%= HTML.raw incidence_ratio_datasets %>
            },
            options: {
              maintainAspectRatio: false,
              responsive: true,
              legend: false,
              scales: {
                xAxes: [{
                  scaleLabel: {
                    display: true,
                    labelString: "Ano"
                  }
                }],
                yAxes: [{
                  scaleLabel: {
                    display: false,
                    labelString: "Taxa de Incidência"
                  },
                  ticks: {
                    beginAtZero: true
                  }
                }]
              }
            }
          }
        )

        let incidence_chart = new ChartJS(
          "incidence_chart",
          {
            type: "horizontalBar",
            data: {
              labels: ["Total de casos"],
              datasets: <%= HTML.raw incidence_datasets %>
            },
            options: {
              maintainAspectRatio: false,
              responsive: true,
              legend: false,
              tooltips: {
                position: "nearest"
              },
              scales: {
                xAxes: [{
                  scaleLabel: {
                    display: true,
                    labelString: "Incidência"
                  },
                  ticks: {
                    beginAtZero: true
                  }
                }],
                yAxes: [{
                  ticks: {
                    display: false
                  }
                }]
              }
            }
          }
        )
      }
    </script>
    """
  end
end
