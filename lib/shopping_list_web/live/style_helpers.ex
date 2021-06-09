defmodule ShoppingListWeb.StyleHelpers do
  @moduledoc """
  Functions for generating CSS styling based on a given user's theme selection.
  """

  alias ShoppingList.Accounts.User

  def background_color(nil), do: background_color(%User{theme: "purple"})

  def background_color(%User{theme: theme}) do
    case theme do
      "gray" -> "#9CA3AF"
      "red" -> "#F87171"
      "yellow" -> "#FBBF24"
      "green" -> "#34D399"
      "blue" -> "#60A5FA"
      "indigo" -> "#818CF8"
      "purple" -> "#A78BFA"
      "pink" -> "#F472B6"
    end
  end

  def user_menu_bg(nil), do: user_menu_bg(%User{theme: "purple"})

  def user_menu_bg(%User{theme: theme}) do
    case theme do
      "gray" -> "bg-gray-800"
      "red" -> "bg-red-800"
      "yellow" -> "bg-yellow-800"
      "green" -> "bg-green-800"
      "blue" -> "bg-blue-800"
      "indigo" -> "bg-indigo-800"
      "purple" -> "bg-purple-800"
      "pink" -> "bg-pink-800"
    end
  end

  def category_bg(nil), do: category_bg(%User{theme: "purple"})

  def category_bg(%User{theme: theme}) do
    case theme do
      "gray" -> "bg-gray-200"
      "red" -> "bg-red-200"
      "yellow" -> "bg-yellow-200"
      "green" -> "bg-green-200"
      "blue" -> "bg-blue-200"
      "indigo" -> "bg-indigo-200"
      "purple" -> "bg-purple-200"
      "pink" -> "bg-pink-200"
    end
  end

  def category_header_bg(nil), do: category_header_bg(%User{theme: "purple"})

  def category_header_bg(%User{theme: theme}) do
    case theme do
      "gray" -> "bg-gray-600"
      "red" -> "bg-red-600"
      "yellow" -> "bg-yellow-600"
      "green" -> "bg-green-600"
      "blue" -> "bg-blue-600"
      "indigo" -> "bg-indigo-600"
      "purple" -> "bg-purple-600"
      "pink" -> "bg-pink-600"
    end
  end

  def category_header_font(nil), do: category_header_font(%User{theme: "purple"})

  def category_header_font(%User{theme: theme}) do
    case theme do
      "gray" -> "text-gray-100 subpixel-antialiased"
      "red" -> "text-red-100 subpixel-antialiased"
      "yellow" -> "text-yellow-100 subpixel-antialiased"
      "green" -> "text-green-100 subpixel-antialiased"
      "blue" -> "text-blue-100 subpixel-antialiased"
      "indigo" -> "text-indigo-100 subpixel-antialiased"
      "purple" -> "text-purple-100 subpixel-antialiased"
      "pink" -> "text-pink-100 subpixel-antialiased"
    end
  end

  def active_user_font(nil), do: active_user_font(%User{theme: "purple"})

  def active_user_font(%User{theme: theme}) do
    case theme do
      "gray" -> "text-gray-300"
      "red" -> "text-red-300"
      "yellow" -> "text-yellow-300"
      "green" -> "text-green-300"
      "blue" -> "text-blue-300"
      "indigo" -> "text-indigo-300"
      "purple" -> "text-purple-300"
      "pink" -> "text-pink-300"
    end
  end

  def form_border_color(nil), do: form_border_color(%User{theme: "purple"})

  def form_border_color(%User{theme: theme}) do
    case theme do
      "gray" -> "focus:border-gray-600"
      "red" -> "focus:border-red-600"
      "yellow" -> "focus:border-yellow-600"
      "green" -> "focus:border-green-600"
      "blue" -> "focus:border-blue-600"
      "indigo" -> "focus:border-indigo-600"
      "purple" -> "focus:border-purple-600"
      "pink" -> "focus:border-pink-600"
    end
  end

  def category_ring_border(nil), do: category_ring_border(%User{theme: "purple"})

  def category_ring_border(%User{theme: theme}) do
    case theme do
      "gray" -> "focus:ring focus:ring-gray-200"
      "red" -> "focus:ring focus:ring-red-200"
      "yellow" -> "focus:ring focus:ring-yellow-200"
      "green" -> "focus:ring focus:ring-green-200"
      "blue" -> "focus:ring focus:ring-blue-200"
      "indigo" -> "focus:ring focus:ring-indigo-200"
      "purple" -> "focus:ring focus:ring-purple-200"
      "pink" -> "focus:ring focus:ring-pink-200"
    end
  end
end
