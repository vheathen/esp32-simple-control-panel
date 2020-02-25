defmodule ControlWeb.PageController do
  use ControlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
