defmodule ShoppingListWeb.PageLiveTest do
  use ShoppingListWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "New List"
    assert render(page_live) =~ "New List"
  end
end
