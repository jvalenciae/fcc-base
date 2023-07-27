# frozen_string_literal: true

module ApiResponses
  def render_response(data: nil, status_code: :ok, serializer: nil, meta: nil, serializer_params: {})
    render_no_content and return if status_code == :no_content

    if serializer.present?
      if data.respond_to?(:each)
        render_multiple_response(data, status_code, serializer, meta, serializer_params)
      else
        render_single_response(data, status_code, serializer, meta, serializer_params)
      end
    else
      render_raw_response(data, status_code, meta)
    end
  end

  private

  def render_no_content
    head :no_content
  end

  def render_raw_response(data, status_code, meta)
    render json: {
      status: status_code,
      data: data,
      meta: meta
    }, status: status_code
  end

  def render_multiple_response(data, status_code, serializer, meta, serializer_params)
    render json: {
      status: status_code,
      data: ActiveModel::Serializer::CollectionSerializer.new(
        data, {
          serializer: serializer,
          serializer_params: serializer_params
        }
      ),
      meta: meta
    }, status: status_code
  end

  def render_single_response(data, status_code, serializer, meta, serializer_params)
    render json: {
      status: status_code,
      data: serializer.new(data, { serializer_params: serializer_params }),
      meta: meta
    }, status: status_code
  end
end
