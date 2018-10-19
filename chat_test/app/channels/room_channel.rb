class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat data
    logger.info data
    ActionCable.server.broadcast "chat_room_channel", chat_message: {message: data["message"], uuid: data["uuid"]}
  end
end
