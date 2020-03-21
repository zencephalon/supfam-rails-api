require 'test_helper'

class SeensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seen = seens(:one)
  end

  # test "should get index" do
  #   get seens_url, as: :json
  #   assert_response :success
  # end

  # test "should create seen" do
  #   assert_difference('Seen.count') do
  #     post seens_url, params: { seen: { battery: @seen.battery, cellular_generation: @seen.cellular_generation, client_type: @seen.client_type, lat: @seen.lat, long: @seen.long, network_strength: @seen.network_strength, network_type: @seen.network_type, user_id: @seen.user_id } }, as: :json
  #   end

  #   assert_response 201
  # end

  # test "should show seen" do
  #   get seen_url(@seen), as: :json
  #   assert_response :success
  # end

  # test "should update seen" do
  #   patch seen_url(@seen), params: { seen: { battery: @seen.battery, cellular_generation: @seen.cellular_generation, client_type: @seen.client_type, lat: @seen.lat, long: @seen.long, network_strength: @seen.network_strength, network_type: @seen.network_type, user_id: @seen.user_id } }, as: :json
  #   assert_response 200
  # end

  # test "should destroy seen" do
  #   assert_difference('Seen.count', -1) do
  #     delete seen_url(@seen), as: :json
  #   end

  #   assert_response 204
  # end
end
