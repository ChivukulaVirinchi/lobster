defmodule LobsterWeb.VideoLive.Index do
  use LobsterWeb, :live_view

  alias Lobster.Multimedia
  alias Lobster.Multimedia.Video
  alias Lobster.Accounts



  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :videos, Multimedia.list_videos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    if socket.assigns.current_user == Multimedia.get_video!(id).user do
      socket
      |> assign(:page_title, "Edit Video")
      |> assign(:categories, Multimedia.list_alphabetical_categories())
      |> assign(:video, Multimedia.get_user_video!(socket.assigns.current_user, id))

    else
      socket
      |> redirect(to: ~p"/videos")
      |> put_flash(:error, "You can only edit your own videos")
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Video")
    |> assign(:categories, Multimedia.list_alphabetical_categories())
    |> assign(:video, %Video{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Videos")
    |> assign(:categories, Multimedia.list_alphabetical_categories())
    |> assign(:video, nil)
  end

  @impl true
  def handle_info({LobsterWeb.VideoLive.FormComponent, {:saved, video}}, socket) do
    {:noreply, stream_insert(socket, :videos, video)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    video = Multimedia.get_user_video!(socket.assigns.current_user, id)
    {:ok, _} = Multimedia.delete_video(video)

    {:noreply, stream_delete(socket, :videos, video)}
  end


end
