class V1::FiasApiController < ApplicationController
  before_action :do_before
  # /fias get action
  # :query - search query (search for)
  # :id - get address by aoGUID or houseGUID(in case building level)
  # :searchBar  - fulltext OneLineString search mode: 1 is ON, other - OFF
  # :level :parent :regionID  - available filter params
  # :limit :offset - pagination params
  # :total_found - number of founded items: 1 is ON, other - OFF
  # :withParent, :fullInfo - items format params mode: 1 is ON, other - OFF
  # returns address items relevant filter params in :data tag
  def index
    useHouseModel = false
    useHouseModel = params[:level] == "building" if !params[:level].blank?
    @res = useHouseModel ? House.actual_only.order(:housenum, :strucnum, :buildnum) : AddressObject.actual_only.order(:formalname)
    if !params[:parent].blank? && !@searchBar
      @res = useHouseModel ? @res.where(aoguid: params[:parent]) : @res.where(parentguid: params[:parent])
      if !@res.exists? && !useHouseModel
        # If nothing is found for the AddressObject, then need to use House-мodel
        @res = House.actual_only.where(aoguid: params[:parent]).order(:housenum, :strucnum, :buildnum)
        useHouseModel = true
      end
    end
    if @searchBar && !params[:query].blank?
      query_array = params[:query].split(",")
      parent_ids = nil
      query = query_array.shift.strip
      while query_array.size > 0
        ids = []
        predicate = AddressObject.select(:aoguid).distinct.full_text_search(query)
        predicate = predicate.where(regioncode: params[:regionID]) if !params[:regionID].blank?
        predicate = predicate.where(parentguid: parent_ids) if parent_ids != nil
        predicate.each do |ao|
          ids.push(ao.aoguid)
        end
        if ids.size == 0
          #if there are no results in this select, the main select call freezes
          #for 15-40 seconds, so we have separate queries with checking
          # the result and do exit if it's empty
          render json: { status: "EMPTY", message: "ничего не надено для <#{query}> " }, status: :ok
          return
        end
        parent_ids = ids.size > 1 ? ids : ids[0]
        query = query_array.shift.strip
      end
      if parent_ids != nil
        @res = @res.where(parentguid: parent_ids) if !useHouseModel
        @res = @res.where(aoguid: parent_ids) if useHouseModel
      end
      @res = @res.name_like(query.downcase.strip)
      if !(useHouseModel || @res.exists?)
        # If nothing is found for the AddressObject, then need to use House-мodel
        @res = House.actual_only.order(:housenum, :strucnum, :buildnum)
        @res = @res.where(aoguid: parent_ids) if parent_ids != nil
        @res = @res.name_like(query.downcase.strip)
        useHouseModel = true
      end
    elsif !params[:query].blank?
      @res = @res.name_like(params[:query].downcase.strip)
    end
    if !params[:regionID].blank?
      @res = useHouseModel ? @res.regioncode(params[:regionID]) : @res.where(regioncode: params[:regionID])
    end
    @res = useHouseModel ? @res.where(houseguid: params[:id]) : @res.where(aoguid: params[:id]) if !params[:id].blank?
    @res = @res.where(aolevel: params[:level].to_sym) if !params[:level].blank? && !useHouseModel && params[:id].blank?
    @total_found = params[:total_found].blank? ? false : @res.count
    use_pagination
    begin
      if @res && @res.length > 0
        results = []
        @res.each do |item|
          result = item.createInfo(@fullInfo, @withParent)
          results.push(result)
        end
        if !@total_found
          render json: { status: "SUCCESS", message: "#{results.length} entries received", data: results }, status: :ok
        else
          render json: { status: "SUCCESS", message: "#{results.length} entries received", total_found: @total_found, data: results }, status: :ok
        end
      else
        render json: { status: "EMPTY", message: "nothing found to the criteria" }, status: :ok
      end
    rescue Exception => e
      render json: { status: "ERROR", message: e.message }, status: :ok
    end
  end

  private

  # Getting pagination param :limit :offset
  def use_pagination
    limit = params[:limit].blank? ? false : params[:limit].to_i
    if limit && limit < Rails.configuration.max_limit && limit > 0
      @res = @res.limit(limit.to_i)
    else
      @res = @res.limit(Rails.configuration.default_limit)
    end
    offset = params[:offset].blank? ? false : params[:offset].to_i
    if offset
      @res = @res.offset(offset)
    end
  end

  # Prepare to using params :withParent, :fullInfo, :searchBar
  def do_before
    @fullInfo = params[:fullInfo] == "1"
    @withParent = params[:withParent] == "1"
    @searchBar = params[:searchBar] == "1"
  end
end
