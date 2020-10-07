defmodule AsisWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @spec error_tag(map(), atom()) :: list(String.t())
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  @spec translate_error({String.t(), keyword() | map()}) :: String.t()
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Talbot.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Talbot.Gettext, "errors", msg, opts)
    end
  end
end
