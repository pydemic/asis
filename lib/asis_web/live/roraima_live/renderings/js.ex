defmodule AsisWeb.RoraimaLive.Renderings.JS do
  @moduledoc """
  Render the dashboard JavaScript section.
  """

  import Phoenix.LiveView.Helpers, only: [sigil_L: 2]
  alias Phoenix.{HTML, LiveView}
  alias AsisWeb.Router.Helpers, as: Routes

  @spec render(map()) :: LiveView.Rendered.t()
  def render(assigns) do
    incidence_ratio_datasets =
      assigns
      |> Map.get(:morbidities, [])
      |> Enum.map(fn m ->
        %{label: m.name, data: m.ratios_per_year, borderColor: m.color, backgroundColor: m.color, fill: false}
      end)
      |> Jason.encode!()

    incidence_datasets =
      assigns
      |> Map.get(:morbidities, [])
      |> Enum.map(fn m ->
        %{label: m.name, data: [m.incidence_from_period], borderColor: m.color, backgroundColor: m.color, fill: false}
      end)
      |> Jason.encode!()

    map_data =
      assigns
      |> Map.get(:cities_morbidity, [])
      |> Jason.encode!()

    map_legend =
      assigns
      |> Map.get(:cities_morbidity_legend, [])
      |> Jason.encode!()

    death_chart_cities_names =
      assigns
      |> Map.get(:city_options, [])
      |> Enum.map(&elem(&1, 0))
      |> Jason.encode!()

    #   [
    #     {
    #       label: "Doenças infecciosas e parasitárias",
    #       backgroundColor: "#A989C5",
    #       borderColor: "#A989C5",
    #       data: [10, 15, 20, 25]
    #     },
    #     {
    #       label: "Neoplasmas",
    #       backgroundColor: "#98D9D9",
    #       borderColor: "#98D9D9",
    #       data: [25, 20, 15, 10]
    #     },
    #     {
    #       label: "Doenças do sangue e dos órgãos hematopoéticos e alguns transtornos imunitários",
    #       backgroundColor: "#F2A86F",
    #       borderColor: "#F2A86F",
    #       data: [65, 65, 65, 65]
    #     }
    #   ]
    # }

    death_chart_datasets =
      assigns
      |> Map.get(:death_chart_datasets, [])
      |> Jason.encode!()

    ~L"""
    <script>
      window.onload = () => {
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

          for (let i = 0; i < mapLegend.length; i++) {
            this._legendDiv.innerHTML += '<i style="background:' + mapLegend[i].color + '"></i> ' + mapLegend[i].label + "<br/>"
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

        let death_ratio_chart = new ChartJS(
          "death_ratio_chart",
          {
            type: "bar",
            data: {
              labels: <%= HTML.raw death_chart_cities_names %>,
              datasets: <%= HTML.raw death_chart_datasets %>
            },
            options: {
              maintainAspectRatio: true,
              responsive: true,
              legend: false,
              scales: {
                xAxes: [{
                  stacked: true,
                  scaleLabel: {
                    display: true,
                    labelString: "Municípios"
                  },
                  ticks: {
                    beginAtZero: true
                  }
                }],
                yAxes: [{
                  stacked: true,
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
