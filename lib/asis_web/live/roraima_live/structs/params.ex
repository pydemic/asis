defmodule AsisWeb.RoraimaLive.Structs.Params do
  @moduledoc """
  `AsisWeb.RoraimaLive` data struct.
  """

  alias Asis.Contexts.Geo
  alias AsisWeb.RoraimaLive.Structs.Params
  alias AsisWeb.RoraimaLive.Structs.Params.Morbidity

  @minimum_year 2018
  @current_year 2020

  @year_from_options Enum.to_list(Range.new(@current_year, @minimum_year))
  @year_to_options [@current_year]

  @minimum_week 1
  @maximum_week 53

  @week_options Enum.to_list(Range.new(@minimum_week, @maximum_week))

  @morbidity_options [
    Morbidity.new(name: "Acidentes com animais peçonhetos", diseases: ~w[X20 X21 X22 X23 X24 X25 X26 X27 X29]),
    Morbidity.new(name: "Chikunguya", sub_diseases: ~w[A92.0]),
    Morbidity.new(name: "Cólera", diseases: ~w[A00]),
    Morbidity.new(name: "Coqueluche", diseases: ~w[A37]),
    Morbidity.new(name: "Dengue", diseases: ~w[A90 A91]),
    Morbidity.new(name: "Difteria", diseases: ~w[A36]),
    Morbidity.new(name: "Doença meningocócica", diseases: ~w[A39]),
    Morbidity.new(name: "Febre amarela, silvestre e urbana", diseases: ~w[A95]),
    Morbidity.new(name: "Febre hemorrágica da dengue", diseases: ~w[A91]),
    Morbidity.new(name: "Hanseníase", diseases: ~w[A30]),
    Morbidity.new(name: "Hepatite aguda C", sub_diseases: ~w[B17.1]),
    Morbidity.new(name: "Hepatite B", diseases: ~w[B16]),
    Morbidity.new(name: "HIV/AIDS", diseases: ~w[B20 B21 B22 B23 B24]),
    Morbidity.new(name: "Leishmaniose tegumentar americana", sub_diseases: ~w[B55.1 B55.2]),
    Morbidity.new(name: "Leishmaniose visceral", sub_diseases: ~w[B55.0]),
    Morbidity.new(name: "Leptospirosis", diseases: ~w[A27]),
    Morbidity.new(name: "Malária", diseases: ~w[B50 B51 B52 B53 B54]),
    Morbidity.new(name: "Meningite", diseases: ~w[A17.0 A39.0], sub_diseases: ~w[A87 G00 G01 G02 G03]),
    Morbidity.new(name: "Mordedura provocada por cão", diseases: ~w[W54]),
    Morbidity.new(name: "Rubéola", diseases: ~w[B06]),
    Morbidity.new(name: "Sarampo", diseases: ~w[B05]),
    Morbidity.new(name: "Sífilis congênita em menores de 1 ano de idade", diseases: ~w[A50]),
    Morbidity.new(name: "Síndrome da rubéola congênita", sub_diseases: ~w[P35.0]),
    Morbidity.new(name: "Tétano neonatal", diseases: ~w[A33]),
    Morbidity.new(name: "Tétano, exceto o tétano neonatal", diseases: ~w[A34]),
    Morbidity.new(name: "Tuberculose", diseases: ~w[A15 A16 A17 A18 A19])
  ]

  @morbidity Enum.at(@morbidity_options, 4)
  @morbidity_id Map.get(@morbidity, :id)

  @type t :: %Params{
          state: %Geo.State{} | nil,
          state_id: integer() | nil,
          year_from: integer(),
          year_from_options: list(integer()),
          year_to: integer(),
          year_to_options: list(integer()),
          week_from: integer(),
          week_from_options: list(integer()),
          week_to: integer(),
          week_to_options: list(integer()),
          health_region: %Geo.HealthRegion{} | nil,
          health_region_id: integer() | nil,
          health_region_options: list(%Geo.HealthRegion{}),
          cities_ids: list(integer()),
          city: %Geo.City{} | nil,
          city_id: integer() | nil,
          city_options: list(%Geo.City{}),
          morbidity: Morbidity.t(),
          morbidity_id: String.t(),
          morbidity_options: list(Morbidity.t())
        }

  defstruct state: nil,
            state_id: nil,
            year_from: @current_year,
            year_from_options: @year_from_options,
            year_to: @current_year,
            year_to_options: @year_to_options,
            week_from: @minimum_week,
            week_from_options: @week_options,
            week_to: @maximum_week,
            week_to_options: @week_options,
            health_region: nil,
            health_region_id: nil,
            health_region_options: [],
            cities_ids: [],
            city: nil,
            city_id: nil,
            city_options: [],
            morbidity: @morbidity,
            morbidity_id: @morbidity_id,
            morbidity_options: @morbidity_options

  @spec current_year :: integer()
  def current_year, do: @current_year

  @spec maximum_week :: integer()
  def maximum_week, do: @maximum_week
end
