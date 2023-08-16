# frozen_string_literal: true

module PaginationHandler
  # pagination settings
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_MIN_PER_PAGE = 10
  DEFAULT_MAX_PER_PAGE = 1000

  def paginate_resources(resources)
    page = resources&.paginate(page: page_number, per_page: per_page)
    [page, build_pagination_meta(page)]
  end

  private

  def page_number
    @page_number ||= [Integer(params[:page].presence || DEFAULT_PAGE_NUMBER), DEFAULT_PAGE_NUMBER].max
  end

  def per_page
    @per_page ||= begin
      per = [Integer(params[:per_page].presence || DEFAULT_MIN_PER_PAGE), DEFAULT_MIN_PER_PAGE].max
      [per, DEFAULT_MAX_PER_PAGE].min
    end
  end

  def build_pagination_meta(page)
    {
      total_pages: page&.total_pages,
      page_number: page_number,
      max_per_page: per_page,
      total_resources: page&.total_entries
    }
  end
end
